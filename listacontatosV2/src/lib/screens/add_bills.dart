import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listacontatos/widgets/image_picker.dart';
import 'package:via_cep_flutter/via_cep_flutter.dart';
import 'package:listacontatos/models/contato.dart';
import 'package:listacontatos/providers/contatosprovider.dart';
import 'package:provider/provider.dart';

class Bills extends StatefulWidget {
  final Contato c;
  Bills({this.c});

  @override
  _BillsState createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  final cep_manager = TextEditingController();
  final address_manager = TextEditingController();
  final GlobalKey<FormState> globalKey = GlobalKey();
  String name, email, phone, address, cep;
  DateTime birthday = DateTime.now();
  File f = File('');
  void pick_img(File file) {
    this.f = file;
  }

  bool update = false;
  void dispose() {
    super.dispose();
    cep_manager.dispose();
    address_manager.dispose();
  }

  escolher_data() async {
    DateTime today = DateTime.now().add(Duration(days: 1));
    await showDatePicker(
            context: context,
            initialDate: today,
            firstDate: today,
            lastDate: DateTime(today.year + 1))
        .then((DateTime value) {
      setState(() {
        birthday = value;
      });
    });
  }

  void initState() {
    super.initState();
    if (widget.c != null) {
      update = true;

      name = widget.c.name;
      email = widget.c.email;
      cep = widget.c.cep;
      phone = widget.c.phone;
      address = widget.c.address;
      birthday = DateTime.parse(widget.c.birthday);
      cep_manager.text = widget.c.cep;
      address_manager.text = widget.c.address;
    }
  }

  criar_conta() async {
    if (!globalKey.currentState.validate()) {
      return false;
    }

    globalKey.currentState.save();

    String bday = '';
    if (birthday != null) {
      bday = birthday.toIso8601String();
    }

    if (update) {
      widget.c.name = name;
      widget.c.email = email;
      widget.c.cep = cep;
      widget.c.phone = phone;
      widget.c.address = address;
      widget.c.birthday = bday;

      await Provider.of<ContatosProvider>(context, listen: false)
          .update(widget.c.id, widget.c, f);
    } else {
      await Provider.of<ContatosProvider>(context, listen: false)
          .add(name, email, cep, address, phone, f, bday);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar contato'),
        centerTitle: true,
      ),
      body: Form(
        key: globalKey,
        child: Container(
          child: ListView(
              children: [
                EscolhedorImagem(pick_img, initial_value: f.path),
                TextFormField(
                  initialValue: name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Nome'),
                  keyboardType: TextInputType.name,
                  onSaved: (user_inserted_value) {
                    name = user_inserted_value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Digite um valor';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  initialValue: email,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (user_inserted_value) {
                    email = user_inserted_value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Digite um valor';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  initialValue: phone,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                  onSaved: (user_inserted_value) {
                    phone = user_inserted_value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Digite um valor';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: cep_manager,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: 'CEP'),
                        keyboardType: TextInputType.number,
                        onSaved: (user_inserted_value) {
                          cep = user_inserted_value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Digite um valor';
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (cep_manager.text.length < 8) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'CEP inserido é invalido: menos de 8 dígitos'),
                            ));
                            return;
                          }
        
                          final address_from_cep =
                              await readAddressByCep(cep_manager.text);
        
                          if (address_from_cep.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'CEP inserido é invalido: endereço não encontrado'),
                            ));
                            return;
                          }
        
                          setState(() {
                            address_manager.text = address_from_cep['street'] +
                                '//' +
                                address_from_cep['neighborhood'];
                            address = address_manager.text;
                          });
                        },
                        child: Text('Conferir CEP'))
                  ],
                ),
                TextFormField(
                  controller: address_manager,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Endereço'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (user_inserted_value) {
                    address = user_inserted_value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Digite um valor';
                    }
                    return null;
                  },
                ),
                Container(
                  height: 70,
          
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Data de aniversário: \n' +
                                DateFormat('dd/MM/yyyy').format(birthday)),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: escolher_data, child: Text('Escolher data de nascimento')),
                        )
                      ],
                    ),
                  
                ),
                ElevatedButton(
                    onPressed: criar_conta, child: Text('Adicionar contato'))
              ],
            ),
        ),
      ),
    );
  }
}
