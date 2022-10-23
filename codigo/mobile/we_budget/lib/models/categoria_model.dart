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
}
