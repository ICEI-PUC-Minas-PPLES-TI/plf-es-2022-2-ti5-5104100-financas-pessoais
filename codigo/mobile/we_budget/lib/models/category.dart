import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../exceptions/auth_exception.dart';

class Category with ChangeNotifier {
  Future<void> _cadastro(String name, int code) async {
    const url = 'http://localhost:5001/api/Categoria';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      },
      body: jsonEncode(
        {
          'nome': name,
          'codigo': code,
        },
      ),
    );
    print("Response....");
    print(response.body);
    final body = jsonDecode(response.body);
    print(body);
    if (body['sucesso'] != true) {
      throw AuthException(body['erros'].toString());
    }

    notifyListeners();
  }

  Future<void> cadastro(String name, int code) async {
    print("Teste.....");
    print(code);
    print(name);
    return _cadastro(name, code);
  }
}
