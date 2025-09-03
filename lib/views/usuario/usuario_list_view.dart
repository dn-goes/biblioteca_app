import 'package:biblioteca_app/controllers/usuario_controller.dart';
import 'package:biblioteca_app/models/usuario_model.dart';
import 'package:biblioteca_app/views/usuario/usuario_form_view.dart';
import 'package:flutter/material.dart';

class UsuarioListView extends StatefulWidget {
  const UsuarioListView({super.key});

  @override
  State<UsuarioListView> createState() => _UsuarioListViewState();
}

class _UsuarioListViewState extends State<UsuarioListView> {
  final _controller = UsuarioController();
  List<UsuarioModel> _usuarios = [];
  List<UsuarioModel> _usuariosFiltrados = [];
  bool _carregando = true;

  final _buscaField = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _carregando = true);
    try {
      _usuarios = await _controller.fetchAll();
      _usuariosFiltrados = _usuarios;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar usuários: $e")),
      );
    }
    setState(() => _carregando = false);
  }

  void _abrirForm({UsuarioModel? usuario}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UsuarioFormView(usuario: usuario),
      ),
    );
    _carregarDados(); // Recarrega a lista após voltar do form
  }

  void _filtrar() {
    final busca = _buscaField.text.toLowerCase();
    setState(() {
      _usuariosFiltrados = _usuarios.where((user) {
        return user.nome.toLowerCase().contains(busca) ||
            user.email.toLowerCase().contains(busca);
      }).toList();
    });
  }

  void _deletarUsuario(UsuarioModel usuario) async {
    if (usuario.id == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar Exclusão"),
        content:
            Text("Deseja realmente excluir o usuário '${usuario.nome}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Excluir"),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await _controller.delete(usuario.id!);
        _carregarDados();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Usuário '${usuario.nome}' excluído.")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao excluir usuário.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // Campo de busca
                  TextField(
                    controller: _buscaField,
                    decoration: InputDecoration(
                      hintText: "Pesquisar por nome ou e-mail",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => _filtrar(),
                  ),
                  const SizedBox(height: 12),

                  // Lista de usuários
                  Expanded(
                    child: _usuariosFiltrados.isEmpty
                        ? const Center(
                            child: Text(
                              "Nenhum usuário encontrado",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _usuariosFiltrados.length,
                            itemBuilder: (context, index) {
                              final usuario = _usuariosFiltrados[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 4),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.indigo.shade100,
                                    child: Icon(Icons.person,
                                        color: Colors.indigo.shade700),
                                  ),
                                  title: Text(usuario.nome,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(usuario.email),
                                  trailing: Wrap(
                                    spacing: 8,
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            _abrirForm(usuario: usuario),
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            _deletarUsuario(usuario),
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirForm(),
        backgroundColor: Colors.indigo.shade600,
        child: const Icon(Icons.add),
      ),
    );
  }
}
