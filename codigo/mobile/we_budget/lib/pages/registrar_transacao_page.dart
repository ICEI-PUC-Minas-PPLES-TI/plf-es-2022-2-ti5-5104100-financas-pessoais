import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:we_budget/components/categoria_dropdown.dart';
import 'package:we_budget/models/categoria_model.dart';
import 'package:we_budget/models/category.dart';
import 'package:we_budget/models/transactions.dart';

import '../Repository/transaction_repository.dart';
import '../components/date_picker.dart';
import '../components/forma_pagamento_dropdown.dart';
import '../utils/app_routes.dart';

class TransacaoFormPage extends StatefulWidget {
  const TransacaoFormPage({Key? key}) : super(key: key);

  @override
  State<TransacaoFormPage> createState() => _TransacaoFormPageState();
}

class _TransacaoFormPageState extends State<TransacaoFormPage> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, Object> _transactionData = {
    'Category': '',
    'TransactionType': '0',
    'Description': '',
    'TransactionDate': '',
    'PaymentValue': '',
    'PaymentType': '',
    'Longitude': '20.15',
    'Latitude': '20.15',
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

  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    Provider.of<RepositoryTransaction>(
      context,
      listen: false,
    ).insertTransacao(
      TransactionModel(
        idTransaction: '11',
        name: _transactionData['Description'].toString(),
        categoria: _transactionData['Category'].toString(),
        data: _transactionData['TransactionDate'].toString(),
        valor: double.parse(_transactionData['PaymentValue'].toString()),
        formaPagamento: _transactionData['PaymentType'].toString(),
        tipoTransacao:
            int.parse(_transactionData['TransactionType'].toString()),
        location: TransactionLocation(
            latitude: double.parse(_transactionData['Longitude'].toString()),
            longitude: double.parse(_transactionData['Latitude'].toString()),
            address: _transactionData['Address'].toString()),
      ),
    );

    Navigator.of(context).pushNamed(AppRoutes.main);
  }

  @override
  Widget build(BuildContext context) {
    String? categorySelected =
        ModalRoute.of(context)!.settings.arguments.toString();
    print("----->");
    print(categorySelected.toString() == 'null');
    _transactionData['Category'] = categorySelected;

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
                      initialLabelIndex: 1,
                      totalSwitches: 2,
                      labels: const ['Despesa', 'Receita'],
                      radiusStyle: true,
                      onToggle: (index) {
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
              // Padding(
              //   padding: const EdgeInsets.only(
              //       left: 1.0, top: 20.0, right: 1.0, bottom: 0.0),
              //   child: TextField(
              //     key: const ValueKey('Category'),
              //     onChanged: (category) {
              //       _transactionData['Category'] = category;
              //     },
              //     decoration: InputDecoration(
              //       labelText: 'Categoria',
              //       border: OutlineInputBorder(
              //         borderSide: const BorderSide(
              //             width: 0.8, color: Colors.grey), //<-- SEE HERE
              //         borderRadius: BorderRadius.circular(50.0),
              //       ),
              //     ),
              //     textInputAction: TextInputAction.next,
              //     onTap: () {
              //       Navigator.of(context).pushNamed(AppRoutes.listCategory);
              //     },
              //   ),
              // ),
              TextButton(
                onPressed: () => {
                  Navigator.of(context).pushNamed(AppRoutes.listCategory),
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
              Text(
                categorySelected == 'null'
                    ? "Categoria a definir..."
                    : categorySelected,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 1.0, top: 9.0, right: 1.0, bottom: 0.0),
                child: TextFormField(
                  key: const ValueKey('Description'),
                  onChanged: (description) =>
                      _transactionData['Description'] = description,
                  initialValue: _transactionData['Description']?.toString(),
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
                  initialValue: _transactionData['price']?.toString(),
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
                  )),
              Container(
                padding: const EdgeInsetsDirectional.only(top: 20.0),
                child: ElevatedButton(
                  // onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
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
                    primary: Colors.blueAccent,
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
                    print(_transactionData.toString());
                    _submitForm();
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
