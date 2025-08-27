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
  // índice da página atual
  int _index = 0;

  // páginas
  final List<Widget> _paginas = const [
    LivroListView(),
    EmprestimoListView(),
    UsuarioListView(),
  ];

  // títulos para cada aba
  final List<String> _titulos = const [
    "Gerenciador de Livros",
    "Controle de Empréstimos",
    "Lista de Usuários"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar estilizado
      appBar: AppBar(
        title: Text(
          _titulos[_index],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),

      // conteúdo principal
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: _paginas[_index],
      ),

      // BottomNavigationBar personalizado
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, -3),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _index,
            onTap: (value) => setState(() {
              _index = value;
            }),
            backgroundColor: Colors.white,
            selectedItemColor: Colors.indigo,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book), label: "Livros"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.assignment), label: "Empréstimos"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.people), label: "Usuários"),
            ],
          ),
        ),
      ),
    );
  }
}
