import 'package:flutter/cupertino.dart';

class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'E-mail já cadastrado.',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida!',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Acesso bloqueado temporariamente. Tente mais tarde.',
    'EMAIL_NOT_FOUND': 'E-mail não encontrado.',
    '[Usuário ou senha estão incorretos]': 'Senha informada não confere.',
    'USER_DISABLED': 'A conta do usuário foi desabilitada.',
    'Connection timed out': 'Connection timed out',
  };

  final String key;

  AuthException(this.key);

  @override
  String toString() {
    print(key);
    return errors[key] ?? 'Ocorreu um erro no processo de autenticação.';
  }
}
