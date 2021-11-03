import 'package:listacontatos/providers/auth_provider.dart';
import 'package:listacontatos/providers/contatosprovider.dart';
import 'package:listacontatos/screens/contact_info.dart';
import 'package:listacontatos/screens/list_birth_dates.dart';
import 'package:listacontatos/screens/login.dart';
import 'package:listacontatos/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:listacontatos/screens/home.dart';
import 'package:listacontatos/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ContatosProvider>(
            create: (context) => ContatosProvider(),
            update: (context, value, previous) =>
                ContatosProvider.logged_in(value.get_user_id()))
      ],
      child: MaterialApp(
          title: 'Lista de Contatos',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: Consumer<AuthProvider>(
              builder: (context, value, child) => value.is_authenticated
                  ? Homepage()
                  : FutureBuilder(
                      future: value.try_auto_login(),
                      builder: (ctx, result) =>
                          result.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : LoginPage())),
          routes: {
            LoginPage.routename: (ctx) => LoginPage(),
            Registrator.routename: (ctx) => Registrator(),
            Homepage.routename: (ctx) => Homepage(),
            ContactInfo.routename: (ctx) => ContactInfo(),
            ListOfBirthdates.routename: (ctx) => ListOfBirthdates()
          }),
    );
  }
}
