import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/auth_exception.dart';
import '../models/auth.dart';

class UpdateAuthData extends StatefulWidget {
  const UpdateAuthData({Key? key}) : super(key: key);

  @override
  State<UpdateAuthData> createState() => _UpdateAuthDataState();
}

class _UpdateAuthDataState extends State<UpdateAuthData> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final Map<String, String> _authData = {
    'name': '',
  };

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um Erro'),
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

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);
    setState(
      () => _isLoading = true,
    );
    print(_authData);

    try {
      await auth
          .editData(
            _authData['name']!,
          )
          .then(
            (value) => Navigator.of(context).pop(),
          );
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      print("Error...");
      print(error);
      _showErrorDialog('Ocorreu um erro inesperado!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 0,
      child: SizedBox(
        height: deviceSize.width * 0.50,
        width: deviceSize.width * 0.95,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: TextFormField(
                  key: const ValueKey('name'),
                  initialValue: _authData['name'] == ''
                      ? Provider.of<Auth>(context, listen: false).name
                      : _authData['name'],
                  onChanged: (name) => _authData['name'] = name,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    hintText: "Digite aqui seu nome",
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onSaved: (name) => _authData['name'] = name ?? '',
                  validator: (_name) {
                    final name = _name ?? '';
                    if (name.trim().isEmpty) {
                      return 'Dados inválidos';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 8),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  /*onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.main);
                  }, //ajustar*/
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    fixedSize: const Size(290, 40),
                    backgroundColor: const Color.fromARGB(255, 102, 91, 196),
                  ),
                  child: const Text(
                    'Salvar',
                    textAlign: TextAlign.left,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
