import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DbUtil {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'transactions.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE transactions (id TEXT PRIMARY KEY, name TEXT, categoria TEXT, data TEXT, valor REAL, formaPagamento TEXT, latitude REAL, longitude REAL, address TEXT)');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await DbUtil.database();

    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> deletar(String table) async {
    final db = await DbUtil.database();

    await db.delete('transactions');
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbUtil.database();
    return db.query(table);
  }
}
