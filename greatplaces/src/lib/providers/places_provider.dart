import 'dart:io';

import 'package:flutter/foundation.dart';
import '../models/place.dart';
import '../helpers/sql_database.dart';
import 'package:geocoding/geocoding.dart';

class PlacesProvider with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> addPlace(
      String title, File image, PlaceLocation location) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    if (placemarks.length == 0) return;

    final updatedLocation = PlaceLocation(
        latitude: location.latitude,
        longitude: location.longitude,
        address:  placemarks[0].street + ', ' + 
                  placemarks[0].subAdministrativeArea + ', ' + 
                  placemarks[0].administrativeArea + ', ' + 
                  placemarks[0].country);
    final newPlace = Place(
        id: DateTime.now().toString(),
        image: image,
        title: title,
        location: updatedLocation);
    _items.add(newPlace);
    notifyListeners();
    await SQLDatabase.insert('user_places', newPlace.toMap);
  }

  Future<void> removePlace(String id) async {
    int index = _items.indexWhere((element) => element.id == id);

    if (index == -1) return;

    Place tmp = _items[index];

    File tmpFile = tmp.image;

    if (tmpFile.existsSync()) tmpFile.deleteSync();

    _items.remove(tmp);

    await SQLDatabase.delete('user_places', id);

    notifyListeners();
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> fetchPlaces() async {
    final dataList = await SQLDatabase.read('user_places');
    _items = dataList.map((item) => Place.fromMap(item)).toList();
    notifyListeners();
  }
}
