import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/usuario_model.dart';
import '../../services/auth_service.dart';

final AuthService authService = AuthService();

@override
Widget build(BuildContext context) {
  return FutureBuilder<Usuario?>(
    future: authService.getCurrentUser(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.data != null && snapshot.data!.isAdmin) {
          return showAdminUI();
        } else {
          return showRegularUI();
        }
      } else {
        return CircularProgressIndicator(); // Mostra um spinner enquanto carrega
      }
    },
  );
}

Widget showAdminUI() {
  return Scaffold(
    // ... Resto da sua UI ...
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Get.toNamed("/salas");
      },
      child: Icon(Icons.meeting_room),
      tooltip: "Gerenciar Salas",
    ),
  );
}

Widget showRegularUI() {
  return Scaffold(
    // ... Resto da sua UI ...
  );
}
