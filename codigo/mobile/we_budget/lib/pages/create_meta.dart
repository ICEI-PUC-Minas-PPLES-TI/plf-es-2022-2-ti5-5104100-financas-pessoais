import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:provider/provider.dart';

import '../exceptions/auth_exception.dart';
import '../models/category.dart';
import '../utils/app_routes.dart';

class CreateMeta extends StatefulWidget {
  const CreateMeta({super.key});

  @override
  State<CreateMeta> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateMeta> {
  final _formKeyCreateMeta = GlobalKey<FormState>();
  final Map<String, dynamic> createCategoryData = {
    'categoryMeta': '',
    'valueMeta': '',
  };
  int? codeCreateMeta = 984405;

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.material]);

    setState(
      () {
        codeCreateMeta = icon?.codePoint;
        createCategoryData['valueMeta'] = codeCreateMeta!;
      },
    );
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

  Future<void> _submitCreateMeta() async {
    final isValid = _formKeyCreateMeta.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    _formKeyCreateMeta.currentState?.save();
    Category category = Provider.of(context, listen: false);

    try {
      await category.cadastro(
        createCategoryData['categoryMeta']!,
        createCategoryData['valueMeta']!,
      );
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    String? categorySelected =
        ModalRoute.of(context)!.settings.arguments.toString();
    print("----->");
    print(categorySelected.toString() == 'null');
    createCategoryData['categoryMeta'] = categorySelected;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.05),
        child: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xFFC84CF4),
                    Color.fromARGB(255, 41, 19, 236),
                    Color(0xFF923DF8),
                  ]),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFC84CF4),
              Color.fromARGB(255, 41, 19, 236),
              Color(0xFF923DF8),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.only(top: 0),
          child: Container(
            height: height * 1,
            margin: const EdgeInsetsDirectional.all(10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(20),
                topEnd: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                Column(
                  children: const [
                    Text(
                      "Cadastro de Meta",
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 28,
                        color: Colors.blueGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                    key: _formKeyCreateMeta,
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () => {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.listCategory),
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 102, 91, 196)),
                          ),
                          child: const Text(
                            "Selecionar categoria",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          categorySelected == 'null' ? "" : categorySelected,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 102, 91, 196),
                            fontSize: 25,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 70,
                        ),
                        Container(
                          margin:
                              const EdgeInsetsDirectional.only(bottom: 30.0),
                          child: TextFormField(
                            key: const ValueKey('valor'),
                            decoration: const InputDecoration(
                              labelText: 'Valor da Meta',
                              hintText: "Digite aqui o valor da meta",
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            onSaved: (categoryMeta) =>
                                createCategoryData['categoryMeta'] =
                                    categoryMeta,
                            validator: (validacao) {
                              final name = validacao ?? '';
                              if (name.trim().isEmpty) {
                                return 'Dados inválidos';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _submitCreateMeta,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          fixedSize: const Size(290, 40),
                          backgroundColor:
                              const Color.fromARGB(255, 102, 91, 196),
                        ),
                        child: const Text(
                          "Cadastrar",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
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
