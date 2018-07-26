import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/model/feed_model.dart';



final String tableTodo = "todo";
final String columnId = "_id";
final String columnContent = "content";
class MicropostProvider {
  static final MicropostProvider origin =  MicropostProvider();
  Database db;
  String dbPath;
  String dbName = 'micropost.db';


  MicropostProvider(){
    init();
  }

  init()async{
    dbPath = await _createNewDb(dbName);
    open(dbPath);
  }

  Future<String> _createNewDb(String dbName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print(documentsDirectory);

    String path = join(documentsDirectory.path, dbName);

    if (await new Directory(dirname(path)).exists()) {
      await deleteDatabase(path);
    } else {
      try {
        await new Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }
    }
    return path;
  }

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table $tableTodo ( 
  $columnId integer primary key autoincrement, 
  $columnContent text not null
''');
        });
  }

  Future<Micropost> insert(Micropost todo) async {
    if(db!=null){
      todo.id = await db.insert(tableTodo, todo.toMap());
      return todo;
    }else{
      return null;
    }

  }

  Future<Micropost> insertAll(List<Micropost> todo) async {


    return insert(todo.first);

  }

  Future<List<Micropost>> getMicroposts() async{
    List<Map> maps =await db.query(tableTodo);
    if (maps.length > 0) {
      return maps.map((model) {
            return new Micropost.fromJson(model);
            }).toList();
    }
    return null;
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