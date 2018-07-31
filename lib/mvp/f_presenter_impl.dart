import 'package:flutter_app/mvp/f_presenter.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'f_repository_impl.dart';
import 'f_repository.dart';
import 'package:flutter_app/network/common_http_client.dart';

class FeedPresenterImpl extends FeedIPresenter implements NetworkBoundResource<List<Micropost>>{
  FeedIView feedIView;
  FeedRepository feedRepository;

  FeedPresenterImpl(this.feedIView){
    feedIView.setPresenter(this);
  }

  @override
  init() {
    // TODO: implement init
    this.feedRepository = new FeedRepositoryImpl(this);
  }
  @override
  loadAIData(String token, int pageNum, int pageSize) {
    feedRepository.start(token, pageNum);
  }

  @override
  void loadForEmpty() {
    print('FeedPresenterImpl loadFLFail');
    feedIView.onloadFLFail();
  }

  @override
  void loadForNet(List<Micropost> t) {
    print('FeedPresenterImpl loadForNet');
    feedIView.onloadFLSuc(t);
  }

  @override
  void loadForDB(List<Micropost> t) {
    print('FeedPresenterImpl loadForDB');
    feedIView.onloadFLSuc(t);
  }


}