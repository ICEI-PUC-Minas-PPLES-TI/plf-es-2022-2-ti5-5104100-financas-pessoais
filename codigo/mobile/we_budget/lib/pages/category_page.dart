import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:provider/provider.dart';

import '../exceptions/auth_exception.dart';
import '../models/category.dart';

class Categoria extends StatefulWidget {
  const Categoria({super.key});

  @override
  State<Categoria> createState() => _CategoriaState();
}

class _CategoriaState extends State<Categoria> {
  final _formKeyCategoria = GlobalKey<FormState>();
  final Map<String, dynamic> _categoriaData = {
    'nameCategoria': '',
    'codeCategoria': '',
  };
  int? codigoCategoria = 984405;

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.material]);

    setState(() {
      codigoCategoria = icon?.codePoint;
      _categoriaData['codeCategoria'] = codigoCategoria!;
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

  Future<void> _submitCategoria() async {
    final isValid = _formKeyCategoria.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    _formKeyCategoria.currentState?.save();
    Category category = Provider.of(context, listen: false);

    try {
      await category.cadastro(
        _categoriaData['nameCategoria']!,
        _categoriaData['codeCategoria']!,
      );
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cadastro de categoria",
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 102, 91, 196),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKeyCategoria,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsetsDirectional.only(bottom: 20.0),
                      child: TextFormField(
                        key: const ValueKey('descricao'),
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
                          hintText: "Digite aqui a descrição da categoria",
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onSaved: (nameCategoria) =>
                            _categoriaData['nameCategoria'] = nameCategoria,
                        validator: (validacao) {
                          final name = validacao ?? '';
                          if (name.trim().isEmpty) {
                            return 'Dados inválidos';
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _pickIcon,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 102, 91, 196),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        fixedSize: const Size(290, 43),
                      ),
                      child: const Text('Clique aqui para escolher o ícone'),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 90,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Icon(
                      IconData(codigoCategoria ?? 0,
                          fontFamily: 'MaterialIcons'),
                      size: 50,
                      color: const Color.fromARGB(255, 102, 91, 196),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _submitCategoria,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      fixedSize: const Size(290, 40),
                      backgroundColor: const Color.fromARGB(255, 102, 91, 196),
                    ),
                    child: const Text(
                      "Cadastrar",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
