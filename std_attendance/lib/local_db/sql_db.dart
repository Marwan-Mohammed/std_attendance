import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'myaapp.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {
    print("onUpgrade =====================================");
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE student (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          cn_no INTEGER ,
          fname TEXT NOT NULL, 
          level INTEGER NOT NULL,
          dept TEXT NOT NULL,
          college TEXT NOT NULL) 
          ''');
    await db.execute('''
        CREATE TABLE teacher (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          fname TEXT NOT NULL,
          pass TEXT NOT NULL) 
          ''');
    await db.execute('''
        CREATE TABLE subject (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL, 
          level INTEGER NOT NULL,
          dept TEXT NOT NULL,
          college TEXT NOT NULL,
          teacher_id INTEGER,
          CONSTRAINT fk_teacher FOREIGN KEY (teacher_id) REFERENCES teacher (id)) 
          ''');

    await db.execute('''
        CREATE TABLE attendance (
          std_id INTEGER NOT NULL,
          sub_id INTEGER NOT NULL,
          is_attend INTEGER NOT NULL,
          CONSTRAINT fk_std FOREIGN KEY (std_id) REFERENCES student (id),
          CONSTRAINT fk_sub FOREIGN KEY (sub_id) REFERENCES subject (id)) 
          ''');

    print(" onCreate =====================================");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  deleteDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'myaapp.db');
    await deleteDatabase(path);
    _db = null;
  }

//inser,update,delete and read methods
  Future<List<Map<dynamic, dynamic>>> query(String tableName,
      {List<String>? myColumns, String? myWhere}) async {
    Database? mydb = await db;
    List<Map> response =
        await mydb!.query(tableName, columns: myColumns, where: myWhere);
    return response;
  }

  Future<int> insert(String tableName, Map<String, dynamic> values) async {
    Database? mydb = await db;
    int response = await mydb!.insert(tableName, values);
    return response;
  }

  Future<int> update(String tableName, Map<String, dynamic> values,
      {String? myWhere}) async {
    Database? mydb = await db;
    int response = await mydb!.update(tableName, values, where: myWhere);
    return response;
  }

  Future<int> delete(String tableName, {String? myWhere}) async {
    Database? mydb = await db;
    int response = await mydb!.delete(tableName, where: myWhere);
    return response;
  }
}
