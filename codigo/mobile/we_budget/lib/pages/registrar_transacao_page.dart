import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:we_budget/components/categoria_dropdown.dart';

import '../components/date_picker.dart';
import '../components/forma_pagamento_dropdown.dart';
import '../utils/app_routes.dart';

class TransacaoFormPage extends StatefulWidget {
  const TransacaoFormPage({Key? key}) : super(key: key);

  @override
  State<TransacaoFormPage> createState() => _TransacaoFormPageState();
}

class _TransacaoFormPageState extends State<TransacaoFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _categoryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

 Map<String, Object> _transactionData = {
    'TransactionType' : 'receita',
    'Longitude' : 0.0,
    'Address' : '',
    'CategoryId' : 0,
  };

  static const List<String> list = <String>['Crédito', 'Débito', 'Cheque', 'Pix', 'Dinheiro'];
  String dropdownValue = list.first;

  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // if (_formData.isEmpty) {
    //   final arg = ModalRoute.of(context)?.settings.arguments;
    //
    //   if (arg != null) {
    //     final product = arg as Product;
    //     _formData['id'] = product.id;
    //     _formData['name'] = product.name;
    //     _formData['price'] = product.price;
    //     _formData['description'] = product.description;
    //     _formData['imageUrl'] = product.imageUrl;
    //
    //     _imageUrlController.text = product.imageUrl;
    //   }
    // }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();

    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endsWithFile;
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();
    //
    // Provider.of<ProductList>(
    //   context,
    //   listen: false,
    // ).saveProduct(_formData);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    String? _categorySelected =
        ModalRoute.of(context)!.settings.arguments.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar transação'),
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
                        print(index);
                        if(index ==  1){
                          print("oi");
                          _transactionData['TransactionType'] = 'receita';
                        }else{
                          _transactionData['TransactionType'] = 'despesa';
                        }
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 1.0, top: 0.0, right: 1.0, bottom: 0.0),
                child: TextFormField(
                  key: const ValueKey('Description'),
                  onChanged: (Description) => _transactionData['Description'] = Description,
                  initialValue: _formData['name']?.toString(),
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 0.8, color: Colors.grey), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocus);
                  },
                  onSaved: (name) => _formData['name'] = name ?? '',
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
                    left: 1.0, top: 20.0, right: 1.0, bottom: 0.0),
                child: TextFormField(
                  key: const ValueKey('CategoryId'),
                  onChanged: (CategoryId) => _transactionData['CategoryId'] = CategoryId,
                  initialValue: _categorySelected,
                  decoration: InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 0.8, color: Colors.grey), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.listCategory);
                  },
                  onSaved: (categorySelected) =>
                      _formData['categorySelected'] = categorySelected ?? '',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 1.0, top: 25.0, right: 1.0, bottom: 0.0),
                child: TextFormField(
                  controller: dateInput,
                  //editing controller of this TextField
                  decoration: InputDecoration(labelText: "Insira a data",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0.8, color: Colors.blueAccent), //<-- SEE HERE
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
                      print(
                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(
                          formattedDate); //formatted date output using intl package =>  2021-03-16
                      setState(() {
                        dateInput.text =
                            formattedDate;
                        _transactionData['TransactionDate'] = formattedDate;//set output date to TextField value.
                      });
                    } else {}
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 1.0, top: 25.0, right: 1.0, bottom: 0.0),
                child: TextFormField(
                  key: const ValueKey('PaymentValue'),
                  onChanged: (PaymentValue) => _transactionData['valor'] = PaymentValue,
                  autofocus: false,
                  initialValue: _formData['price']?.toString(),
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
                  // onFieldSubmitted: (_) {
                  //   FocusScope.of(context)
                  //       .requestFocus(_descriptionFocus);
                  // },
                  onSaved: (price) =>
                      _formData['price'] = double.parse(price ?? '0'),
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
                  padding: EdgeInsets.only(
                      left: 1.0, top: 25.0, right: 1.0, bottom: 0.0),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 7.0),
                      labelText: ('Forma de pagamento'),
                      border: OutlineInputBorder(
                        borderSide:  BorderSide(width: 0.8, color: Colors.grey), //<-- SEE HERE
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
                        onChanged: (PaymentType){
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = PaymentType!;
                            _transactionData['PaymentType'] = PaymentType!;
                          });
                        },
                        items: list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
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
                  onPressed: () {},
                  child: Text('Buscar Localização'),
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
                    print(_transactionData);
                    print(dateInput.text);
                  },
                  child: Text('Registrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
