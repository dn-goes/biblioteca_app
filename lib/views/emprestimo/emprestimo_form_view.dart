import 'package:flutter/material.dart';
import '../../controllers/emprestimo_controller.dart';
import '../../controllers/usuario_controller.dart';
import '../../controllers/livros_controller.dart';
import '../../models/usuario_model.dart';
import '../../models/livro.model.dart';
import '../../models/emprestimo.model.dart';

class EmprestimoFormView extends StatefulWidget {
  final EmprestimoModel? emprestimo;
  final EmprestimoController controller;

  const EmprestimoFormView({super.key, this.emprestimo, required this.controller});

  @override
  State<EmprestimoFormView> createState() => _EmprestimoFormViewState();
}

class _EmprestimoFormViewState extends State<EmprestimoFormView> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = UsuarioController();
  final _livroController = LivroController();

  List<UsuarioModel> _usuarios = [];
  List<LivroModel> _livros = [];
  UsuarioModel? _usuarioSelecionado;
  LivroModel? _livroSelecionado;
  DateTime? _dataEmprestimo;
  DateTime? _dataDevolucao;
  bool _devolvido = false;

  @override
  void initState() {
    super.initState();
    _carregarUsuariosELivros();
    if (widget.emprestimo != null) {
      _usuarioSelecionado = UsuarioModel(id: widget.emprestimo!.usuarioId, nome: '', email: '');
      _livroSelecionado = LivroModel(
          id: widget.emprestimo!.livroId, titulo: '', autor: '', anoPublicacao: 0, disponivel: true);
      _dataEmprestimo = DateTime.parse(widget.emprestimo!.dataEmprestimo);
      _dataDevolucao = DateTime.parse(widget.emprestimo!.dataDevolucao);
      _devolvido = widget.emprestimo!.devolvido;
    }
  }

  void _carregarUsuariosELivros() async {
    _usuarios = await _usuarioController.fetchAll();
    _livros = await _livroController.fetchAll();
    setState(() {});
  }

  Future<void> _selecionarData(bool inicio) async {
    final dataInicial = inicio ? (_dataEmprestimo ?? DateTime.now()) : (_dataDevolucao ?? DateTime.now());
    final data = await showDatePicker(
      context: context,
      initialDate: dataInicial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (data != null) {
      setState(() {
        if (inicio) _dataEmprestimo = data;
        else _dataDevolucao = data;
      });
    }
  }

  void _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_usuarioSelecionado == null || _livroSelecionado == null) return;
    if (_dataEmprestimo == null || _dataDevolucao == null) return;

    final emprestimo = EmprestimoModel(
      id: widget.emprestimo?.id,
      usuarioId: _usuarioSelecionado!.id!,
      livroId: _livroSelecionado!.id!,
      dataEmprestimo:
          "${_dataEmprestimo!.year}-${_dataEmprestimo!.month.toString().padLeft(2, '0')}-${_dataEmprestimo!.day.toString().padLeft(2, '0')}",
      dataDevolucao:
          "${_dataDevolucao!.year}-${_dataDevolucao!.month.toString().padLeft(2, '0')}-${_dataDevolucao!.day.toString().padLeft(2, '0')}",
      devolvido: _devolvido,
    );

    try {
      if (widget.emprestimo == null) {
        await widget.controller.create(emprestimo);
      } else {
        await widget.controller.update(emprestimo);
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.emprestimo == null ? "Novo Empréstimo" : "Editar Empréstimo")),
      body: _usuarios.isEmpty || _livros.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<UsuarioModel>(
                      value: _usuarioSelecionado != null
                          ? _usuarios.firstWhere((u) => u.id == _usuarioSelecionado!.id, orElse: () => _usuarios.first)
                          : null,
                      items: _usuarios.map((u) => DropdownMenuItem(value: u, child: Text(u.nome))).toList(),
                      onChanged: (v) => setState(() => _usuarioSelecionado = v),
                      decoration: const InputDecoration(labelText: "Usuário", border: OutlineInputBorder()),
                      validator: (v) => v == null ? "Selecione um usuário" : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<LivroModel>(
                      value: _livroSelecionado != null
                          ? _livros.firstWhere((l) => l.id == _livroSelecionado!.id, orElse: () => _livros.first)
                          : null,
                      items: _livros.map((l) => DropdownMenuItem(value: l, child: Text(l.titulo))).toList(),
                      onChanged: (v) => setState(() => _livroSelecionado = v),
                      decoration: const InputDecoration(labelText: "Livro", border: OutlineInputBorder()),
                      validator: (v) => v == null ? "Selecione um livro" : null,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text(_dataEmprestimo == null
                          ? "Data Empréstimo"
                          : "Empréstimo: ${_dataEmprestimo!.toLocal().toString().split(' ')[0]}"),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selecionarData(true),
                    ),
                    ListTile(
                      title: Text(_dataDevolucao == null
                          ? "Data Devolução"
                          : "Devolução: ${_dataDevolucao!.toLocal().toString().split(' ')[0]}"),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selecionarData(false),
                    ),
                    SwitchListTile(
                      title: const Text("Devolvido"),
                      value: _devolvido,
                      onChanged: (v) => setState(() => _devolvido = v),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _salvar,
                            icon: const Icon(Icons.save),
                            label: const Text("Salvar"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.cancel),
                            label: const Text("Cancelar"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
