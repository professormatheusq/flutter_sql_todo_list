class Tarefa {
  final int? id;
  final String titulo;
  final bool concluida;

  Tarefa({this.id, required this.titulo, required this.concluida});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'concluida': concluida ? 1 : 0,
    };
  }

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'],
      titulo: map['titulo'],
      concluida: map['concluida'] == 1,
    );
  }
}