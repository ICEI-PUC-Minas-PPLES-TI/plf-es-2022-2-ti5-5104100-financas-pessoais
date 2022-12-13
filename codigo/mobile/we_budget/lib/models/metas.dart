import 'dart:convert';

List<MetasModel> employeeFromJson(String str) =>
    List<MetasModel>.from(json.decode(str).map((x) => MetasModel.fromJson(x)));

String employeeToJson(List<MetasModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MetasModel {
  final String idCategoria;
  final String idMeta;
  final String dataMeta;
  final double valorMeta;
  final double valorAtual;
  final bool recorrente;

  MetasModel({
    required this.idCategoria,
    required this.idMeta,
    required this.dataMeta,
    required this.valorMeta,
    required this.valorAtual,
    required this.recorrente,
  });

  @override
  String toString() {
    String item =
        '$idCategoria-$idMeta-$dataMeta-$valorMeta-$valorAtual-$recorrente';
    return item;
  }

  factory MetasModel.fromJson(Map<String, dynamic> json) => MetasModel(
        idCategoria: json['categoryId'].toString(),
        idMeta: json['id'].toString(),
        dataMeta: json['budgetDate'].toString(),
        valorMeta: double.parse(json['budgetValue'].toString()),
        valorAtual: double.parse(json['budgetValueUsed'].toString()),
        recorrente: json['active'],
      );

  Map<String, dynamic> toJson() => {
        "idCategoria": idCategoria,
        "idMeta": idMeta,
        "dataMeta": dataMeta,
        "valorMeta": valorMeta,
        "valorAtual": valorAtual,
        "recorrente": recorrente,
      };
}
