import 'package:educa/screens/alfabeto.dart';
import 'package:educa/screens/dica.dart';
import 'package:educa/screens/login.dart';
import 'package:educa/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:educa/screens/home.dart';
import 'package:educa/screens/numeros.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Educa',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: LoginPage.routename,
        routes: {
          LoginPage.routename: (ctx) => LoginPage(),
          Registrator.routename: (ctx) => Registrator(),
          Homepage.routename: (ctx) => Homepage(),
          Alfabeto.routename: (ctx) => Alfabeto(),
          Numeros.routename: (ctx) => Numeros(),
          Dica.routename: (ctx) => Dica()
        });
  }
}
