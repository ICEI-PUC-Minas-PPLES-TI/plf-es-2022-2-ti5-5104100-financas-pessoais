import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

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
  int? codigoCategoria = 57522;

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.material]);

    setState(() {
      codigoCategoria = icon?.codePoint;
      _categoriaData['codeCategoria'] = codigoCategoria!;
    });
  }

  Future<void> _submitCategoria() async {
    final isValid = _formKeyCategoria.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    _formKeyCategoria.currentState?.save();

    print("submit....");
    print(_categoriaData['nameCategoria']);
    print(_categoriaData['codeCategoria']);
    //Auth auth = Provider.of(context, listen: false);

    /*try {
      await auth.login(
        _authData['name']!,
        _authData['email']!,
        _authData['password']!,
      );
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      print(error);
      _showErrorDialog('Ocorreu um erro inesperado!');
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          hintText: "Digite aqui sa descrição da categoria",
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onSaved: (nameCategoria) =>
                            _categoriaData['nameCategoria'] = nameCategoria,
                        validator: (_name) {
                          final name = _name ?? '';
                          if (name.trim().isEmpty) {
                            return 'Dados inválidos';
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _pickIcon,
                      child: const Text('Clique aqui para Escolha o ícone'),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    height: 79,
                    width: 115,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadiusDirectional.all(
                        Radius.circular(15.0),
                      ),
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
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
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
            ),
          ],
        ),
      ),
    );
  }
}
