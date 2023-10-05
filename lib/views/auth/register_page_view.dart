import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/auth_service.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro"),
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
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: "Confirmar Senha"),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text("Registrar"),
              onPressed: () async {
                if (passwordController.text == confirmPasswordController.text) {
                  final user = await authService.registerWithEmailAndPassword(
                    emailController.text,
                    passwordController.text,
                  );
                  if (user != null) {
                    Get.offAllNamed(
                        "/home"); // Redireciona para a tela inicial após o registro bem-sucedido
                  } else {
                    Get.snackbar("Erro",
                        "Falha no registro. Verifique seu e-mail e senha.");
                  }
                } else {
                  Get.snackbar("Erro", "As senhas não coincidem.");
                }
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Já tem uma conta? "),
                TextButton(
                  child: Text("Faça login"),
                  onPressed: () {
                    Get.toNamed("/login"); // Redireciona para a tela de login
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
