import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kolab/firebase_options.dart';
import 'package:kolab/views/salas/salas_views.dart';

import 'services/auth_service.dart';
import 'views/auth/login_page_view.dart';
import 'views/auth/register_page_view.dart';
import 'views/salas/sala_detalhes_view.dart';
import 'views/salas/tela_inicial_view.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema de Reservas de Salas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthService().currentUser == null ? LoginPage() : TelaInicial(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => TelaInicial(),
        '/salas': (context) => SalasPage(),
        '/sala/detalhes': (context) => SalaDetalhesPage(),
      },
    );
  }
}
