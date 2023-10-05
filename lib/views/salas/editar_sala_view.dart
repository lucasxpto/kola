import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/sala_controller.dart';
import '../../models/sala_model.dart';

class EditarSalaPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Sala sala;

  final TextEditingController _nomeController;
  final TextEditingController _capacidadeController;
  final TextEditingController _custoPorHoraController;
  final RxList<String> _recursosSelecionados;

  final SalaController salaController = Get.find();

  EditarSalaPage({Key? key, required this.sala})
      : _nomeController = TextEditingController(text: sala.nome),
        _capacidadeController =
            TextEditingController(text: sala.capacidade.toString()),
        _custoPorHoraController =
            TextEditingController(text: sala.custoPorHora.toString()),
        _recursosSelecionados = RxList<String>.from(sala.recursos),
        super(key: key);

  Widget _buildChips() {
    return Obx(() {
      return Wrap(
        spacing: 8.0,
        children: salaController.recursosDisponiveis.map((recurso) {
          return _buildFilterChip(recurso);
        }).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editar Sala")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _nomeField(),
              SizedBox(height: 16.0),
              _capacidadeField(),
              SizedBox(height: 16.0),
              _custoPorHoraField(),
              SizedBox(height: 16.0),
              _buildChips(),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _updateSala,
                child: Text("Salvar Sala"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nomeField() {
    return TextFormField(
      controller: _nomeController,
      decoration: InputDecoration(labelText: "Nome da Sala"),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Por favor, insira o nome da sala.';
        }
        return null;
      },
    );
  }

  Widget _capacidadeField() {
    return TextFormField(
      controller: _capacidadeController,
      decoration: InputDecoration(labelText: "Capacidade"),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Por favor, insira a capacidade.';
        }
        return null;
      },
    );
  }

  Widget _custoPorHoraField() {
    return TextFormField(
      controller: _custoPorHoraController,
      decoration: InputDecoration(labelText: "Custo por Hora"),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Por favor, insira o custo por hora.';
        }
        return null;
      },
    );
  }

void _updateSala() async {
    if (_formKey.currentState!.validate()) {
        Sala salaAtualizada = Sala(
            id: sala.id,
            nome: _nomeController.text,
            capacidade: int.parse(_capacidadeController.text),
            custoPorHora: double.parse(_custoPorHoraController.text),
            recursos: _recursosSelecionados,
        );
        await salaController.updateSala(salaAtualizada);

        // Após atualizar a sala, recarregue a lista.
        await salaController.loadSalas();

        // Navegar para a rota nomeada '/salas'
        Get.offNamed('/salas');
    }
}

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      selected: _recursosSelecionados.contains(label),
      onSelected: (isSelected) {
        if (isSelected) {
          _recursosSelecionados.add(label);
        } else {
          _recursosSelecionados.remove(label);
        }
      },
    );
  }
}
