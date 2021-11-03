import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:listadecontas/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:listadecontas/helpers/sql.dart';

class AuthProvider with ChangeNotifier {
  Usuario current_user;
  DateTime auth_token;
  Timer auth_timer;
  final tablename = 'users';

  bool get is_authenticated {
    return auth_token != null;
  }

  int get userId {
    if (current_user == null) return -1;
    return current_user.id;
  }

  Usuario get authenticated_user {
    return current_user;
  }

  Future<bool> sign_in(String email, String senha) async {
    final result = await SQLDatabase.read(tablename, 'email', email);

    if (result.isEmpty) {
      return false;
    }

    if (result[0]['passwd'].toString().compareTo(senha) != 0) {
      print('senha do usuario : ' +
          result[0]['passwd'].toString() +
          '\nsenha inserida: ' +
          senha);
      return false;
    }

    current_user =
        Usuario(result[0]['username'], email, senha, result[0]['id']);

    auth_token = DateTime.now().add(Duration(days: 30));
    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    final userdata = json.encode(
        {'user_id': current_user.id, 'token': auth_token.toIso8601String()});
    pref.setString('userdata', userdata);

    return true;
  }

  Future<bool> sign_up(String username, String email, String senha) async {
    final result = await SQLDatabase.read(tablename, 'email', email);

    if (result.isNotEmpty) {
      return false;
    }

    int id = await SQLDatabase.insert(
        tablename, {'username': username, 'passwd': senha, 'email': email});

    current_user = Usuario(username, email, senha, id);
    auth_token = DateTime.now().add(Duration(days: 30));
    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    final userdata = json.encode(
        {'user_id': current_user.id, 'token': auth_token.toIso8601String()});
    pref.setString('userdata', userdata);

    return true;
  }

  Future<bool> is_signed_in() async {
    final pref = await SharedPreferences.getInstance();

    if (!pref.containsKey('userdata')) {
      return false;
    }

    final userdata =
        json.decode(pref.getString('userdata')) as Map<String, Object>;

    final expiry_date = DateTime.parse(userdata['token']);

    if (expiry_date.isBefore(DateTime.now())) {
      return false;
    }

    final result =
        await SQLDatabase.read(tablename, 'id', userdata['user_id'].toString());

    current_user = Usuario(result[0]['username'], result[0]['email'],
        result[0]['passwd'], result[0]['id']);

    auth_token = expiry_date;
    notifyListeners();

    return true;
  }

  Future<void> sign_out() async {
    auth_token = null;
    current_user = null;

    if (auth_timer != null) {
      auth_timer.cancel();
      auth_timer = null;
    }

    notifyListeners();
    final pref = await SharedPreferences.getInstance();

    pref.clear();
  }

  void auto_sign_out() {
    if (auth_timer != null) {
      auth_timer.cancel();
    }
    final time_to_expire = auth_token.difference(DateTime.now()).inSeconds;

    auth_timer = Timer(Duration(seconds: time_to_expire), sign_out);
  }
}
