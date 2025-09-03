import 'package:biblioteca_app/models/livro.model.dart';
import '../services/api_service.dart';

class LivroController {
  // GET todos os livros
  Future<List<LivroModel>> fetchAll() async {
    final list = await ApiService.getList("livros?_sort=titulo");
    return list.map<LivroModel>((e) => LivroModel.fromJson(e)).toList();
  }

  // GET um livro
  Future<LivroModel> fetchOne(String id) async {
    final json = await ApiService.getOne("livros", id);
    return LivroModel.fromJson(json);
  }

  // POST criar livro
  Future<LivroModel> create(LivroModel livro) async {
    final json = await ApiService.post("livros", livro.toJson());
    return LivroModel.fromJson(json);
  }

  // PUT atualizar livro
  Future<LivroModel> update(LivroModel livro) async {
    final json = await ApiService.put("livros", livro.toJson(), livro.id!);
    return LivroModel.fromJson(json);
  }

  // DELETE livro
  Future<void> delete(String id) async {
    await ApiService.delete("livros", id);
  }

  Future getById(String livroId) async {}
}
