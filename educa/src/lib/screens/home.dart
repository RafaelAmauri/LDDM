import 'package:educa/screens/alfabeto.dart';
import 'package:flutter/material.dart';

import 'numeros.dart';

class Homepage extends StatefulWidget {
  static const routename = 'homepage';
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final device_size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercícios'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Escolha um para praticar:",
              style: TextStyle(fontSize: 40),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 150),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CardEscolha(
                    title: 'Alfabeto',
                    routename: Alfabeto.routename,
                  ),
                  CardEscolha(
                    title: 'Números',
                    routename: Numeros.routename,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardEscolha extends StatelessWidget {
  final String title;
  final String routename;
  const CardEscolha({
    this.title,
    this.routename,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final device_size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(routename),
      child: Container(
        width: device_size.width * 0.4,
        height: 250,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 3),
        ),
      ),
    );
  }
}
