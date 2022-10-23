import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String _nomeDB = "weBudget.db";
  static const int _versaoDB = 1;

  static const String tableCategoria = "categoria";
  static const String id = "id";
  static const String codeCategoria = "codeCategoria";
  static const String nameCategoria = "nameCategoria";

  static const String tableTransaction = "transactionDB";
  static const String idTransaction = "idTransaction";
  static const String name = "name";
  static const String categoria = "categoria";
  static const String data = "data";
  static const String valor = "valor";
  static const String formaPagamento = "formaPagamento";
  static const String tipoTransacao = "tipoTransacao";
  static const String latitude = "latitude";
  static const String longitude = "longitude";
  static const String address = "address";

  // Aplicação do padrão Singleton na classe.
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  // Configurar a intância única da classe.
  // Abre a base de dados (e cria quando ainda não existir).
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String caminhoDoBanco = await getDatabasesPath();
    String _banco = _nomeDB;
    String path = join(caminhoDoBanco, _banco);

    return await openDatabase(
      path,
      version: _versaoDB,
      onCreate: _criarBanco,
    );
  }

  Future<void> _criarBanco(Database db, int novaVersao) async {
    List<String> queryes = [
      "CREATE TABLE $tableCategoria ($id TEXT PRIMARY KEY, $codeCategoria TEXT, $nameCategoria);",
      "CREATE TABLE $tableTransaction ($idTransaction TEXT PRIMARY KEY, $name TEXT, $categoria TEXT, $data TEXT, $valor DOUBLE, $formaPagamento TEXT, $tipoTransacao TEXT, $latitude DOUBLE, $longitude DOUBLE, $address TEXT);",
    ];

    for (String query in queryes) {
      await db.execute(query);
    }

    print("Banco criado...");
  }
}
