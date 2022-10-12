import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/transactions.dart';

class MapScreen extends StatefulWidget {
  final TransactionLocation initialLocation;
  final bool isReadOnly;

  const MapScreen(
      {this.initialLocation = const TransactionLocation(
        latitude: 37.419857,
        longitude: -122.078827,
      ),
      this.isReadOnly = false,
      Key? key})
      : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPosition;

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione...'),
        actions: [
          if (!widget.isReadOnly)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _pickedPosition == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedPosition);
                    },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 13,
        ),
        onTap: widget.isReadOnly ? null : _selectPosition,
        markers: (_pickedPosition == null && !widget.isReadOnly)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('p1'),
                  position:
                      _pickedPosition ?? widget.initialLocation.toLatLng(),
                )
              },
      ),
    );
  }
}
