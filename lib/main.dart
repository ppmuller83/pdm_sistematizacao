import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// Aplicativo principal que configura o MaterialApp
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BioConecta Amazônia',
      home: DemandApp(), // Tela principal do aplicativo
      debugShowCheckedModeBanner: false, // Remove a faixa de "debug" no app
    );
  }
}

// Modelo simples para representar uma demanda
class Demand {
  String title;
  String description;
  String category;
  List<String> responses; // lista de respostas (pode conter várias respostas)

  Demand({
    required this.title,
    required this.description,
    required this.category,
  }) : responses = []; // inicia a lista de respostas vazia
}

// StatefulWidget principal que mantém o estado das demandas e da seleção
class DemandApp extends StatefulWidget {
  @override
  _DemandAppState createState() => _DemandAppState();
}

class _DemandAppState extends State<DemandApp> {
  // Controladores para os campos de texto (título, descrição, categoria, resposta)
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController responseController = TextEditingController();

  // Lista em memória para armazenar as demandas cadastradas
  List<Demand> demands = [];

  // Índice da demanda atualmente selecionada (para adicionar resposta), ou null se nenhuma selecionada
  int? selectedDemandIndex;

  @override
  void dispose() {
    // Liberar os controladores de texto quando o widget for destruído
    titleController.dispose();
    descController.dispose();
    categoryController.dispose();
    responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BioConecta Amazônia'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // espaçamento padrão nas bordas
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção de cadastro de nova demanda
            Text(
              'Cadastrar nova demanda:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Campo de texto para o título da demanda
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            // Campo de texto para a descrição da demanda (multilinha)
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: 'Descrição'),
              maxLines: 3, // permite até 3 linhas para texto mais longo
            ),
            // Campo de texto para a categoria da demanda
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Categoria'),
            ),
            // Botão para adicionar a nova demanda à lista
            SizedBox(
              width: double.infinity, // botão ocupa toda a largura disponível
              child: ElevatedButton(
                onPressed: () {
                  // Quando o botão for pressionado, cria uma nova demanda e adiciona à lista
                  String title = titleController.text;
                  String desc = descController.text;
                  String category = categoryController.text;
                  if (title.isNotEmpty && desc.isNotEmpty && category.isNotEmpty) {
                    setState(() {
                      // Adiciona um novo objeto Demand à lista
                      demands.add(Demand(title: title, description: desc, category: category));
                      // Limpa os campos de texto após cadastrar
                      titleController.clear();
                      descController.clear();
                      categoryController.clear();
                    });
                  } else {
                    // Se algum campo estiver vazio, nenhuma demanda é adicionada.
                  }
                },
                child: Text('Adicionar Demanda'),
              ),
            ),
            SizedBox(height: 20), // espaçamento antes da lista
            // Seção de lista de demandas cadastradas
            Text(
              'Demandas cadastradas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Expande para ocupar o espaço disponível (para a lista poder scrollar se exceder a tela)
            Expanded(
              child: ListView.builder(
                itemCount: demands.length,
                itemBuilder: (context, index) {
                  // Cada item da lista será um Card contendo um ListTile com as informações da demanda
                  Demand demand = demands[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    color: selectedDemandIndex == index ? Colors.grey[300] : null, // destaca o item selecionado
                    child: ListTile(
                      title: Text(demand.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Descrição: ${demand.description}'),
                          Text('Categoria: ${demand.category}'),
                          // Se já houver alguma resposta cadastrada para esta demanda, mostra a última resposta
                          if (demand.responses.isNotEmpty)
                            Text('Resposta: ${demand.responses.last}', style: TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      // Ao tocar em uma demanda, torna-a a demanda selecionada
                      onTap: () {
                        setState(() {
                          selectedDemandIndex = index;
                          // Limpa o campo de resposta sempre que selecionamos uma nova demanda
                          responseController.clear();
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            // Seção de resposta à demanda selecionada (só aparece se houver uma demanda selecionada)
            if (selectedDemandIndex != null) ...[
              SizedBox(height: 20),
              Text(
                'Adicionar resposta à demanda selecionada:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                // Mostra o título da demanda selecionada para contexto
                'Demanda: ${demands[selectedDemandIndex!].title}',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              TextField(
                controller: responseController,
                decoration: InputDecoration(labelText: 'Resposta'),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedDemandIndex != null) {
                      String resp = responseController.text;
                      if (resp.isNotEmpty) {
                        setState(() {
                          // Adiciona a resposta na lista de respostas da demanda selecionada
                          demands[selectedDemandIndex!].responses.add(resp);
                          // Limpa o campo de resposta após adicionar
                          responseController.clear();
                        });
                      } else {
                        // Se o campo de resposta estiver vazio, não faz nada.
                      }
                    }
                  },
                  child: Text('Enviar Resposta'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


