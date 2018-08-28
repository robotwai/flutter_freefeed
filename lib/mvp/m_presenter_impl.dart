import 'package:flutter_app/model/commit_model.dart';
import 'package:flutter_app/mvp/m_presenter.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/network/common_http_client.dart';
import 'package:flutter_app/utils/db_helper.dart';

class MicropostPresenterImpl extends MicropostIPresenter {
  MicropostIView micropostIView;

  MicropostPresenterImpl(this.micropostIView) {
    micropostIView.setPresenter(this);
  }

  @override
  init() {}

  @override
  loadCommit(int pageNum, int id) {
    FFHttpUtils.origin.getComment(pageNum, id).then((onValue) {
      if (onValue != null && onValue.length > 0) {
        micropostIView.onloadFLSuc(onValue);
      } else {
        micropostIView.onloadFLFail();
      }
    });
  }

  @override
  loadDots(int pageNum, int id) {
    FFHttpUtils.origin.getDots(pageNum, id).then((onValue) {
      if (onValue != null && onValue.length > 0) {
        micropostIView.onloadDotSuc(onValue);
      } else {
        micropostIView.onloadFLFail();
      }
    });
  }

  @override
  void sendCommit(Micropost item, String body) {
    print(body);
    FFHttpUtils.origin.sendCommit(item.id, body).then((onValue) {
      if (onValue == '0') {
        micropostIView.onCommitSuc();
        item.comment_num = item.comment_num + 1;
        MicropostProvider.origin.insert(item);
      } else {
        micropostIView.onCommitFail(onValue);
      }
    });
  }

  @override
  void dot(Micropost item) {
    FFHttpUtils.origin.dot(item).then((onValue) {
      if (onValue != null) {
        MicropostProvider.origin.insert(onValue);
        micropostIView.updateSingleFeed(onValue);
      }
    });
  }

  @override
  loadMicropost(int id) {
    FFHttpUtils.origin.getMicropost(id).then((onValue){
      if (onValue != null) {
        micropostIView.updateSingleFeed(onValue);
      }
    });

  }


}
