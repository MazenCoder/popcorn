import '../../features/posts/widgets/card_comment.dart';
import 'package:image_picker/image_picker.dart';
import '../models/comment_reply_model.dart';
import 'package:flutter/material.dart';
import '../models/address_model.dart';
import 'package:mobx/mobx.dart';
import 'package:get/get.dart';
import 'dart:io';

part 'mobx_app.g.dart';

class MobxApp = MobxAppBase with _$MobxApp;

abstract class MobxAppBase with Store {

  @observable
  int currentIndex = 0;

  @action
  void onPageChanged(int index) {
    currentIndex = index;
  }


  @observable
  bool isLoad = false;

  @action
  void setLoad(bool val) {
    isLoad = val;
  }

  @observable
  bool obscureText = true;

  @action
  void toggle(bool val) {
    obscureText = val;
  }

  @observable
  int indexTab = 0;

  @action
  void onTabChang(int val) => indexTab = val;

  @observable
  String filePath = '';

  @action
  void setImagePath(String val) => filePath = val;

  @observable
  bool isComposingMessage = false;

  @action
  void setComposingMessage(bool val) => isComposingMessage = val;

  @observable
  bool isSending = false;

  @action
  void setSending(bool val) => isSending = val;

  @observable
  String message = '';

  @action
  void setMessage(String val) => message = val;


  /// ----- Likes -----
  @observable
  bool isLiked = false;

  @action
  void onLikePost(bool val) => isLiked = val;

  @observable
  int likeCount = 0;

  @action
  void onChangeLikeCount(int val) => likeCount = val;


  /// ----- Comments -----
  @observable
  bool isComment = false;

  @action
  void onCommentPost(bool val) => isComment = val;

  @observable
  int commentCount = 0;

  @action
  void onChangeCommentCount(int val) => commentCount = val;

  @observable
  int idTypesPost = 5;

  @action
  void setIdTypePost(int val) => idTypesPost = val;


  @observable
  bool isLoadedComment = false;

  @action
  void setLoadedComment(bool val) => isLoadedComment = val;

  @observable
  ObservableList<XFile> images = ObservableList<XFile>();

  @observable
  ObservableList<AddressModel> listAddress = ObservableList<AddressModel>();

  @observable
  ObservableList<CardComment> cardComments = ObservableList<CardComment>();


  @action
  void removeComment({required String idComment}) {
    if (cardComments.isEmpty) return;
    final index = cardComments.indexWhere((element) => element.key == Key(idComment));
    if (index != -1) {
      cardComments.removeAt(index);
    }
  }

  @observable
  int maxLines = 8;

  @action
  void setMaxLines(int val) => maxLines = val;


  @observable
  ObservableList<AddressModel> addresses = ObservableList<AddressModel>();

  @action
  void setAddressMod(List<AddressModel> val) {
    addresses.clear();
    addresses.addAll(val);
  }

  @observable
  CommentReplyModel? replyModel;

  @action
  void setReplyComment(CommentReplyModel? model) {
    replyModel = model;
  }

  @observable
  String commentId = '';

  @action
  void setCommentId(String val) => commentId = val;

  @observable
  String companySize = 'select_company_size'.tr;

  @action
  void selectCompanySize(String topic) => companySize = topic;

  @observable
  String companyType = 'select_company_type'.tr;

  @action
  void selectCompanyType(String topic) => companyType = topic;


  @observable
  ObservableList<Widget> replyComments = ObservableList<Widget>();

  @action
  void removeReplyComment({required String idComment}) {
    if (replyComments.isEmpty) return;
    final index = replyComments.indexWhere((element) => element.key == Key(idComment));
    if (index != -1) {
      replyComments.removeAt(index);
    }
  }

  @observable
  int? indexAction;

  @action
  void setIndexAction(int val) => indexAction = val;

  @observable
  bool textIsNotEmpty = false;

  @action
  void onChangeText(bool val) => textIsNotEmpty = val;

  @observable
  int idVisibility = 0;

  @action
  void setIdVisibility(int val) => idVisibility = val;

  @observable
  bool gridLarge = false;

  @action
  void setDisplayLayout(bool val) => gridLarge = val;

  @observable
  double level = 0.0;

  @action
  void setLevel(double value) {
    level = value;
  }

  @observable
  File? file;

  @action
  void setFile(File? value) => file = value;

  @observable
  File? fileBackground;

  @action
  void setFileBackground(File? value) {
    fileBackground = value;
  }

}