//classe Emprestimo (atributos = BD)
class EmprestimoModel {
  //atributos
  final String? id; //pode ser nulo inicialmente
  final String usuarioId;
  final String livroId;
  final String dataEmprestimo;
  final String dataDevolucao;

  //construtor
  EmprestimoModel({
    this.id, required this.usuarioId, required this.livroId, required this.dataEmprestimo, required this.dataDevolucao
  });

  //fromJson Map => OBJ
  factory EmprestimoModel.fromJson(Map<String,dynamic> json) => 
  EmprestimoModel(
    id: json["id"].toString(),
    usuarioId: json["usuarioId"].toString(),
    livroId: json["livroId"].toString(),
    dataEmprestimo: json["dataEmprestimo"].toString(),
    dataDevolucao: json["dataDevolucao"].toString()
  );

  //toJson OBJ => MAP
  Map<String,dynamic> toJson() => {
    "id":id,
    "usuarioId":usuarioId,
    "livroId":livroId,
    "dataEmprestimo":dataEmprestimo,
    "dataDevolucao":dataDevolucao
  };

}