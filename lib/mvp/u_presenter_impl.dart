import 'package:flutter_app/mvp/u_presenter.dart';
import 'package:flutter_app/model/feed_model.dart';
import 'package:flutter_app/network/common_http_client.dart';
import 'package:flutter_app/utils/sp_local.dart';
import 'package:flutter_app/model/account_model.dart';
import 'dart:convert';
import 'package:flutter_app/utils/db_helper.dart';

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
    FFHttpUtils.origin.dot(item).then((onValue) {
      if (onValue != null) {
        MicropostProvider.origin.insert(onValue);
        userIView.updateSingleFeed(onValue);
      }
    });
  }

  @override
  loadDots(int pageNum, int id) {

  }

  @override
  loadCommit(int pageNum, int id) {

  }

  @override
  follow(int id, int type) {
    FFHttpUtils.origin.follow(id, type).then((onValue) {
      if (onValue == '0') {
        userIView.onFollowSuc(type);
      } else {
        userIView.onLoadFail();
      }
    });
  }

  void changeAccountFollow(int type) async {
    Account account = await CommonSP.getAccount();
    if (type == 1) {
      account.follower++;
    } else {
      account.followed--;
    }
    CommonSP.saveAccount(account);
  }

}