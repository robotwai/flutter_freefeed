import 'package:flutter_app/mvp/f_presenter.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'f_repository_impl.dart';
import 'f_repository.dart';

class FeedPresenterImpl extends FeedIPresenter{
  FeedIView feedIView;
  FeedRepository feedRepository;

  FeedPresenterImpl(this.feedIView);

  @override
  init() {
    // TODO: implement init
    this.feedRepository = new FeedRepositoryImpl();
  }
  @override
  loadAIData(String type, int pageNum, int pageSize) {

  }
}