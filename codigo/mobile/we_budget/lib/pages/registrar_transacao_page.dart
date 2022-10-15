import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_budget/components/categoria_dropdown.dart';

import '../components/date_picker.dart';
import '../components/forma_pagamento_dropdown.dart';

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

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
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
    return Stack(
      children: [
        Container(
        padding: const EdgeInsets.only(left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              //borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
        child: Container(
            margin: const EdgeInsetsDirectional.only(top: 50.0), //
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(30),

                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0, top: 0.0, right: 1.0, bottom: 0.0),
                        child: TextFormField(
                          initialValue: _formData['name']?.toString(),
                          decoration: InputDecoration(labelText: 'Nome',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 0.8, color: Colors.grey), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(50.0),
                            ),),
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
                        padding: const EdgeInsets.only(left: 1.0, top: 25.0, right: 1.0, bottom: 0.0),
                        child: DropdownButtonExample()
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0, top: 25.0, right: 1.0, bottom: 0.0),
                        child: DatePicker(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0, top: 25.0, right: 1.0, bottom: 0.0),
                        child: TextFormField(
                          autofocus: false,
                          initialValue: _formData['price']?.toString(),
                          decoration: InputDecoration(labelText: 'R\$ 00,00',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 0.8, color: Colors.grey), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          focusNode: FocusNode(),
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
                          padding: const EdgeInsets.only(left: 1.0, top: 25.0, right: 1.0, bottom: 0.0),
                          child: DropdownButtonPagamentoExample()
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.only(top: 20.0),
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
                          onPressed: () {},
                          child: Text('Registrar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ))),
      ],
    );
  }
}
