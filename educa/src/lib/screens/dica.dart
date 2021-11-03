import 'package:flutter/material.dart';

class Dica extends StatelessWidget {
  static const String routename = 'dica';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela de dica'),
      ),
      body: Center(
        child: Container(
          child: Image.asset('assets/image/alfabeto.jpeg'),
          width: 250,
          height: 400,
        ),
      ),
    );
  }
}
