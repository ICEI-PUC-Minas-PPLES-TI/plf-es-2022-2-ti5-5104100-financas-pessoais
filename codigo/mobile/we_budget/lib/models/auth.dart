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

  Future<void> _authenticateLogin(
      String name, String email, String password, String urlFragment) async {
    print("Entrou autenticação...");
    final url = 'https://webudgetpuc.azurewebsites.net/api/User/$urlFragment';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          'email': email,
          'senha': password,
          'senhaConfimacao': password,
        },
      ),
    );

    final body = jsonDecode(response.body);
    print("Response....");
    print(body);
    if (body['sucesso'] != true) {
      throw AuthException(body['erros'].toString());
    } else {
      _token = body['accessToken'];
      _email = body['email'];
      _userId = body['userId'];

      _expiryDate = DateTime.now().add(
        Duration(
          seconds: body['expiresIn'],
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

  Future<void> _authenticateCadastro(
      String name, String email, String password, String urlFragment) async {
    print("Entrou autenticação...");
    final url = 'https://webudgetpuc.azurewebsites.net/api/User/$urlFragment';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          'email': email,
          'senha': password,
          'senhaConfimacao': password,
        },
      ),
    );

    final body = jsonDecode(response.body);
    print("Response....");
    print(body);
    if (body['sucesso'] != true) {
      throw AuthException(body['erros'].toString());
    }

    notifyListeners();
  }

  Future<void> signup(String name, String email, String password) async {
    return _authenticateCadastro(name, email, password, 'cadastro');
  }

  Future<void> login(String name, String email, String password) async {
    return _authenticateLogin(name, email, password, 'login');
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
      Duration(seconds: timeToLogout ?? 0),
      logout,
    );
  }
}
