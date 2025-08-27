import 'package:biblioteca_app/controllers/emprestimo_controller.dart';
import 'package:biblioteca_app/models/emprestimo.model.dart';
import 'package:flutter/material.dart';

class EmprestimoListView extends StatefulWidget {
  const EmprestimoListView({super.key});

  @override
  State<EmprestimoListView> createState() => _EmprestimoListViewState();
}

class _EmprestimoListViewState extends State<EmprestimoListView> {
  //atributos
  final _controller = EmprestimoController();
  List<EmprestimoModel> _emprestimos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  _carregarDados() async{
    setState(() {
      _carregando = true;
    });
    try {
      _emprestimos = await _controller.fetchAll();
    } catch (e) {
      //Tratar Erro      
    }
    setState(() {
      _carregando = false;
    });
  }

  //build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _carregando
      ? Center(child: CircularProgressIndicator(),)
      : Expanded(
        child: ListView.builder(
          itemCount: _emprestimos.length,
          itemBuilder: (context, index) {
            final emprestimo = _emprestimos[index];
            return Card(
              child: ListTile(
                title: Text(emprestimo.livroId.titulo),
                subtitle: Text(emprestimo.usuarioId.email),
                //trailing -> deletar emprestimo
              ),
            );
          },
        ),
      ),
    );
  }
}

extension on String {
  String get titulo => this;

  String get email => this;
}