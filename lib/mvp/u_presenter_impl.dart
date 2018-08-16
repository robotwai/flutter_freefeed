import 'package:flutter_app/mvp/u_presenter.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/network/common_http_client.dart';

class UserPresenterImpl extends UserIPresenter {
  UserIView userIView;

  UserPresenterImpl(this.userIView) {
    userIView.setPresenter(this);
  }

  @override
  init() {

  }

  @override
  loadUser(int id) {
    FFHttpUtils.origin.getUser(id).then((onValue) {
      if (onValue != null) {
        userIView.onLoadUserSuc(onValue);
      }
    });
  }


  @override
  loadMicroposts(int id, int pageNum) {
    FFHttpUtils.origin.getMicropostList(id, pageNum).then((onValue) {
      if (onValue != null) {
        userIView.onLoadMicropostSuc(onValue);
      }
    });
  }

  @override
  void dot(Micropost item) {

  }

  @override
  loadDots(int pageNum, int id) {

  }

  @override
  loadCommit(int pageNum, int id) {

  }
}