import 'dart:io';
import 'package:flutter/material.dart';
import 'package:greatplaces/models/place.dart';
import 'package:greatplaces/widgets/image_input.dart';
import 'package:provider/provider.dart';
import '../providers/places_provider.dart';
import 'package:location/location.dart';

class AddPlace extends StatefulWidget {
  static const routeName = '/add-place';
  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final _textController = TextEditingController();
  var location = Location();
  File _pickedImage;
  PlaceLocation _pickedLocation;
  bool loading = false;

  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlace(double latitude, double longitude) {
    setState(() {
      _pickedLocation = PlaceLocation(latitude: latitude, longitude: longitude);
    });
  }

  void _savePlace() {
    if (_textController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) return;
    Provider.of<PlacesProvider>(context, listen: false)
        .addPlace(_textController.text, _pickedImage, _pickedLocation);
    Navigator.of(context).pop();
  }

  Future<void> _getCurrentUserLocation() async {
    setState(() {
      loading = true;
    });
    try {
      var serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();

        if (!serviceEnabled) return;
      }

      var permissionGranted = await location.hasPermission();

      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();

        if (permissionGranted != PermissionStatus.granted) return;
      }

      final locationData = await location.getLocation();
      _selectPlace(locationData.latitude, locationData.longitude);
    } catch (error) {
      return;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Place'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  controller: _textController,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ImageInput(_selectImage),
              SizedBox(
                height: 10,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _getCurrentUserLocation,
                  child: Text(
                    'Current Location',
                  ),
                ),
              ),
              Center(
                  child: loading
                      ? CircularProgressIndicator()
                      : Card(
                          child: _pickedLocation != null
                              ? Text(
                                  'Current Location: ${_pickedLocation.latitude}, ${_pickedLocation.longitude}',
                                )
                              : Text('No chosen location'))),
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Add Place'),
                onPressed: _savePlace,
              )
            ],
          ),
        ),
      ),
    );
  }
}
