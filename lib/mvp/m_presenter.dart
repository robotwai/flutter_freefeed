import 'package:flutter_app/mvp/presenter.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/model/commit_model.dart';

abstract class MicropostIPresenter implements IPresenter {
  loadCommit(int pageNum, int pageSize);

  void dot(Micropost item);

  void sendCommit(String body);
}


abstract class MicropostIView implements IView<MicropostIPresenter> {
  void onloadFLSuc(List<Commit> list);

  void onloadFLFail();

  void updateSingleFeed(Micropost m);
}