import 'package:flutter/material.dart';

class Registrator extends StatefulWidget {
  final GlobalKey<FormState> globalKey = GlobalKey();
  static const routename = 'register';
  @override
  _RegistratorState createState() => _RegistratorState();
}

class _RegistratorState extends State<Registrator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: '',
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Digite um email';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: '',
                decoration: InputDecoration(labelText: 'Nome'),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Digite um nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: '',
                decoration: InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Digite uma senha';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.blue;
                      return null;
                    },
                  ),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
