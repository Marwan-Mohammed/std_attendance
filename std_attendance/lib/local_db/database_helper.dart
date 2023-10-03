import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  static const databaseName = "apptest33.db";
  static const _databaseVersion = 1;
  static const columnId = 'id';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    //Directory documentsDirectory = await getDatabasesPath();
    String path = p.join(await getDatabasesPath(), databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE user (id INTEGER PRIMARY KEY,  name TEXT, country TEXT,phoneNumber TEXT, email TEXT,gender TEXT,password TEXT )');
    await db.execute(
        'CREATE TABLE verifiy_code (id INTEGER PRIMARY KEY,  code INTEGER)');
    await db.execute(
        'CREATE TABLE individually_khatamati (id INTEGER PRIMARY KEY,  name TEXT, parts TEXT,dateStart TEXT,dateEnd TEXT,duration INTEGER,quranType INTEGER,amountPart TEXT,days TEXT,identifierReader TEXT,startSurah INTEGER,type INTEGER)');
    await db.execute(
        'CREATE TABLE collectivism_khatamati_each_person (id INTEGER PRIMARY KEY,  name TEXT, parts TEXT,dateStart TEXT,dateEnd TEXT,duration INTEGER,quranType INTEGER,amountPartNumber INTEGER,amountPartCount INTEGER,muchReadType INTEGER,privateCollective INTEGER,creatBy INTEGER,classificationKhatma INTEGER,days TEXT,identifierReader TEXT,type INTEGER,joiningUsers TEXT)');
  }

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int?> insert(tableName, Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db?.insert(tableName, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<Map<String, dynamic>?> queryRowByID(tableName, id) async {
    Database? db = await instance.database;
    var list =
        await db?.query(tableName, where: '$columnId = ?', whereArgs: [id]);
    return list?[0];
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>?> queryAllRows(
    tableName,
  ) async {
    Database? db = await instance.database;
    return await db?.query(tableName);
  }

  Future<List<Map<String, dynamic>>?> queryAllRowsWhere(
      tableName, nameColumn, value) async {
    Database? db = await instance.database;
    return await db
        ?.query(tableName, where: '$nameColumn = ?', whereArgs: [value]);
  }

  Future<List<Map<String, dynamic>>?> queryAllRowsWhereTowColumns(
      tableName, column1, column2, value1, value2) async {
    Database? db = await instance.database;
    return await db?.query(tableName,
        where: '$column1 = ? AND $column2 = ?', whereArgs: [value1, value2]);
  }

  Future<List<Map<String, dynamic>>?> queryAllRowsWhereOR(
      tableName, column1, value1, value2) async {
    Database? db = await instance.database;
    return await db?.query(tableName,
        where: '$column1 = ? OR $column1 = ?', whereArgs: [value1, value2]);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount(tableName) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(
        await db?.rawQuery('SELECT COUNT(*) FROM $tableName') ?? []);
  }

  Future<int?> queryRowCountWhere(tableName, nameColumn, value) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db?.rawQuery(
            'SELECT COUNT(*) FROM $tableName WHERE $nameColumn = $value') ??
        []);
  }

  Future<int?> queryRowCountWhereString(tableName, nameColumn, value) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db?.rawQuery(
            "SELECT COUNT(*) FROM $tableName WHERE $nameColumn = '$value' ") ??
        []);
  }

  Future<int?> queryRowCountWhereNot(tableName, nameColumn, value) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db?.rawQuery(
            'SELECT COUNT(*) FROM $tableName WHERE $nameColumn != $value') ??
        []);
  }

  Future<int?> queryRowCountWhereAnd(
      tableName, column1, column2, value1, value2) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db?.rawQuery(
            "SELECT COUNT(*) FROM $tableName WHERE $column1 = $value1 AND $column2 = '$value2' ") ??
        []);
  }

  Future<int?> queryRowCountWhereAndInteger(
      tableName, column1, column2, value1, value2) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db?.rawQuery(
            "SELECT COUNT(*) FROM $tableName WHERE $column1 = $value1 AND $column2 = $value2 ") ??
        []);
  }

  //Update Data
  Future<int?> updateState(String tableName, int id) async {
    Database? db = await instance.database;

    return await db
        ?.rawUpdate('UPDATE $tableName SET state = ? WHERE id = ?', [0, id]);
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int?> update(tableName, Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db
        ?.update(tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int?> updateWhereAnd(tableName, Map<String, dynamic> row, column1,
      column2, value1, value2) async {
    Database? db = await instance.database;
    return await db?.update(tableName, row,
        where: '$column1 = ? AND $column2 = ?', whereArgs: [value1, value2]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int?> delete(tableName, int id) async {
    Database? db = await instance.database;
    return await db?.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int?> deleteAll(tableName) async {
    Database? db = await instance.database;
    return await db?.delete(tableName);
  }

  Future<int?> deleteAllWhere(tableName, nameColumn, value) async {
    Database? db = await instance.database;
    return await db
        ?.delete(tableName, where: '$nameColumn = ?', whereArgs: [value]);
  }

  Future<int?> deleteAllWhereAnd(
      tableName, column1, column2, value1, value2) async {
    Database? db = await instance.database;
    return await db?.delete(tableName,
        where: '$column1 = ? AND $column2 = ?', whereArgs: [value1, value2]);
  }
}
/*
  surahFrom: e.surahFrom,
            ayaFrom: e.ayaFrom,
            surahTo: e.surahTo,
            ayaTo: e.ayaTo,
            pageFrom: e.pageFrom,
            pageTo: e.pageTo))

       'surahFrom': surahFrom,
      'ayaFrom': ayaFrom,
      'surahTo': surahTo,
      'ayaTo': ayaTo,
      'pageFrom': pageFrom,
      'pageTo': pageTo,
          surahFrom: map['surahFrom'] as String,
      ayaFrom: map['ayaFrom'] as String,
      surahTo: map['surahTo'] as String,
      ayaTo: map['ayaTo'] as String,
      pageFrom: map['pageFrom'] as String,
      pageTo: map['pageTo'] as String,
*/