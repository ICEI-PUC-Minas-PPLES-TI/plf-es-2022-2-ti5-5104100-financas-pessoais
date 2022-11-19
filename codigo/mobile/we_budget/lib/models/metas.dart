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
}
