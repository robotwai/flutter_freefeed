import 'package:flutter_app/model/commit_model.dart';
import 'package:flutter_app/mvp/m_presenter.dart';
import 'package:flutter_app/model/feed_model.dart';

class MicropostPresenterImpl extends MicropostIPresenter {
  MicropostIView micropostIView;

  MicropostPresenterImpl(this.micropostIView) {
    micropostIView.setPresenter(this);
  }

  @override
  init() {

  }

  @override
  loadCommit(int pageNum, int pageSize) {

  }

  @override
  void sendCommit(String body) {

  }

  @override
  void dot(Micropost item) {

  }

}