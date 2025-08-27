// livro

import 'package:biblioteca_app/models/livro.model.dart';
import 'package:biblioteca_app/services/api_service.dart';

  class LivroController {

  //métodos
  //Get Livros
  Future<List<LivroModel>> fetchAll() async{
    final list = await ApiService.getList("livro?_sort=titulo");
    //retornar a lista de livros
    return list.map<LivroModel>((e)=>LivroModel.fromJson(e)).toList();
  }
  //Get Livro
  Future<LivroModel> fetchOne(String id) async{
    final livro = await ApiService.getOne("livro", id);
    return LivroModel.fromJson(livro);
  }

  //Post Livro
  Future<LivroModel> create(LivroModel l) async{
    final created = await ApiService.post("livro", l.toJson());
    return LivroModel.fromJson(created);
  }

  //Put Livro
  Future<LivroModel> update(LivroModel l) async{
    final updated = await ApiService.put("livro", l.toJson() as String, l.id! as Map<String, dynamic>);
    return LivroModel.fromJson(updated);
  }

  //Delete Livro
  Future<void> delete(String id) async{
    await ApiService.delete("livros", id);
  }

}