import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:we_budget/models/store.dart';

import '../exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTimer;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  Future<void> _authenticate(
      String name, String email, String password, String urlFragment) async {
    final url = 'http://localhost:5001/api/User/$urlFragment';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      },
      body: jsonEncode(
        {
          'email': email,
          'senha': password,
          //'senhaConfimacao': password,
        },
      ),
    );
    print("Response....");
    print(response.body);
    final body = jsonDecode(response.body);
    print(body);
    if (body['sucesso'] != true) {
      throw AuthException(body['erros'].toString());
    } else {
      _token = body['accessToken'];
      _email = body['email'];
      _userId = body['userId'];

      print(body);
      //var expireTeste = int.parse(body['expiresIn']);

      _expiryDate = DateTime.now().add(
        const Duration(
          seconds: 3,
        ),
      );

      Store.saveMap(
        'userData',
        {
          'token': _token,
          'email': _email,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );

      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> signup(String name, String email, String password) async {
    return _authenticate(name, email, password, 'cadastro');
  }

  Future<void> login(String name, String email, String password) async {
    return _authenticate(name, email, password, 'login');
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');
    print(userData);

    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _expiryDate = null;
    _clearLogoutTimer();
    Store.remove('userData').then((_) {
      notifyListeners();
    });
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearLogoutTimer();
    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(
      Duration(seconds: 3),
      logout,
    );
  }
}
