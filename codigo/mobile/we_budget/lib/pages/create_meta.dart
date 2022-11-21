import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/Repository/metas_repository.dart';
import '../exceptions/auth_exception.dart';
import '../utils/app_routes.dart';

class CreateMeta extends StatefulWidget {
  const CreateMeta({super.key});

  @override
  State<CreateMeta> createState() => _CreateMetasState();
}

class _CreateMetasState extends State<CreateMeta> {
  final _formKeyCreateMeta = GlobalKey<FormState>();
  final Map<String, dynamic> createMetasData = {
    'categoryId': '',
    'budgetValue': '',
    'budgetDate': DateTime.now(), //pegar a data corrente
    'active': false,
  };
  int? codeCreateMeta = 984405;

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
    print(createMetasData);
    if (!isValid) {
      return;
    }
    _formKeyCreateMeta.currentState?.save();
    RepositoryMetas metas = Provider.of(context, listen: false);

    // try {
    //   await metas.insertMetas(
    //     createMetasData['categoryMeta']!,
    //     createMetasData['valueMeta']!,
    //   );
    // } on AuthException catch (error) {
    //   _showErrorDialog(error.toString());
    // } catch (error) {
    //   _showErrorDialog('Ocorreu um erro inesperado!');
    // }
  }

  bool status = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    String? categorySelected =
        ModalRoute.of(context)!.settings.arguments.toString();
    createMetasData['categoryId'] = categorySelected;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.05),
        child: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF923DF8),
                  Color(0xFF4C94F8),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF923DF8),
              Color(0xFF4C94F8),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
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
                          Navigator.of(context).pushNamed(
                              AppRoutes.listCategory,
                              arguments: "CreateMeta"),
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
                        margin: const EdgeInsetsDirectional.only(bottom: 30.0),
                        child: TextFormField(
                          key: const ValueKey('valor'),
                          decoration: const InputDecoration(
                            labelText: 'Valor da Meta',
                            hintText: "Digite aqui o valor da meta",
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          textInputAction: TextInputAction.next,
                          onSaved: (budgetValue) =>
                              createMetasData['budgetValue'] =
                                  double.parse(budgetValue ?? '0'),
                          validator: (validacao) {
                            final priceString = validacao ?? '';
                            if (priceString.trim().isEmpty) {
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
              Container(
                height: 40.0,
                child: const Text("Transação recorrente"),
              ),
              FlutterSwitch(
                activeColor: const Color(0xFF45CFF1),
                activeText: "Sim",
                inactiveText: "Não",
                inactiveColor: const Color(0xFF45CFF1),
                width: 120.0,
                height: 40.0,
                valueFontSize: 20.0,
                toggleSize: 45.0,
                value: status,
                borderRadius: 30.0,
                padding: 6.0,
                showOnOff: true,
                onToggle: (val) {
                  setState(
                    () {
                      status = val;
                      createMetasData['active'] = val;
                    },
                  );
                },
              ),
              const SizedBox(
                height: 40,
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
    );
  }
}
