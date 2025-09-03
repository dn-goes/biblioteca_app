import 'package:flutter/material.dart';
import '../../controllers/emprestimo_controller.dart';
import '../../controllers/usuario_controller.dart';
import '../../controllers/livros_controller.dart';
import '../../models/usuario_model.dart';
import '../../models/livro.model.dart';
import '../../models/emprestimo.model.dart';
import 'emprestimo_form_view.dart';

class EmprestimoListView extends StatefulWidget {
  const EmprestimoListView({super.key});

  @override
  State<EmprestimoListView> createState() => _EmprestimoListViewState();
}

class _EmprestimoListViewState extends State<EmprestimoListView> {
  final _controller = EmprestimoController();
  final _usuarioController = UsuarioController();
  final _livroController = LivroController();

  List<EmprestimoModel> _emprestimos = [];
  List<UsuarioModel> _usuarios = [];
  List<LivroModel> _livros = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() async {
    setState(() => _carregando = true);
    _usuarios = await _usuarioController.fetchAll();
    _livros = await _livroController.fetchAll();
    _emprestimos = await _controller.fetchAll();
    setState(() => _carregando = false);
  }

  String _nomeUsuario(String id) => _usuarios.firstWhere((u) => u.id == id, orElse: () => UsuarioModel(id: id, nome: "Desconhecido", email: "")).nome;
  String _tituloLivro(String id) => _livros.firstWhere((l) => l.id == id, orElse: () => LivroModel(id: id, titulo: "Desconhecido", autor: "", anoPublicacao: 0, disponivel: true)).titulo;

  void _abrirForm({EmprestimoModel? e}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EmprestimoFormView(emprestimo: e, controller: _controller)),
    );
    if (result == true) _carregarDados();
  }

  void _delete(EmprestimoModel e) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmar Exclusão"),
        content: const Text("Deseja realmente excluir este empréstimo?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Confirmar")),
        ],
      ),
    );
    if (confirmar == true) {
      await _controller.delete(e.id!);
      _carregarDados();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Empréstimo excluído!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Empréstimos")),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _emprestimos.length,
              itemBuilder: (context, index) {
                final e = _emprestimos[index];
                return Card(
                  child: ListTile(
                    title: Text(_tituloLivro(e.livroId)),
                    subtitle: Text(
                        "Usuário: ${_nomeUsuario(e.usuarioId)}\nEmpréstimo: ${e.dataEmprestimo} → Devolução: ${e.dataDevolucao}\nDevolvido: ${e.devolvido ? "Sim" : "Não"}"),
                    isThreeLine: true,
                    leading: IconButton(icon: const Icon(Icons.edit), onPressed: () => _abrirForm(e: e)),
                    trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _delete(e)),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(onPressed: () => _abrirForm(), child: const Icon(Icons.add)),
    );
  }
}
