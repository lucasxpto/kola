import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/historico_controller.dart';
import '../../models/historico_model.dart';

class HistoricoScreen extends StatelessWidget {
  final HistoricoController historicoController =
      Get.put(HistoricoController());
  final oCcy = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  Widget build(BuildContext context) {
    List<HistoricoUso> historicosOrganizados = historicoController.historicos;
    historicosOrganizados.sort((a, b) => b.startTime.compareTo(a.startTime));

    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico de Uso"),
      ),
      body: Obx(() {
        if (historicoController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.separated(
            itemCount: historicosOrganizados.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              var historico = historicosOrganizados[index];
              return ListTile(
                title: Text(historico.salaNome),
                subtitle: Text(
                    "De: ${DateFormat('dd/MM/yyyy H:mm:ss').format(historico.startTime)} Até: ${DateFormat('dd/MM/yyyy H:mm:ss').format(historico.endTime)} - Custo: ${oCcy.format(historico.custo)}"),
              );
            },
          );
        }
      }),
    );
  }
}
