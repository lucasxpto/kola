import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/historico_controller.dart';
import '../../controllers/sala_controller.dart';
import '../../models/usuario_model.dart';
import '../../services/auth_service.dart';

class TelaInicial extends StatelessWidget {
  TelaInicial({Key? key}) : super(key: key);

  final AuthService authService = AuthService();
  final SalaController salaController = Get.put(SalaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Salas Disponíveis"),
        actions: [
          FutureBuilder<Usuario?>(
            future: authService.getCurrentUser(),
            builder: (context, snapshot) {
              List<Widget> actionButtons =
                  []; // Uma lista para guardar os botões de ação

              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  // Se o usuário for admin, adicione o botão de gerenciar salas
                  if (snapshot.data!.isAdmin) {
                    actionButtons.add(IconButton(
                      icon: Icon(Icons.admin_panel_settings),
                      onPressed: () => Get.toNamed("/salas"),
                      tooltip: "Gerenciar Salas",
                    ));
                  }

                  // Adicione o botão de histórico para todos os usuários
                  actionButtons.add(IconButton(
                    icon: Icon(Icons.history),
                    onPressed: () {
                      final HistoricoController historicoController =
                          Get.put(HistoricoController());
                      historicoController.loadHistoricos();
                      Get.toNamed("/historico");
                    },
                    tooltip: "Consultar Histórico",
                  ));

                  // Adicione o botão de logoff
                  actionButtons.add(IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () async {
                      await authService.signOut();
                      Get.offAllNamed(
                          "/login"); // Navegue para a página de login ou para a página inicial depois de sair
                    },
                    tooltip: "Sair",
                  ));
                }
              } else {
                actionButtons.add(Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(),
                ));
              }

              return Row(
                  children: actionButtons); // Retorne a linha de botões de ação
            },
          ),
        ],
      ),
      body: Obx(() {
        if (salaController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.separated(
            itemCount: salaController.salas.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              var sala = salaController.salas[index];
              return ListTile(
                title: Text(sala.nome),
                subtitle: Text(
                    "Capacidade: ${sala.capacidade} - Custo por hora: ${sala.custoPorHora}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize
                      .min, // Garante que os botões não ocupem toda a largura
                  children: [
                    sala.isOcupada
                        ? TextButton(
                            child: Text("Ocupada",
                                style: TextStyle(color: Colors.white)),
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: null, // desabilita a função de clique
                          )
                        : ElevatedButton(
                            child: Text("Reservar",
                                style: TextStyle(color: Colors.white)),
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () {
                              salaController.reservarSala(sala);
                              Get.snackbar(
                                  'Reserva', 'Sala Reservada com sucesso!',
                                  snackPosition: SnackPosition.BOTTOM);
                            },
                          ),
                  ],
                ),
                onTap: () {
                  Get.toNamed("/sala_detalhes/${sala.id}", arguments: sala);
                },
              );
            },
          );
        }
      }),
    );
  }
}
