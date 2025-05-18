import 'package:flutter/material.dart';
import 'package:meu_app/screens/feed_screen.dart';
import 'screens/login_screen.dart';
import 'screens/new_denuncia.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Denúncias',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/feed': (context) => const FeedScreen(),
        '/new': (context) => const NewDenunciaScreen(),
      },
    );
  }
}
