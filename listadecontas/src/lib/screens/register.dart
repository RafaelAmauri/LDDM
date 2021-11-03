import 'package:flutter/material.dart';
import 'package:listadecontas/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class Registrator extends StatefulWidget {
  static const routename = 'register';
  @override
  _RegistratorState createState() => _RegistratorState();
}

class _RegistratorState extends State<Registrator> {
  final GlobalKey<FormState> globalKey = GlobalKey();
  Map<String, String> userdata = {'username': '', 'email': '', 'password': ''};
  bool loading = false;
  registrar() async {
    if (!globalKey.currentState.validate()) {
      return;
    }
    globalKey.currentState.save();
    setState(() {
      loading = true;
    });
    bool resultado;
    resultado = await Provider.of<AuthProvider>(context, listen: false)
        .sign_up(userdata['username'], userdata['email'], userdata['password']);

    if (!resultado) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Um erro foi encontrado')));
    }
    setState(() {
      loading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent[100],
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Form(
            key: globalKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: userdata['email'],
                  decoration: InputDecoration(labelText: 'Email'),
                  onSaved: (newValue) => userdata['email'] = newValue.trim(),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Digite um email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: userdata['username'],
                  onSaved: (newValue) => userdata['username'] = newValue.trim(),
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
                  initialValue: userdata['password'],
                  obscureText: true,
                  onSaved: (newValue) => userdata['password'] = newValue.trim(),
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
                  onPressed: registrar,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.blue;
                        return null;
                      },
                    ),
                  ),
                  child: loading
                      ? CircularProgressIndicator()
                      : Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
