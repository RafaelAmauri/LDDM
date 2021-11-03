class Usuario {
  String _name;
  String _email;
  String _password;
  int _id;

  Usuario(this._name, this._email, this._password, this._id);

  String get name {
    return _name;
  }

  String get email {
    return _email;
  }

  String get password {
    return _password;
  }

  int get id {
    return _id;
  }

  set id(int id) {
    this._id = id;
  }
}
