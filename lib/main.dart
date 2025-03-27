import 'package:flutter/material.dart';
import 'db/database_helper.dart';
import 'models/tarefa.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TarefaPage(),
    );
  }
}

class TarefaPage extends StatefulWidget {
  @override
  _TarefaPageState createState() => _TarefaPageState();
}

class _TarefaPageState extends State<TarefaPage> {
  final TextEditingController _controller = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Tarefa> _tarefas = [];

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() async {
    final tarefas = await dbHelper.listarTarefas();
    setState(() => _tarefas = tarefas);
  }

  void _addTarefa() async {
    if (_controller.text.isEmpty) return;
    await dbHelper.inserirTarefa(
      Tarefa(titulo: _controller.text, concluida: false),
    );
    _controller.clear();
    _refreshList();
  }

  void _toggleTarefa(Tarefa tarefa) async {
    await dbHelper.atualizarTarefa(
      Tarefa(id: tarefa.id, titulo: tarefa.titulo, concluida: !tarefa.concluida),
    );
    _refreshList();
  }

  void _deleteTarefa(int id) async {
    await dbHelper.excluirTarefa(id);
    _refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tarefas")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: "Nova tarefa"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTarefa,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = _tarefas[index];
                return ListTile(
                  title: Text(
                    tarefa.titulo,
                    style: TextStyle(
                      decoration: tarefa.concluida
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  leading: Checkbox(
                    value: tarefa.concluida,
                    onChanged: (_) => _toggleTarefa(tarefa),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteTarefa(tarefa.id!),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}