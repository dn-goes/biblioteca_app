import '../models/emprestimo.model.dart';
import 'livros_controller.dart';

class EmprestimoController {
  final LivroController _livroController = LivroController();
  final List<EmprestimoModel> _emprestimos = [];

  Future<List<EmprestimoModel>> fetchAll() async => _emprestimos;

  Future<EmprestimoModel?> getById(String id) async {
    try {
      return _emprestimos.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> create(EmprestimoModel e) async {
    e.id ??= DateTime.now().millisecondsSinceEpoch.toString();
    _emprestimos.add(e);

    final livro = await _livroController.getById(e.livroId);
    if (livro != null && !e.devolvido) {
      livro.disponivel = false;
      await _livroController.update(livro);
    }
  }

  Future<void> update(EmprestimoModel e) async {
    final index = _emprestimos.indexWhere((emp) => emp.id == e.id);
    if (index != -1) {
      _emprestimos[index] = e;

      final livro = await _livroController.getById(e.livroId);
      if (livro != null) {
        livro.disponivel = e.devolvido;
        await _livroController.update(livro);
      }
    }
  }

  Future<void> delete(String id) async {
    final emprestimo = await getById(id);
    if (emprestimo != null) {
      final livro = await _livroController.getById(emprestimo.livroId);
      if (livro != null) {
        livro.disponivel = true;
        await _livroController.update(livro);
      }
      _emprestimos.removeWhere((e) => e.id == id);
    }
  }
}
