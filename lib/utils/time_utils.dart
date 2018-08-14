import 'package:intl/intl.dart';

class TimeUtils {
  static String CalculateTime(String time) {
    var nowTime = new DateTime.now().millisecondsSinceEpoch; //获取当前时间的毫秒数
    String msg;
    time = time.replaceAll(new RegExp('[A-Z]'), " ").trim();
    DateTime realtime;
    try {
      var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
      realtime = formatter.parse(time);
    } catch (e) {
      print('');
      print(e.toString());
    }
    //时间显示少了八小时所以这里需要再加上
    var reset =
        realtime.millisecondsSinceEpoch + 8 * 60 * 60 * 1000; //获取指定时间的毫秒数
    int dateDiff = nowTime - reset;
    msg = "刚刚";
    if (dateDiff < 0) {
      msg = "刚刚";
    } else {
      int dateTemp1 = dateDiff ~/ 1000; //秒
      int dateTemp2 = dateTemp1 ~/ 60; //分钟
      int dateTemp3 = dateTemp2 ~/ 60; //小时
      int dateTemp4 = dateTemp3 ~/ 24; //天数
      int dateTemp5 = dateTemp4 ~/ 30; //月数
      int dateTemp6 = dateTemp5 ~/ 12; //年数

      if (dateTemp6 > 0) {
        msg = '$dateTemp6' + "年前";
      } else if (dateTemp5 > 0) {
        msg = '$dateTemp5' + "个月前";
      } else if (dateTemp4 > 0) {
        msg = '$dateTemp4' + "天前";
      } else if (dateTemp3 > 0) {
        msg = '$dateTemp3' + "小时前";
      } else if (dateTemp2 > 0) {
        msg = '$dateTemp2' + "分钟前";
      } else if (dateTemp1 > 0) {
        msg = "刚刚";
      }
    }
    return msg;
  }
}
