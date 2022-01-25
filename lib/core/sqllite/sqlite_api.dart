import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'custemer_db.db'),
        onCreate: _create, version: 3);
  }

 static  Future _create(Database db, int version) async {
    await  db.execute(
        'CREATE TABLE cemex_user('
            'id TEXT PRIMARY KEY,'
            'companyName TEXT,'
            'companyPhone TEXT,'
            'companyAddress TEXT,'
            'contactName TEXT,'
            'contactPhone TEXT,'
            'industryId INTEGER,'
            'status TEXT,'
            'industry TEXT,'
            'isActive  INTEGER DEFAULT 0,'
            'userName TEXT,'
            'normalizedUserName TEXT,'
            'email TEXT,'
            'normalizedEmail TEXT,'
            'emailConfirmed  INTEGER DEFAULT 0,'
            'password TEXT,'
            'securityStamp TEXT,'
            'concurrencyStamp TEXT,'
            'phoneNumber TEXT,'
            'phoneNumberConfirmed  INTEGER DEFAULT 0,'
            'twoFactorEnabled  INTEGER DEFAULT 0,'
            'lockoutEnabled  INTEGER DEFAULT 0,'
            'accessFailedCount INTEGER,'
            'lockoutEnd TEXT)');
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<int> deleteUser(String userId) async {
    final db = await DBHelper.database();
    return await db.delete("cemex_user", where: 'id = ?', whereArgs: [userId]);
  }
  static Future<int> delete(String table, int userId) async {
    final db = await DBHelper.database();
    return await db.delete(table, where: 'id = ?', whereArgs: [userId]);
  }

  static Future<void> update(String table, value, key) async {
    final db = await DBHelper.database();
    return await db.rawUpdate('UPDATE $table SET $key = ?', [value]);
  }
}
