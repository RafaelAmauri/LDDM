import 'package:listadecontas/providers/auth_provider.dart';
import 'package:listadecontas/providers/contasprovider.dart';
import 'package:listadecontas/screens/login.dart';
import 'package:listadecontas/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:listadecontas/screens/home.dart';
import 'package:listadecontas/screens/splash_screen.dart';
import 'package:provider/provider.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ContasProvider>(
            create: (context) => ContasProvider(),
            update: (context, value, previous) =>
                ContasProvider.logged_in(value.userId))
      ],
      child: MaterialApp(
          title: 'Lista de Contas',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: Consumer<AuthProvider>(
              builder: (context, value, child) => value.is_authenticated
                  ? Homepage()
                  : FutureBuilder(
                      future: value.is_signed_in(),
                      builder: (ctx, result) =>
                          result.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : LoginPage())),
          routes: {
            LoginPage.routename: (ctx) => LoginPage(),
            Registrator.routename: (ctx) => Registrator(),
            Homepage.routename: (ctx) => Homepage()
          }),
    );
  }
}
