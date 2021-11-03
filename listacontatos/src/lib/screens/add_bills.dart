import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final GlobalKey<FormState> globalKey = GlobalKey();
  String name, email, phone, address, cep;

  bool update = false;
  void initState() {
    super.initState();
    if (widget.c != null) {
      update = true;

      name = widget.c.name;
      email = widget.c.email;
      cep = widget.c.cep;
      phone = widget.c.phone;
      address = widget.c.address;
    }
  }

  criar_conta() async {
    if (!globalKey.currentState.validate()) {
      return false;
    }

    globalKey.currentState.save();

    if (update) {
      widget.c.name = name;
      widget.c.email = email;
      widget.c.cep = cep;
      widget.c.phone = phone;
      widget.c.address = address;

      await Provider.of<ContatosProvider>(context, listen: false)
          .update(widget.c.id, widget.c);
    } else {
      await Provider.of<ContatosProvider>(context, listen: false)
          .add(name, email, cep, address, phone);
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
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
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
              TextFormField(
                initialValue: cep,
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
              TextFormField(
                initialValue: address,
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
              ElevatedButton(
                  onPressed: criar_conta, child: Text('Adicionar contato'))
            ],
          ),
        )),
      ),
    );
  }
}
