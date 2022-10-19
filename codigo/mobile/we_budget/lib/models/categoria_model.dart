class CategoriaModel {
  final String id;
  final String codeCategoria;

  CategoriaModel({
    required this.id,
    required this.codeCategoria,
  });

  @override
  String toString() {
    String item = '$id-$codeCategoria';
    return item;
  }
}
