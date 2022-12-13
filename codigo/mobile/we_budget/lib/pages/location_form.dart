import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:we_budget/utils/shared_preference.dart';
import 'package:we_budget/utils/location_util.dart';
import '../components/location_input.dart';

class PlaceFormScreen extends StatefulWidget {
  const PlaceFormScreen({Key? key}) : super(key: key);

  @override
  State<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _titleController = TextEditingController();
  LatLng? _pickedPosition;

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  bool _isValidForm() {
    return _pickedPosition != null;
  }

  void _submitForm() async {
    if (!_isValidForm()) return;
    /*Provider.of<TransactionsProviders>(context, listen: false).addTransaction(
      _titleController.text,
      _pickedImage!,
      _pickedPosition!,
    );*/
    String address = await LocationUtil.getAddressFrom(_pickedPosition!);

    Store.saveMap(
      'localizacao',
      {
        'latitude': _pickedPosition!.latitude.toString(),
        'longitude': _pickedPosition!.longitude.toString(),
        'address': address,
      },
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Lugar'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    LocationInput(_selectPosition),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Adicionar'),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: (() async {
              if (_isValidForm()) {
                _submitForm();
              }
            }),
          ),
        ],
      ),
    );
  }
}
