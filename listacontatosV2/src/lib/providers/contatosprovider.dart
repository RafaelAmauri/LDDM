import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:listacontatos/models/contato.dart';

class ContatosProvider with ChangeNotifier {
  FirebaseFirestore fb = FirebaseFirestore.instance;
  FirebaseStorage fs = FirebaseStorage.instance;
  List<Contato> all_contacts = [];
  final main_collection = 'users';
  final sub_collection = 'contacts';
  final img_bucket = 'images';

  String id;

  List<Contato> get all_inserted {
    return [...all_contacts];
  }

  ContatosProvider();

  ContatosProvider.logged_in(this.id);

  Contato find(String id) {
    return all_contacts.firstWhere((element) => element.id == id);
  }

  List<Contato> get contact_by_birthday => this
      .all_contacts
      .where((element) => DateTime.tryParse(element.birthday) != null).toList();

  Future<void> fetch_data() async {
    final data = await fb
        .collection(main_collection)
        .doc(id)
        .collection(sub_collection)
        .get();
    final contact_list = data.docs;

    if (contact_list.length == 0) return;

    all_contacts = contact_list.map((element) {
      final contacts_data = element.data();

      return Contato(
          element.id,
          contacts_data['name'],
          contacts_data['email'],
          contacts_data['address'],
          contacts_data['cep'],
          contacts_data['phone'],
          contacts_data['img_path'],
          contacts_data['birthday']);
    }).toList();

    notifyListeners();
  }

  add(String name, String email, String cep, String address, String phone,
      File f, String birthday) async {
    final contact_id = DateTime.now().toIso8601String();
    String url = 'none';
    if (f.existsSync()) {
      final ref = fs.ref().child(img_bucket).child(this.id + contact_id);
      await ref.putFile(f);
      url = await ref.getDownloadURL();
    }

    Contato c =
        Contato(contact_id, name, email, cep, address, phone, url, birthday);

    await fb
        .collection(main_collection)
        .doc(this.id)
        .collection(sub_collection)
        .doc(contact_id)
        .set({
      'name': name,
      'email': email,
      'cep': cep,
      'address': address,
      'phone': phone,
      'img_path': url,
      'birthday': birthday
    });

    this.all_contacts.add(c);

    notifyListeners();
  }

  remove(String id) async {
    int index = this.all_contacts.indexWhere((element) => element.id == id);
    Contato c = all_contacts[index];

    if (c.img_path == 'none') {
      final ref = fs.ref().child(img_bucket).child(this.id + id);
      ref.delete();
    }

    await fb
        .collection(main_collection)
        .doc(this.id)
        .collection(sub_collection)
        .doc(id)
        .delete();

    all_contacts.remove(c);
    notifyListeners();
  }

  update(String id, Contato c, File f) async {
    int id1 = this.all_contacts.indexWhere((element) => element.id == id);
    this.all_contacts[id1] = c;

    String url = c.img_path;
    if (f.existsSync()) {
      final ref = fs.ref().child(img_bucket).child(this.id + c.id);
      await ref.putFile(f);
      url = await ref.getDownloadURL();
    }

    await fb
        .collection(main_collection)
        .doc(this.id)
        .collection(sub_collection)
        .doc(c.id)
        .set({
      'name': c.name,
      'email': c.email,
      'cep': c.cep,
      'address': c.address,
      'phone': c.phone,
      'img_path': url,
      'birthday': c.birthday
    });

    notifyListeners();
  }
}
