import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Conta with ChangeNotifier {
  int _id = -1;
  int _user_id;
  String _name;
  DateTime _due_date;
  String _description;
  double _price;

  Conta.id(this._id, this._user_id, this._name, this._due_date,
      this._description, this._price);
  Conta(this._user_id, this._name, this._due_date, this._description,
      this._price);

  int get id {
    return this._id;
  }

  set id(int i) {
    this._id = i;
  }

  int get user_id {
    return this._id;
  }

  set user_id(int i) {
    this._id = i;
  }

  String get name {
    return this._name;
  }

  set name(String n) {
    this._name = n;
  }

  DateTime get due_date {
    return this._due_date;
  }

  String get due_date_formatted {
    return DateFormat('dd/MM').format(this._due_date);
  }

  set due_date(DateTime d) {
    this._due_date = d;
  }

  String get description {
    return this._description;
  }

  set description(String d) {
    this._description = d;
  }

  double get price {
    return this._price;
  }

  set price(double d) {
    this._price = d;
  }
}
