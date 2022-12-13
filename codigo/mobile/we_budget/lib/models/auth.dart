import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:we_budget/utils/shared_preference.dart';

import '../exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  String? _name;
  // String name = '';
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

  String? get name {
    return isAuth ? _name : null;
  }

  // Future<String> nameUser() async {
  //   Map<String, dynamic> userData = await Store.getMap('userName');
  //   name = userData['name'];
  //   return name;
  // }

  Future<Map<String, dynamic>> authenticateLogin(
      String name, String email, String password, String urlFragment) async {
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
        },
      ),
    );

    final body = jsonDecode(response.body);
    // print("Retorno login....");
    // print(body);

    if (body['sucesso'] != true) {
      throw AuthException(body['erros'].toString());
    } else {
      _token = body['accessToken'];
      _email = email;
      _userId = body['userId'];
      _name = body['firstName'];

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
          'firstName': _name,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );

      _autoLogout();
      notifyListeners();

      return body;
    }
  }

  Future<void> _editDataAuth(String name) async {
    Map<String, dynamic> userData = await Store.getMap('userData');
    String email = userData['email'];
    print(email);
    String token = userData['token'];
    print(token);
    print("Antes post");
    const url = 'https://webudgetpuc.azurewebsites.net/api/User/updateName';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "Accept": email,
      },
      body: jsonEncode(
        {
          'firstName': name,
          'lastName': name,
          'email': 'nataniel@teste15.com.br',
        },
      ),
    );

    final body = jsonDecode(response.body);
    print("Retorno login....");
    print(body);

    if (body['firstName'] != '') {
      _name = body['firstName'];

      // Store.saveMap(
      //   'userData',
      //   {
      //     'firstName': _name,
      //   },
      // );
      notifyListeners();
    }
  }

  Future<void> _authenticateCadastro(
      String name, String email, String password, String urlFragment) async {
    final url = 'https://webudgetpuc.azurewebsites.net/api/User/$urlFragment';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(
        {
          'firstName': name,
          'lastName': name,
          'email': email,
          'senha': password,
          'senhaConfimacao': password,
        },
      ),
    );

    // Store.saveMap(
    //   'userName',
    //   {
    //     'name': name,
    //   },
    // );

    final body = jsonDecode(response.body);
    if (body['sucesso'] != true) {
      throw AuthException(body['erros'].toString());
    }

    notifyListeners();
  }

  Future<void> signup(String name, String email, String password) async {
    return _authenticateCadastro(name, email, password, 'cadastro');
  }

  Future<Map<String, dynamic>> login(
      String name, String email, String password) async {
    return authenticateLogin(name, email, password, 'login');
  }

  Future<void> editData(String name) async {
    return _editDataAuth(name);
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');

    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _name = userData['firstName'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _name = null;
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
