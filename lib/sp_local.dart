import 'package:shared_preferences/shared_preferences.dart';

class CommonSP{
  void saveAccount(String json) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('account', json);
  }



}