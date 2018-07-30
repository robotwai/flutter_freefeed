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
  static String tab_name = 'micropost_table';
  MicropostProvider() {
    print('init provider');
    init();
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
    print('创建micropost.db成功，创建micropost_table成功');
  }

  String sql_createTable =
      "CREATE TABLE '$tab_name' (id INTEGER PRIMARY KEY, content TEXT)";

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
          "REPLACE INTO '$tab_name'(id,content) VALUES('$_id','$_content')";
      await db.transaction((txn) async {
        await txn.rawInsert(sql);
      });
    }
    await db.close();
  }


  Future<List<Micropost>> getList(int page) async {
    var _path;
    return CommonSP.getDBPath().then((path) {
      print(path);
      _path = path;
      return realgetList(page,_path);
    });
  }

  Future<List<Micropost>> realgetList(int page,String d_path) async {
    Database db = await openDatabase(d_path);
    int end = page*30;
    int start = (end-30)>0?(end-30):0;
    String sql_query = "SELECT * FROM '$tab_name' ORDER BY id DESC LIMIT '$start','$end'";
    print(sql_query);
    List<Map> list = await db.rawQuery(sql_query);
    print(list);
    await db.close();
    return list.map((model) {
      return new Micropost.fromJson(model);
    }).toList();
  }

  Future<Micropost> getMicropost(int id) async {
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
