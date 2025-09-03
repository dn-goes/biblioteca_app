class LivroModel {
  String? id;
  String titulo;
  String autor;
  int anoPublicacao;
  bool disponivel;

  LivroModel({
    this.id,
    required this.titulo,
    required this.autor,
    required this.anoPublicacao,
    required this.disponivel,
  });

  // Converte JSON para objeto
  factory LivroModel.fromJson(Map<String, dynamic> json) => LivroModel(
        id: json["id"].toString(),
        titulo: json["titulo"] ?? "",
        autor: json["autor"] ?? "",
        anoPublicacao: json["ano_publicacao"] ?? 0,
        disponivel: json["disponivel"] ?? true,
      );

  // Converte objeto para JSON
  Map<String, dynamic> toJson() => {
        if (id != null) "id": id,
        "titulo": titulo,
        "autor": autor,
        "ano_publicacao": anoPublicacao,
        "disponivel": disponivel,
      };
}
