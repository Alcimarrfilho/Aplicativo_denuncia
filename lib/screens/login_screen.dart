import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/user_model.dart';
import 'feed_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  bool isLogin = true;
  get dbHelper => DBHelper.instance;

  void alternarModo() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void autenticarOuCadastrar() async {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      mostrarMensagem("Preencha todos os campos.");
      return;
    }

    if (isLogin) {
      final usuario = await dbHelper.autenticar(email, senha);
      if (usuario != null) {
        mostrarMensagem("Login realizado com sucesso!");
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const FeedScreen()),
        );
      } else {
        mostrarMensagem("Credenciais inválidas.");
      }
    } else {
      final existente = await dbHelper.buscarPorEmail(email);
      if (existente != null) {
        mostrarMensagem("Usuário já existe.");
        return;
      }

      final novoUsuario = User(email: email, senha: senha);
      await dbHelper.cadastrarUsuario(novoUsuario);
      mostrarMensagem("Cadastro realizado com sucesso!");
      setState(() => isLogin = true);
    }
  }

  void mostrarMensagem(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? "Login" : "Cadastro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: autenticarOuCadastrar,
              child: Text(isLogin ? "Entrar" : "Cadastrar"),
            ),
            TextButton(
              onPressed: alternarModo,
              child: Text(isLogin
                  ? "Não tem conta? Cadastre-se"
                  : "Já tem conta? Faça login"),
            ),
          ],
        ),
      ),
    );
  }
}
