import 'package:flutter_app/mvp/presenter.dart';
import 'package:flutter_app/model/feed_model.dart';

abstract class FeedIPresenter implements IPresenter{
  loadAIData(String token,int pageNum,int pageSize);
}


abstract class FeedIView implements IView<FeedIPresenter>{
  void onloadFLSuc(List<Micropost> list);
  void onloadFLFail();
}