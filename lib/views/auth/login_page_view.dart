import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/auth_service.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "E-mail"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text("Entrar"),
              onPressed: () async {
                final user = await authService.signInWithEmailAndPassword(
                  emailController.text,
                  passwordController.text,
                );
                if (user != null) {
                  Get.offAllNamed(
                      "/home"); // Navega para a tela inicial após o login bem-sucedido
                } else {
                  Get.snackbar(
                      "Erro", "Falha no login. Verifique seu e-mail e senha.");
                }
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Não tem uma conta? "),
                TextButton(
                  child: Text("Registre-se"),
                  onPressed: () {
                    Get.toNamed("/register");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
