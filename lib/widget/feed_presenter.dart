import 'package:flutter_app/mvp/presenter.dart';

abstract class FeedPresenter extends IPresenter{
  loadFDData(int pageNum,int pageSize);
}