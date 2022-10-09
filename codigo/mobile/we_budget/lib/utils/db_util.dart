import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DbUtil {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE places (id TEXT PRIMARY KEY, name TEXT, categoria TEXT, data DATE, valor NUMERIC, formaPagamento TEXT, latitude REAL, longitude REAL, address TEXT)');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DbUtil.database();
List<data> testTransations =[
    data(
      id: 1,
      name: "teste1",
      categoria: "arrow_back",
      data: "11/12/2022",
      valor: 80.00,
      formaPagamento: "1",
    );
]

    await db.insert(
      table,
      data.,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbUtil.database();
    return db.query(table);
  }
}
