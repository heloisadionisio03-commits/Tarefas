import 'package:flutter/material.dart';

void main() {
  // Inicia o aplicativo
  runApp(const MainApp());
}

// Aplicativo principal
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2Do MinimaList',

      // Tema preto e vermelho
      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE53935),
          brightness: Brightness.dark,
        ),

        // Cor de fundo principal
        scaffoldBackgroundColor:
            const Color(0xFF101010),

        // Barra superior
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0A0A),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        // Cards das tarefas
        cardTheme: CardThemeData(
          color: const Color(0xFF1C1C1C),
          elevation: 3,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      // Define a tela principal
      home: const TarefaScreen(),
    );
  }
}

// Classe que representa uma tarefa
class Tarefa {
  String id;
  String titulo;
  bool concluida;

  Tarefa({
    required this.id,
    required this.titulo,
    this.concluida = false,
  });
}

// Tela principal
class TarefaScreen extends StatefulWidget {
  const TarefaScreen({super.key});

  @override
  State<TarefaScreen> createState() => _TarefaScreenState();
}

class _TarefaScreenState extends State<TarefaScreen> {
  // Lista inicial de tarefas
  final List<Tarefa> _tarefas = [
    Tarefa(
      id: '1',
      titulo: 'Comprar pão, leite e ovo',
    ),
    Tarefa(
      id: '2',
      titulo: 'Responder e-mails do trabalho',
      concluida: true,
    ),
    Tarefa(
      id: '3',
      titulo: 'Academia às 18h',
    ),
  ];

  // Controlador do campo de texto
  final TextEditingController _controller =
      TextEditingController();

  // Conta as tarefas pendentes
  int _contarPendentes() {
    return _tarefas
        .where((tarefa) => !tarefa.concluida)
        .length;
  }

  // Conta as tarefas concluídas
  int _contarConcluidas() {
    return _tarefas
        .where((tarefa) => tarefa.concluida)
        .length;
  }

  // Abre a janela para criar uma nova tarefa
  void _abrirNovaTarefa() {
    _controller.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF181818),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom:
                MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              // Barra decorativa
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  margin: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),
              ),

              // Título
              const Text(
                'Nova tarefa',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 6),

              // Texto de orientação
              Text(
                'Digite uma tarefa para adicionar à sua lista.',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 18),

              // Campo para digitar a tarefa
              TextField(
                controller: _controller,
                autofocus: true,
                style: const TextStyle(
                  color: Colors.white,
                ),
                textCapitalization:
                    TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Ex: Estudar Flutter',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                  ),

                  prefixIcon: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFFE53935),
                  ),

                  filled: true,
                  fillColor: const Color(0xFF252525),

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(
                      color: Color(0xFFE53935),
                      width: 2,
                    ),
                  ),
                ),

                // Adiciona usando Enter
                onSubmitted: (_) {
                  _adicionarTarefa();
                },
              ),

              const SizedBox(height: 16),

              // Botão de adicionar
              ElevatedButton.icon(
                onPressed: _adicionarTarefa,
                icon: const Icon(Icons.add),
                label: const Text(
                  'Adicionar tarefa',
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFE53935),
                  foregroundColor:
                      Colors.white,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Adiciona uma nova tarefa
  void _adicionarTarefa() {
    final texto = _controller.text.trim();

    // Verifica se o campo está vazio
    if (texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFFE53935),
          content: Text(
            'Digite uma tarefa antes de adicionar.',
          ),
        ),
      );

      return;
    }

    // Adiciona a tarefa na lista
    setState(() {
      _tarefas.add(
        Tarefa(
          id: DateTime.now()
              .millisecondsSinceEpoch
              .toString(),
          titulo: texto,
        ),
      );
    });

    _controller.clear();

    // Fecha a janela
    Navigator.pop(context);

    // Mostra mensagem
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFFE53935),
        content: Text(
          'Tarefa adicionada com sucesso!',
        ),
      ),
    );
  }

  // Marca ou desmarca uma tarefa
  void _alternarTarefa(String id) {
    setState(() {
      final tarefa = _tarefas.firstWhere(
        (tarefa) => tarefa.id == id,
      );

      tarefa.concluida = !tarefa.concluida;
    });
  }

  // Exclui uma tarefa
  void _excluirTarefa(String id) {
    setState(() {
      _tarefas.removeWhere(
        (tarefa) => tarefa.id == id,
      );
    });
  }

  // Confirma antes de excluir
  void _confirmarExclusao(Tarefa tarefa) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFF1C1C1C),

          title: const Text(
            'Excluir tarefa?',
            style: TextStyle(
              color: Colors.white,
            ),
          ),

          content: Text(
            'Deseja realmente excluir:\n\n'
            '"${tarefa.titulo}"?',
            style: TextStyle(
              color: Colors.grey.shade300,
            ),
          ),

          actions: [
            // Botão cancelar
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),

            // Botão excluir
            ElevatedButton(
              onPressed: () {
                _excluirTarefa(tarefa.id);

                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    backgroundColor:
                        Color(0xFFE53935),
                    content: Text(
                      'Tarefa excluída.',
                    ),
                  ),
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFE53935),
                foregroundColor:
                    Colors.white,
              ),
              child: const Text(
                'Excluir',
              ),
            ),
          ],
        );
      },
    );
  }

  // Cria o card de uma tarefa
  Widget _criarTarefaCard(Tarefa tarefa) {
    return Dismissible(
      key: ValueKey(tarefa.id),

      // Permite arrastar para a esquerda
      direction:
          DismissDirection.endToStart,

      // Fundo que aparece ao arrastar
      background: Container(
        margin:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFB71C1C),
          borderRadius:
              BorderRadius.circular(14),
        ),
        alignment:
            Alignment.centerRight,
        padding:
            const EdgeInsets.only(
          right: 20,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),

      // Exclui ao arrastar
      onDismissed: (_) {
        _excluirTarefa(tarefa.id);

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            backgroundColor:
                Color(0xFFE53935),
            content: Text(
              'Tarefa excluída.',
            ),
          ),
        );
      },

      child: Card(
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),

          // Checkbox
          leading: Checkbox(
            value: tarefa.concluida,
            activeColor:
                const Color(0xFFE53935),

            checkColor: Colors.white,

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(5),
            ),

            onChanged: (_) {
              _alternarTarefa(
                tarefa.id,
              );
            },
          ),

          // Nome da tarefa
          title: Text(
            tarefa.titulo,
            style: TextStyle(
              fontSize: 15,
              fontWeight:
                  FontWeight.w600,

              // Risca quando concluída
              decoration:
                  tarefa.concluida
                      ? TextDecoration
                          .lineThrough
                      : TextDecoration.none,

              color: tarefa.concluida
                  ? Colors.grey
                  : Colors.white,
            ),
          ),

          // Status da tarefa
          subtitle: Row(
            children: [
              Icon(
                tarefa.concluida
                    ? Icons.check_circle
                    : Icons.access_time,
                size: 14,
                color: tarefa.concluida
                    ? const Color(
                        0xFFE53935,
                      )
                    : Colors.grey,
              ),

              const SizedBox(width: 5),

              Text(
                tarefa.concluida
                    ? 'Concluída'
                    : 'Pendente',
                style: TextStyle(
                  fontSize: 12,
                  color:
                      tarefa.concluida
                          ? const Color(
                              0xFFE53935,
                            )
                          : Colors.grey,
                ),
              ),
            ],
          ),

          // Botão excluir
          trailing: IconButton(
            tooltip:
                'Excluir tarefa',

            icon: const Icon(
              Icons.delete_outline,
              color:
                  Color(0xFFE53935),
            ),

            onPressed: () {
              _confirmarExclusao(
                tarefa,
              );
            },
          ),
        ),
      ),
    );
  }

  // Tela quando não existem tarefas
  Widget _telaSemTarefas() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Icon(
              Icons.task_alt,
              size: 80,
              color:
                  const Color(0xFFE53935),
            ),

            const SizedBox(height: 15),

            const Text(
              'Tudo certo!',
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Você não possui tarefas no momento.',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color:
                    Colors.grey.shade400,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),

            // Botão para criar tarefa
            ElevatedButton.icon(
              onPressed:
                  _abrirNovaTarefa,

              icon: const Icon(
                Icons.add,
              ),

              label: const Text(
                'Criar tarefa',
              ),

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFFE53935,
                ),
                foregroundColor:
                    Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Conta as tarefas pendentes
    final pendentes =
        _contarPendentes();

    // Conta as tarefas concluídas
    final concluidas =
        _contarConcluidas();

    return Scaffold(
      backgroundColor:
          const Color(0xFF101010),

      // Barra superior
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 27,
              color: Color(0xFFE53935),
            ),

            SizedBox(width: 8),

            Text(
              '2Do MinimaList',
            ),
          ],
        ),

        actions: [
          // Mostra quantidade de tarefas pendentes
          Padding(
            padding:
                const EdgeInsets.only(
              right: 16,
            ),

            child: Center(
              child: Text(
                '$pendentes pendentes',

                style:
                    const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),

      // Conteúdo principal
      body: Column(
        children: [
          // Resumo das tarefas
          Container(
            margin:
                const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              8,
            ),

            padding:
                const EdgeInsets.all(18),

            decoration:
                BoxDecoration(
              color:
                  const Color(0xFF1C1C1C),
              borderRadius:
                  BorderRadius.circular(16),

              border: Border.all(
                color:
                    const Color(0xFF2C2C2C),
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.3),
                  blurRadius: 8,
                  offset:
                      const Offset(0, 3),
                ),
              ],
            ),

            child: Row(
              children: [
                // Total de tarefas
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${_tarefas.length}',

                        style:
                            const TextStyle(
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Color(0xFFE53935),
                        ),
                      ),

                      const Text(
                        'Total',

                        style:
                            TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Divisória
                Container(
                  height: 45,
                  width: 1,
                  color:
                      Colors.grey.shade800,
                ),

                // Tarefas pendentes
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '$pendentes',

                        style:
                            const TextStyle(
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Color(0xFFE53935),
                        ),
                      ),

                      const Text(
                        'Pendentes',

                        style:
                            TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Divisória
                Container(
                  height: 45,
                  width: 1,
                  color:
                      Colors.grey.shade800,
                ),

                // Tarefas concluídas
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '$concluidas',

                        style:
                            const TextStyle(
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Color(0xFFE53935),
                        ),
                      ),

                      const Text(
                        'Concluídas',

                        style:
                            TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Lista de tarefas
          Expanded(
            child: _tarefas.isEmpty
                ? _telaSemTarefas()
                : ListView.builder(
                    padding:
                        const EdgeInsets.only(
                      top: 5,
                      bottom: 100,
                    ),

                    itemCount:
                        _tarefas.length,

                    itemBuilder:
                        (context, index) {
                      return _criarTarefaCard(
                        _tarefas[index],
                      );
                    },
                  ),
          ),
        ],
      ),

      // Botão flutuante para adicionar tarefa
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed:
            _abrirNovaTarefa,

        backgroundColor:
            const Color(0xFFE53935),
        foregroundColor:
            Colors.white,

        icon: const Icon(
          Icons.add,
        ),

        label: const Text(
          'Nova tarefa',

          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Libera o controlador quando a tela é fechada
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
