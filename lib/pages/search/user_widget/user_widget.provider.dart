import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clone_app1/service/fire/fire_src.dart';

import '../../../service/auth_service.dart';

class UserViewProvider with ChangeNotifier {
  bool? showTabBar = false;
  final ScrollController scrollController = ScrollController();
  int? _postCount = 0;
  bool? _isFollowed = false;
  void setPostCount(int? post) {
    _postCount = post;
    notifyListeners();
  }

  void checkFollowing({required String? userId, required String? myUid}) async {
    try {
      _isFollowed = await Firesrc.checkFollowing(
          followingUserId: userId, followedUserId: myUid);
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  void follow({required String? followingUserId}) async {
    try {
      bool? followed = await Firesrc.followUser(
          followingUserId: followingUserId,
          followedUserId: AuthSrc.firebaseauth.currentUser!.uid);
      if (followed!) {
        log('Follow boldi');
        notifyListeners();
      } else {
        log('Follow bolgan');
        notifyListeners();
      }
    } catch (e, s) {
      log(s.toString());
      log(e.toString());
    }
  }

  void unFollow({required String? userId}) async {
    try {
      bool? followed = await Firesrc.unfollowUser(
          followingUserId: userId,
          followedUserId: AuthSrc.firebaseauth.currentUser!.uid);
      if (followed!) {
        log('UnFollow boldi');
        notifyListeners();
      } else {
        log('UnFollow bolgan');
        notifyListeners();
      }
    } catch (e, s) {
      log(s.toString());
      log(e.toString());
    }
  }

  get postCount => _postCount;
  void onChangeScroll() {
    scrollController.addListener(() {
      if (scrollController.position.pixels.h >= 363) {
        showTabBar = true;
        notifyListeners();
      } else if (scrollController.position.pixels.h < 363) {
        showTabBar = false;
        notifyListeners();
      }
    });
  }

  bool? get isFollowed => _isFollowed;
}