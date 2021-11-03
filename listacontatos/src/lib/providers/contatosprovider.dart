import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:listacontatos/models/contato.dart';

class ContatosProvider with ChangeNotifier {
  FirebaseFirestore fb = FirebaseFirestore.instance;
  List<Contato> all_contacts = [];
  final main_collection = 'users';
  final sub_collection = 'contacts';

  String id;

  List<Contato> get all_inserted {
    return [...all_contacts];
  }

  ContatosProvider();

  ContatosProvider.logged_in(this.id);

  Contato find(String id) {
    return all_contacts.firstWhere((element) => element.id == id);
  }

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
          contacts_data['phone']);
    }).toList();

    notifyListeners();
  }

  add(String name, String email, String cep, String address,
      String phone) async {
    final contact_id = DateTime.now().toIso8601String();
    
    Contato c = Contato(contact_id, name, email, cep, address, phone);

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
      'phone': phone
    });

    this.all_contacts.add(c);

    notifyListeners();
  }

  remove(String id) async {
    this.all_contacts.removeWhere((element) => element.id == id);

    await fb
        .collection(main_collection)
        .doc(this.id)
        .collection(sub_collection)
        .doc(id)
        .delete();

    notifyListeners();
  }

  update(String id, Contato c) async {
    int id1 = this.all_contacts.indexWhere((element) => element.id == id);
    this.all_contacts[id1] = c;

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
      'phone': c.phone
    });

    notifyListeners();
  }
}
