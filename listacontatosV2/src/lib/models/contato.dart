import 'package:flutter/foundation.dart';

class Contato with ChangeNotifier {
  String _id = '-1';
  String _name, _email, _address, _cep, _phone, _img_path, _birthday;

  Contato(this._id, this._name, this._email, this._address, this._cep,
      this._phone, this._img_path, this._birthday);

  String get id => this._id;

  set id(String id) => this._id = id;

  String get name => this._name;

  set name(String name) => this._name = name;

  String get email => this._email;

  set email(String email) => this._email = email;

  String get address => this._address;

  set address(String address) => this._address = address;

  String get cep => this._cep;

  set cep(String cep) => this._cep = cep;

  String get phone => this._phone;

  set phone(String phone) => this._phone = phone;

  String get img_path => this._img_path;

  set img_path(String img_path) => this._img_path = img_path;

  String get birthday => this._birthday;

  set birthday(String birthday) => this._birthday = birthday;
}
