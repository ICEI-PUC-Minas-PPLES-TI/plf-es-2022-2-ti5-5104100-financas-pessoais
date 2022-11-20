import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:we_budget/models/transactions.dart';
import '../Repository/transaction_repository.dart';
import '../exceptions/auth_exception.dart';
import '../models/store.dart';
import '../utils/app_routes.dart';

class TransacaoFormPage extends StatefulWidget {
  const TransacaoFormPage({Key? key}) : super(key: key);

  @override
  State<TransacaoFormPage> createState() => _TransacaoFormPageState();
}

class _TransacaoFormPageState extends State<TransacaoFormPage> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, Object> _transactionData = {
    'IdTransaction': '',
    'Category': '',
    'TransactionType': '0',
    'Description': '',
    'TransactionDate': '',
    'PaymentValue': '',
    'PaymentType': '',
    'Longitude': '',
    'Latitude': '',
    'Address': '',
  };

  static const List<String> list = <String>[
    'Crédito',
    'Débito',
    'Cheque',
    'Pix',
    'Dinheiro'
  ];
  String dropdownValue = list.first;

  String? dadosLoc;

  _recuperaDadosLocalizacao() async {
    print("Entrou recupera dados localização");
    Map<String, dynamic> dados = await Store.getMap('localizacao');
    String latitude = dados['latitude'];
    String longitude = dados['longitude'];
    String address = dados['address'];

    _transactionData['Longitude'] = longitude;
    _transactionData['Latitude'] = latitude;
    _transactionData['Address'] = address;

    print("Dados....$latitude");
    print("Dados....$longitude");
    print("Dados....$address");
  }

  _recuperaDadosCategoria() async {
    print("Entrou recupera dados categoria");
    Map<String, dynamic> dados = await Store.getMap('category');
    String category = dados['category'];
    _transactionData['Category'] = category;

    print("Dados....$category");
    _submitForm();
  }

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }

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

  Future<void> _submitForm() async {
    print(_transactionData.toString());
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    RepositoryTransaction transaction = Provider.of(context, listen: false);

    try {
      await transaction.saveTransactionSql(_transactionData);
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      print("Erro....");
      print(error);
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    // Provider.of<RepositoryTransaction>(
    //   context,
    //   listen: false,
    // ).insertTransacao(
    //   TransactionModel(
    //     idTransaction: '20',
    //     name: _transactionData['Description'].toString(),
    //     categoria: _transactionData['Category'].toString(),
    //     data: _transactionData['TransactionDate'].toString(),
    //     valor: double.parse(_transactionData['PaymentValue'].toString()),
    //     formaPagamento: _transactionData['PaymentType'].toString(),
    //     tipoTransacao:
    //         int.parse(_transactionData['TransactionType'].toString()),
    //     location: TransactionLocation(
    //         latitude: double.parse(_transactionData['Longitude'].toString()),
    //         longitude: double.parse(_transactionData['Latitude'].toString()),
    //         address: _transactionData['Address'].toString()),
    //   ),
    // );

    Navigator.of(context).pushNamed(AppRoutes.menuPrincipal);
  }

  void _loadFormData(TransactionModel transferencia) {
    print(transferencia.idTransaction);
    _transactionData['IdTransaction'] = transferencia.idTransaction;
    _transactionData['Description'] = transferencia.name;
    _transactionData['Category'] = transferencia.categoria;
    _transactionData['PaymentValue'] = transferencia.valor;
    _transactionData['TransactionDate'] = transferencia.data;
    _transactionData['PaymentType'] = transferencia.formaPagamento;
    _transactionData['TransactionType'] = transferencia.tipoTransacao;
    _transactionData['Address'] = transferencia.location.address.toString();
  }

  TextEditingController dateInput = TextEditingController();
  int tipoTransaction = 0;

  @override
  Widget build(BuildContext context) {
    // String? categorySelected = 'teste';

    // Map<String, dynamic> argument =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    // print(argument);

    // String page = argument['page'] as String;

    // Object data = argument['itemByIndex'];
    // print(data as TransacaoFormPage);

    // if (page == 'listTransaction') {
    //   _loadFormData(data as TransactionModel);
    // }

    // else if (page == 'category') {
    //   _transactionData['Category'] = data as String;
    // }

    if (ModalRoute.of(context)!.settings != null &&
        ModalRoute.of(context)!.settings.arguments != null) {
      final argument =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      String page = argument['page'] as String;
      Object data = argument['itemByIndex'];
      print(data);

      if (page == 'listTransaction') {
        setState(() {
          _loadFormData(data as TransactionModel);
          dateInput = TextEditingController(
              text: _transactionData['TransactionDate'].toString());
          dropdownValue = _transactionData['PaymentType'].toString();
          tipoTransaction =
              int.parse(_transactionData['TransactionType'].toString());
        });
      }
    } else {
      tipoTransaction = 0;
      dropdownValue = list.first;
      dateInput = TextEditingController();
    }

    String? categorySelected = 'teste';
    if (_transactionData.isEmpty) {
      final transaction =
          ModalRoute.of(context)?.settings.arguments as TransactionModel;

      _loadFormData(transaction);
    } else {
      categorySelected = ModalRoute.of(context)!.settings.arguments.toString();
      _transactionData['Category'] = categorySelected;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar transação'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsetsDirectional.only(bottom: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ToggleSwitch(
                      minWidth: 140.0,
                      minHeight: 25.0,
                      cornerRadius: 20.0,
                      activeBgColors: const [
                        [Colors.blueAccent],
                        [Colors.blueAccent],
                      ],
                      borderWidth: 5,
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      initialLabelIndex: tipoTransaction,
                      totalSwitches: 2,
                      labels: const ['Receita', 'Despesa'],
                      radiusStyle: true,
                      onToggle: (index) {
                        print(index);
                        if (index == 1) {
                          _transactionData['TransactionType'] = '1';
                        } else {
                          _transactionData['TransactionType'] = '0';
                        }
                      },
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.of(context).pushNamed(AppRoutes.listCategory,
                      arguments: "CreateTransaction"),
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                child: const Text(
                  "Selecionar categoria",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              // Text(
              //   categorySelected == 'null' ? "" : categorySelected,
              //   style: const TextStyle(
              //     color: Colors.blue,
              //     fontSize: 25,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 1.0, top: 9.0, right: 1.0, bottom: 0.0),
                child: TextFormField(
                  initialValue: _transactionData['Description']?.toString(),
                  key: const ValueKey('Description'),
                  onChanged: (description) =>
                      _transactionData['Description'] = description,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 0.8, color: Colors.grey), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onSaved: (description) =>
                      _transactionData['Description'] = description!,
                  validator: (_name) {
                    final name = _name ?? '';

                    if (name.trim().isEmpty) {
                      return 'Nome é obrigatório.';
                    }

                    if (name.trim().length < 3) {
                      return 'Nome precisa no mínimo de 3 letras.';
                    }

                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 1.0, top: 25.0, right: 1.0, bottom: 0.0),
                child: TextFormField(
                  controller: dateInput,
                  //initialValue: _transactionData['TransactionDate']?.toString(),

                  //editing controller of this TextField
                  decoration: InputDecoration(
                    labelText: "Insira a data",
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 0.8, color: Colors.blueAccent), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  readOnly: true,
                  //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2100));
                    if (pickedDate != null) {
                      String formattedDate = DateFormat('yyyy-MM-dd').format(
                          pickedDate); //formatted date output using intl package =>  2021-03-16
                      dateInput.text = formattedDate;
                      _transactionData['TransactionDate'] =
                          formattedDate; //set output date to TextField value.
                    } else {}
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 1.0, top: 25.0, right: 1.0, bottom: 0.0),
                child: TextFormField(
                  key: const ValueKey('PaymentValue'),
                  onChanged: (paymentValue) =>
                      _transactionData['PaymentValue'] = paymentValue,
                  autofocus: false,
                  initialValue: _transactionData['PaymentValue']?.toString(),
                  decoration: InputDecoration(
                    labelText: 'R\$ 00,00',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 0.8, color: Colors.grey), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  onSaved: (price) => _transactionData['PaymentValue'] =
                      double.parse(price ?? '0'),
                  validator: (_price) {
                    final priceString = _price ?? '';
                    final price = double.tryParse(priceString) ?? -1;

                    if (price <= 0) {
                      return 'Informe um preço válido.';
                    }

                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 1.0, top: 25.0, right: 1.0, bottom: 0.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 7.0),
                    labelText: ('Forma de pagamento'),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 0.8, color: Colors.grey), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      key: const ValueKey('PaymentType'),
                      value: dropdownValue,
                      //icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      //style: const TextStyle(color: Colors.deepPurple),
                      //underline: Container(
                      // height: 2,
                      //color: Colors.deepPurpleAccent,
                      //),
                      onChanged: (paymentType) {
                        // This is called when the user selects an item.
                        dropdownValue = paymentType!;
                        _transactionData['PaymentType'] = paymentType;
                      },
                      items: list.map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ),
              TextField(
                enabled: false,
                decoration: InputDecoration(
                    hintText: _transactionData['Address'].toString(),
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    )),
                textAlign: TextAlign.center,
              ),
              Container(
                padding: const EdgeInsetsDirectional.only(top: 20.0),
                child: ElevatedButton(
                  // onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    fixedSize: const Size(290, 50),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.placeForm);
                  },
                  child: const Text('Buscar Localização'),
                ),
              ),
              Container(
                padding: const EdgeInsetsDirectional.only(top: 15.0),
                child: ElevatedButton(
                  // onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 20,
                    ),
                    fixedSize: const Size(290, 50),
                    //backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    _recuperaDadosLocalizacao();
                    _recuperaDadosCategoria();
                    //saveTransaction(_transactionData);
                  },
                  child: const Text('Registrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
