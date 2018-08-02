import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/utils/sp_local.dart';

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
      "CREATE TABLE '$tab_name' (id INTEGER PRIMARY KEY, content TEXT,user_id INTEGER,picture TEXT,"
      "icon TEXT,user_name TEXT,created_at TEXT,dotId INTEGER,dots_num INTEGER,comment_num INTEGER)";

  insertAll(List<Micropost> todo) async {
    CommonSP.getDBPath().then((path) {
//      print(path);
      realInsert(todo, path);
    });
  }

  realInsert(List<Micropost> list, String d_path) async {
//    print('dbPath' + d_path);
    Database db = await openDatabase(d_path);

    await db.transaction((txn) async {
      for (var mic in list) {
        var _id = mic.id;
        var _content = mic.content;
        var user_id = mic.user_id;
        var picture = mic.picture;
        var icon = mic.icon;
        var user_name = mic.user_name;
        var created_at = mic.created_at;
        var dotId = mic.dotId;
        var dots_num = mic.dots_num;
        var comment_num = mic.comment_num;
        String sql = " REPLACE INTO '$tab_name'"
            "(id,content,user_id,picture,icon,user_name,created_at,dotId,dots_num,comment_num)"
            " VALUES('$_id','$_content','$user_id','$picture','$icon','$user_name','$created_at','$dotId','$dots_num','$comment_num')";
        await txn.rawInsert(sql);
      }
    });

    await db.close();
  }

  Future<List<Micropost>> getListAndInsertAll(List<Micropost> todo, int page) {
    return CommonSP.getDBPath().then((path) {
//      print(path);
      return getAndInsert(todo, path, page);
    });
  }

  Future<List<Micropost>> getAndInsert(
      List<Micropost> list, String path, int page) async {
    Database db = await openDatabase(path);

    await db.transaction((txn) async {
      for (var mic in list) {
        var _id = mic.id;
        var _content = mic.content;
        var user_id = mic.user_id;
        var picture = mic.picture;
        var icon = mic.icon;
        var user_name = mic.user_name;
        var created_at = mic.created_at;
        var dotId = mic.dotId;
        var dots_num = mic.dots_num;
        var comment_num = mic.comment_num;
        String sql = " REPLACE INTO '$tab_name'"
            "(id,content,user_id,picture,icon,user_name,created_at,dotId,dots_num,comment_num)"
            " VALUES('$_id','$_content','$user_id','$picture','$icon','$user_name','$created_at','$dotId','$dots_num','$comment_num')";
        await txn.rawInsert(sql);
      }
    });

    int end = page * 30;
    int start = (end - 30) > 0 ? (end - 30) : 0;
    String sql_query =
        "SELECT * FROM '$tab_name' ORDER BY id DESC LIMIT '$start','$end'";
    print(sql_query);
    List<Map> result = await db.rawQuery(sql_query);
    print(result);
    await db.close();
    return result.map((model) {
      return new Micropost.fromJson(model);
    }).toList();
  }

  Future<List<Micropost>> getList(int page) async {
    var _path;
    return CommonSP.getDBPath().then((path) {
//      print(path);
      _path = path;
      return realgetList(page, _path);
    });
  }

  Future<List<Micropost>> realgetList(int page, String d_path) async {
    Database db = await openDatabase(d_path);
    int end = page * 30;
    int start = (end - 30) > 0 ? (end - 30) : 0;
    String sql_query =
        "SELECT * FROM '$tab_name' ORDER BY id DESC LIMIT '$start','$end'";
    print(sql_query);
    List<Map> list = await db.rawQuery(sql_query);
    print(list);
    await db.close();
    return list.map((model) {
      return new Micropost.fromJson(model);
    }).toList();
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
