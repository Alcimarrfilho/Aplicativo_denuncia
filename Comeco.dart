import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

void runApp(MyApp myApp) {
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Meu Primeiro App",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class BuildContext {
}

class Colors {
  static var blue;
}

class Widget {
}

ThemeData({required primarySwatch}) {
}

MaterialApp({required String title, required theme, required HomeScreen home}) {
}

class StatelessWidget {
}

class HomeScreen extends StatelessWidget {
  var ScaffoldMessenger;

  void _mostrarMensagem(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem, style: null)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tela Inicial', style: null)),
      body: Center(
        child: Column(
          mainAxisAlignment:.center,
          children: [
            Text('Bem-vindo ao meu app!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _mostrarMensagem(context, 'Você clicou no botão 1');
              },
              child: Text('Botão 1', style: null),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _mostrarMensagem(context, 'Você clicou no botão 2');
              },
              child: Text('Botão 2'),
            ),
          ],
        ),
      ),
    );
  }
}

ElevatedButton({required Null Function() onPressed, required child}) {
}

SizedBox({required int height}) {
}

TextStyle({required int fontSize}) {
}

Center({required Column child}) {
}

mixin MainAxisAlignment {
  var center;
}

class Column {
}

AppBar({required title}) {
}

Widget Scaffold({required appBar, required body}) {
}

Text(String mensagem, {required style}) {
}

SnackBar({required content}) {
}

 
