import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/model/account_model.dart';
import 'dart:convert';
import 'dart:async';

class CommonSP{
  static void saveAccount(String json) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('account', json);
  }

  static Future<Account> getAccount() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json =prefs.getString('account');
    Map userMap = JSON.decode(json);
    Account user = new Account.fromJson(userMap);

    return user;
  }

}