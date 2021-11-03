import 'package:educa/screens/home.dart';
import 'package:educa/screens/register.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const routename = 'login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildLoginLayout(),
    );
  }

  Widget _buildLoginLayout() {
    return Stack(
      children: <Widget>[
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildEmailField(),
              _buildPasswordField(),
              _buildSubmitButton(),
              _buildRegisterText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(Homepage.routename);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) return Colors.blue;
            return null;
          },
        ),
      ),
      child: Text(
        'LOGIN',
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
        'Register',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
    );
  }
}
