import 'package:flutter/material.dart';
import 'package:listacontatos/providers/auth_provider.dart';
import 'package:listacontatos/screens/register.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const routename = 'login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> globalKey = GlobalKey();
  bool loading = false;
  Map<String, String> userdata = {'username': '', 'email': '', 'password': ''};
  logar() async {
    if (!globalKey.currentState.validate()) {
      return;
    }
    globalKey.currentState.save();
    setState(() {
      loading = true;
    });
    try{    
      await Provider.of<AuthProvider>(context, listen: false)
        .sign_in(userdata['email'], userdata['password']);
    }
    catch(error)
    {
        print('Dei erro no LOGIN\n\n');
        ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString()))); 
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent[100],
      body: _buildLoginLayout(),
    );
  }

  Widget _buildLoginLayout() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: AppLogo(),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: _buildLoginFields(),
        )
      ],
    );
  }

  Widget _buildLoginFields() {
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Meus contatos',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 55,
                ),
                _buildEmailField(),
                const SizedBox(
                  height: 25,
                ),
                _buildPasswordField(),
                _buildSubmitButton(),
                _buildRegisterText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      initialValue: userdata['email'],
      onSaved: (newValue) => userdata['email'] = newValue.trim(),
      validator: (value) {
        if (value.isEmpty) {
          return 'O email não pode ser vazio';
        }

        return null;
      },
      decoration: InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      initialValue: userdata['username'],
      obscureText: true,
      onSaved: (newValue) => userdata['password'] = newValue.trim(),
      validator: (value) {
        if (value.isEmpty) {
          return 'A senha não pode ser vazia';
        }

        return null;
      },
      decoration: InputDecoration(
          labelText: 'Senha',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: logar,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) return Colors.blue;
            return null;
          },
        ),
      ),
      child: loading
          ? CircularProgressIndicator()
          : Text(
              'Entrar',
              style: TextStyle(color: Colors.white),
            ),
    );
  }

  Widget _buildRegisterText() {
    return ElevatedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Registrator()),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) return Colors.blue;
            return null;
          },
        ),
      ),
      child: Text(
        'Criar conta',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50.0),
    );
  }
}
