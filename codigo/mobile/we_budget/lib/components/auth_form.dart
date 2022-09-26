import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/auth_exception.dart';
import '../models/auth.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'name': '',
    'email': '',
    'password': '',
  };

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignup() => _authMode == AuthMode.signup;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signup;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreo um Erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    print(_authData);
    if (!isValid) {
      return;
    }

    setState(
      () => _isLoading = true,
    );

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        // Login
        await auth.login(
          _authData['name']!,
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        // Registrar
        await auth.signup(
          _authData['name']!,
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(
      () => _isLoading = false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 50.0), //Nataniel
      child: Card(
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(16),
          height: _isLogin() ? 400 : 500,
          width: deviceSize.width * 0.95,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (_isSignup())
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      hintText: "Digite aqui seu nome",
                    ),
                    keyboardType: TextInputType.name,
                    onSaved: (name) => _authData['name'] = name ?? '',
                    validator: (_name) {
                      final name = _name ?? '';
                      if (name.trim().isEmpty) {
                        return 'Dados inválidos';
                      }
                      return null;
                    },
                  ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: "Digite aqui seu e-mail",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (email) => _authData['email'] = email ?? '',
                  validator: (_email) {
                    final email = _email ?? '';
                    if (email.trim().isEmpty || !email.contains('@')) {
                      return 'Informe um e-mail válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    hintText: "Digite aqui sua senha",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  controller: _passwordController,
                  onSaved: (password) => _authData['password'] = password ?? '',
                  validator: (_password) {
                    final password = _password ?? '';
                    if (password.isEmpty || password.length < 5) {
                      return 'Informe uma senha válida';
                    }
                    return null;
                  },
                ),
                if (_isSignup())
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Confirmar Senha',
                      hintText: "Digite a confirmação da senha",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    validator: _isLogin()
                        ? null
                        : (_password) {
                            final password = _password ?? '';
                            if (password != _passwordController.text) {
                              return 'Senhas informadas não conferem.';
                            }
                            return null;
                          },
                  ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 20,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text(
                      _authMode == AuthMode.login ? 'ENTRAR' : 'REGISTRAR',
                      textAlign: TextAlign.left,
                    ),
                  ),
                Container(
                  margin: const EdgeInsetsDirectional.only(top: 10.0),
                  child: ElevatedButton(
                    onPressed: _switchAuthMode,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 20,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text(
                      _isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
