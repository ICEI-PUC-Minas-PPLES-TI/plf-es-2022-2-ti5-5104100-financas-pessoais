import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
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
    bool isValidUrl = Uri
        .tryParse(url)
        ?.hasAbsolutePath ?? false;
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
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return Stack(
      children: [
              Container(
                  margin: const EdgeInsetsDirectional.only(top: 50.0), //
                  child: Scaffold(
                    appBar: AppBar(
                      title: const Text('Registrar Transação'),
                      actions: [
                        IconButton(
                          onPressed: _submitForm,
                          icon: const Icon(Icons.save),
                        )
                      ],
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            TextFormField(
                              initialValue: _formData['name']?.toString(),
                              decoration: const InputDecoration(
                                  labelText: 'Nome'),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(
                                    _priceFocus);
                              },
                              onSaved: (name) => _formData['name'] = name ?? '',
                              validator: (_name) {
                                final name = _name ?? '';

                                if (name
                                    .trim()
                                    .isEmpty) {
                                  return 'Nome é obrigatório.';
                                }

                                if (name
                                    .trim()
                                    .length < 3) {
                                  return 'Nome precisa no mínimo de 3 letras.';
                                }

                                return null;
                              },
                            ),
                            TextFormField(
                              initialValue: _formData['price']?.toString(),
                              decoration: const InputDecoration(
                                  labelText: 'Categoria'),
                              textInputAction: TextInputAction.next,
                              focusNode: _priceFocus,
                              keyboardType: const TextInputType
                                  .numberWithOptions(
                                decimal: true,
                                signed: true,
                              ),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(
                                    _descriptionFocus);
                              },
                              onSaved: (price) =>
                              _formData['price'] = double.parse(price ?? '0'),
                              validator: (_price) {
                                final priceString = _price ?? '';
                                final price = double.tryParse(priceString) ??
                                    -1;

                                if (price <= 0) {
                                  return 'Informe um preço válido.';
                                }

                                return null;
                              },
                            ),
                            TextFormField(
                              initialValue: _formData['price']?.toString(),
                              decoration: const InputDecoration(
                                  labelText: 'Data'),
                              textInputAction: TextInputAction.next,
                              focusNode: _priceFocus,
                              keyboardType: const TextInputType
                                  .numberWithOptions(
                                decimal: true,
                                signed: true,
                              ),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(
                                    _descriptionFocus);
                              },
                              onSaved: (price) =>
                              _formData['price'] = double.parse(price ?? '0'),
                              validator: (_price) {
                                final priceString = _price ?? '';
                                final price = double.tryParse(priceString) ??
                                    -1;

                                if (price <= 0) {
                                  return 'Informe um preço válido.';
                                }

                                return null;
                              },
                            ),
                            TextFormField(
                              initialValue: _formData['price']?.toString(),
                              decoration: const InputDecoration(
                                  labelText: 'Valor'),
                              textInputAction: TextInputAction.next,
                              focusNode: _priceFocus,
                              keyboardType: const TextInputType
                                  .numberWithOptions(
                                decimal: true,
                                signed: true,
                              ),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(
                                    _descriptionFocus);
                              },
                              onSaved: (price) =>
                              _formData['price'] = double.parse(price ?? '0'),
                              validator: (_price) {
                                final priceString = _price ?? '';
                                final price = double.tryParse(priceString) ??
                                    -1;

                                if (price <= 0) {
                                  return 'Informe um preço válido.';
                                }

                                return null;
                              },
                            ),
                            TextFormField(
                              initialValue: _formData['price']?.toString(),
                              decoration: const InputDecoration(
                                  labelText: 'Forma de pagamento'),
                              textInputAction: TextInputAction.next,
                              focusNode: _priceFocus,
                              keyboardType: const TextInputType
                                  .numberWithOptions(
                                decimal: true,
                                signed: true,
                              ),
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(
                                    _descriptionFocus);
                              },
                              onSaved: (price) =>
                              _formData['price'] = double.parse(price ?? '0'),
                              validator: (_price) {
                                final priceString = _price ?? '';
                                final price = double.tryParse(priceString) ??
                                    -1;

                                if (price <= 0) {
                                  return 'Informe um preço válido.';
                                }

                                return null;
                              },
                            ),
                            Container(
                              padding: EdgeInsetsDirectional.only(top: 20.0),
                              child: ElevatedButton(
                                // onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 100,
                                    vertical: 20,
                                  ),
                                  //backgroundColor: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {},
                                child: Text('Buscar Localização'
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsetsDirectional.only(top: 15.0),
                              child: ElevatedButton(
                                // onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 100,
                                    vertical: 20,
                                  ),
                                  //backgroundColor: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {},
                                child: Text('Registrar'
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              ),
            ],
    );
  }
}
