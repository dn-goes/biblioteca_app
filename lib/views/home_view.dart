import 'package:biblioteca_app/views/emprestimo/emprestimo_list_view.dart';
import 'package:biblioteca_app/views/livro/livro_list_view.dart';
import 'package:biblioteca_app/views/usuario/usuario_list_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _index = 0;

  final List<Widget> _paginas = const [
    LivroListView(),
    EmprestimoListView(),
    UsuarioListView(),
  ];

  final List<String> _titulos = const [
    "Livros",
    "Empréstimos",
    "Usuários",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titulos[_index],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade600,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _paginas[_index],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.indigo.shade600,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _index,
            onTap: (value) => setState(() => _index = value),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            backgroundColor: Colors.indigo.shade600,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: "Livros",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment),
                label: "Empréstimos",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: "Usuários",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

