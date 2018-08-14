import 'package:flutter_app/mvp/presenter.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/model/commit_model.dart';
import 'package:flutter_app/model/dot_model.dart';

abstract class MicropostIPresenter implements IPresenter {
  loadCommit(int pageNum, int id);

  loadDots(int pageNum, int id);
  void dot(Micropost item);

  void sendCommit(int id, String body);
}


abstract class MicropostIView implements IView<MicropostIPresenter> {
  void onloadFLSuc(List<Commit> list);

  void onloadDotSuc(List<Dot> list);
  void onloadFLFail();

  void updateSingleFeed(Micropost m);

  void onCommitSuc();

  void onCommitFail(String f);
}