import 'dart:convert';

List<CategoriaModel> employeeFromJson(String str) => List<CategoriaModel>.from(
    json.decode(str).map((x) => CategoriaModel.fromJson(x)));

String employeeToJson(List<CategoriaModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriaModel {
  final String id;
  final String nameCategoria;
  final String codeCategoria;

  CategoriaModel({
    required this.id,
    required this.codeCategoria,
    required this.nameCategoria,
  });

  @override
  String toString() {
    String item = '$id-$codeCategoria';
    return item;
  }

  factory CategoriaModel.fromJson(Map<String, dynamic> json) => CategoriaModel(
        id: json['id'].toString(),
        codeCategoria: json['iconCode'].toString(),
        nameCategoria: json['description'].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nameCategoria": nameCategoria,
        "codeCategoria": codeCategoria,
      };
}
