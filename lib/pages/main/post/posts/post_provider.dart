

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:instagram_clone_app1/models/post_model.dart';
import 'package:instagram_clone_app1/service/fire/fire_src.dart';

class PostProvider with ChangeNotifier{
  late int? _commetLength = 0;

  void getCommentLength({
    required String? postId
  }) async{
    try{
     _commetLength = await Firesrc.getCommentLength(postId: postId);
    }catch(e){
      log(e.toString());
    }
  }

  void addLike({required PostModel? post}) async{
      await Firesrc.addLike(mypost: post);
      notifyListeners();
  }

   void removeLike({required PostModel? post}) async{
      await Firesrc.removeLikes(myPost: post);
      notifyListeners();
  }

  int? get getFullCommentlength => _commetLength;
}