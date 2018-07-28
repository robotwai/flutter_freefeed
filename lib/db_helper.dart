import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/sp_local.dart';

final String tableTodo = "micropost_table";
final String columnId = "id";
final String columnContent = "content";

class MicropostProvider {
  static final MicropostProvider origin = MicropostProvider();
  Database db;
  String dbPath;
  String dbName = 'micropost.db';

  MicropostProvider() {
//    init();
  }

  Future init() async {
    CommonSP.getDBPath().then((path) {
      if (path == null) {
        print('no');
        _create();
      } else {
        print('has');
      }
    });
  }

  Future<String> _createNewDb(String dbName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print(documentsDirectory);

    String path = join(documentsDirectory.path, dbName);

    if (await new Directory(dirname(path)).exists()) {
//      await deleteDatabase(path);
    } else {
      try {
        await new Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }
    }
    return path;
  }

  _create() async {
    dbPath = await _createNewDb(dbName);
    CommonSP.saveDBPath(dbPath);
    Database db = await openDatabase(dbPath);

    await db.execute(sql_createTable);
    await db.close();
    print('创建user.db成功，创建user_table成功');
  }

  String sql_createTable =
      'CREATE TABLE micropost_table (id INTEGER PRIMARY KEY, content TEXT)';
  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableTodo ( 
  $columnId integer primary key , 
  $columnContent text not null
''');
    });
  }

  insertAll(List<Micropost> todo) async {
    CommonSP.getDBPath().then((path) {
      print(path);
      realInsert(todo, path);
    });
  }

  realInsert(List<Micropost> list, String d_path) async {
    print('dbPath' + d_path);
    Database db = await openDatabase(d_path);
    for (var mic in list) {
      var _id = mic.id;
      var _content = mic.content;
      String sql =
          "REPLACE INTO micropost_table(id,content) VALUES('$_id','$_content')";
      await db.transaction((txn) async {
        await txn.rawInsert(sql);
        print('success');
      });
    }
    await db.close();
  }


  Future<List<Micropost>> getList() async {
    var _path;
    return CommonSP.getDBPath().then((path) {
      print(path);
      _path = path;
      return realgetList(_path);
    });
  }

  String sql_query = 'SELECT * FROM micropost_table';
  Future<List<Micropost>> realgetList(String d_path) async {
    Database db = await openDatabase(d_path);
    List<Map> list = await db.rawQuery(sql_query);
    print(list);
    await db.close();
    return list.map((model) {
      return new Micropost.fromJson(model);
    }).toList();
  }

  Future<Micropost> getTodo(int id) async {
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnContent],
        where: "$columnId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Micropost.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> update(Micropost todo) async {
    return await db.update(tableTodo, todo.toMap(),
        where: "$columnId = ?", whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}
