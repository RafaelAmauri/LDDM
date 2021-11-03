import 'package:flutter/material.dart';
import 'package:greatplaces/providers/places_provider.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/place-details';
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final selectedPlace =
        Provider.of<PlacesProvider>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(title: Text(selectedPlace.title), actions: [
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () {
            Provider.of<PlacesProvider>(context, listen: false)
                .removePlace(selectedPlace.id);
            Navigator.of(context).pop();
          },
        )
      ]),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedPlace.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 10),
          Text(
            selectedPlace.location.address,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
