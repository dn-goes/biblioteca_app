class EmprestimoModel {
  String? id;
  String usuarioId;
  String livroId;
  String dataEmprestimo;
  String dataDevolucao;
  bool devolvido;

  EmprestimoModel({
    this.id,
    required this.usuarioId,
    required this.livroId,
    required this.dataEmprestimo,
    required this.dataDevolucao,
    this.devolvido = false,
  });
}
