import 'package:flutter_app/mvp/presenter.dart';
import 'package:flutter_app/model/feed_model.dart';

abstract class FeedIPresenter implements IPresenter{
  loadAIData(String token,int pageNum,int pageSize);

  void dot(String token, Micropost item);
}


abstract class FeedIView implements IView<FeedIPresenter>{
  void onloadFLSuc(List<Micropost> list);
  void onloadFLFail();

  void updateSingleFeed(Micropost m);
}