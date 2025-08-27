//classe Emprestimo (atributos = BD)

import 'package:biblioteca_app/models/emprestimo.model.dart';
import 'package:biblioteca_app/services/api_service.dart';

class EmprestimoController {

  //métodos
  //Get Empréstimos
  Future<List<EmprestimoModel>> fetchAll() async{
    final list = await ApiService.getList("emprestimos");
    //retornar a lista de empréstimos
    return list.map<EmprestimoModel>((e)=>EmprestimoModel.fromJson(e)).toList();
  }
  //Get Empréstimo
  Future<EmprestimoModel> fetchOne(String id) async{
    final emprestimo = await ApiService.getOne("emprestimos", id);
    return EmprestimoModel.fromJson(emprestimo);
  }

  //Post Empréstimo
  Future<EmprestimoModel> create(EmprestimoModel e) async{
    final created = await ApiService.post("emprestimos", e.toJson());
    return EmprestimoModel.fromJson(created);
  }

  //Put Empréstimo
  Future<EmprestimoModel> update(EmprestimoModel e) async{
    final updated = await ApiService.put("emprestimos", e.toJson() as String, e.id! as Map<String, dynamic>);
    return EmprestimoModel.fromJson(updated);
  }

  //Delete Empréstimo
  Future<void> delete(String id) async{
    await ApiService.delete("emprestimos", id);
  }

}