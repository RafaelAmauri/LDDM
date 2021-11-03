import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AuthProvider with ChangeNotifier {
  String username, email, id;
  bool is_logged = false;
  FirebaseAuth authenticator = FirebaseAuth.instance;
  final collection_name = 'users';

  bool get is_authenticated {
    return is_logged;
  }

  String get userId {
    if (id == null) return '-1';
    return id;
  }

  Map<String, String> get authenticated_user {
    return {'id': id, 'email': email, 'username': username};
  }

  Future<DocumentSnapshot> fb_get_user_info(String id) async {
    return await FirebaseFirestore.instance
        .collection(collection_name)
        .doc(id)
        .get();
  }

  String get_user_id() {
    return id;
  }

  Future<bool> try_auto_login() async {
    final user = authenticator.currentUser;

    if (user == null) return false;

    if (!is_logged) {
      final firebasedata = await fb_get_user_info(user.uid);
      final userdata = firebasedata.data() as Map<String, dynamic>;

      id = user.uid;
      email = userdata['email'];
      username = userdata['username'];
    }
    is_logged = true;
    notifyListeners();
    return true;
  }

  Future<bool> sign_in(String email, String senha) async {
    try {
      UserCredential credential = await authenticator
          .signInWithEmailAndPassword(email: email, password: senha);
      final user = credential.user;

      if (user == null) return false;

      final firebasedata = await fb_get_user_info(user.uid);
      final userdata = firebasedata.data() as Map<String, dynamic>;

      id = user.uid;
      email = userdata['email'];
      username = userdata['username'];

      is_logged = true;

      notifyListeners();
    } on PlatformException catch (error) {
      print('PRIMEIRO CATCH');
      throw error.message;
    } catch (error) {
      print('SEGUNDO CATCH');
      throw error;
    }
  }

  Future<bool> sign_up(String email, String username, String senha) async {
    try {
      print('O email eh : ' + email + '\n');
      UserCredential credential = await authenticator
          .createUserWithEmailAndPassword(email: email, password: senha);
      final user = credential.user;

      if (user == null) return false;

      await FirebaseFirestore.instance
          .collection(collection_name)
          .doc(user.uid)
          .set({'email': email, 'username': username});

      id = user.uid;
      email = email;
      username = username;

      is_logged = true;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> sign_out() async {
    username = '';
    email = '';
    id = '';

    await authenticator.signOut();
    is_logged = false;

    notifyListeners();
  }
}
