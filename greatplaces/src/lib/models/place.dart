import 'dart:io';
import 'package:flutter/foundation.dart';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation(
      {@required this.latitude, @required this.longitude, this.address});
}

class Place {
  final String id;
  final String title;
  final PlaceLocation location;
  final File image;

  Place(
      {@required this.id,
      @required this.title,
      @required this.location,
      @required this.image});

  Map<String, Object> get toMap => {
        'id': this.id,
        'title': this.title,
        'image': this.image.path,
        'loc_lat': this.location.latitude,
        'loc_lng': this.location.longitude,
        'address': this.location.address,
      };

  factory Place.fromMap(Map<String, Object> map) => Place(
      id: map['id'],
      title: map['title'],
      image: File(map['image']),
      location: PlaceLocation(
          latitude: map['loc_lat'],
          longitude: map['loc_lng'],
          address: map['address']));
}
