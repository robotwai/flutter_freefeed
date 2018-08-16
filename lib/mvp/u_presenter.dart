import 'package:flutter_app/mvp/presenter.dart';
import 'package:flutter_app/model/commit_model.dart';
import 'package:flutter_app/model/dot_model.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/model/user_model.dart';

abstract class UserIPresenter implements IPresenter {
  loadCommit(int pageNum, int id);

  loadDots(int pageNum, int id);

  void dot(Micropost item);

  loadUser(int id);

  loadMicroposts(int id, int pageNum);
}

abstract class UserIView implements IView<UserIPresenter> {
  void onLoadCoSuc(List<Commit> list);

  void onLoadMicropostSuc(List<Micropost> list);

  void onLoadDotSuc(List<Dot> list);

  void onLoadFail();

  void updateSingleFeed(Micropost m);

  void onLoadUserSuc(User user);

}