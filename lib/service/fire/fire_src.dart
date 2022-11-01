
import 'dart:developer';
import 'dart:io';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone_app1/models/comment_model.dart';
import 'package:instagram_clone_app1/models/post_model.dart';
import 'package:instagram_clone_app1/models/reaction_model.dart';
import 'package:instagram_clone_app1/models/story_model.dart';
import 'package:instagram_clone_app1/models/user_model.dart';
import 'package:instagram_clone_app1/service/auth_service.dart';
import 'package:uuid/uuid.dart';

class Firesrc{

static  final _firebaseauth = FirebaseAuth.instance;
 static final _firebaseStorage = FirebaseStorage.instance;
 static final _firebaseFirestore = FirebaseFirestore.instance;


/// upload avatar to storage
  static Future<String?> uploadFileToStorage({
    required String fileName, required File? file})async{
      try{
        var ref = _firebaseStorage.ref();
        var newRef = ref.child('postImage').child(fileName);
        UploadTask? task = newRef.putFile(file!);
      await task;
      return newRef.getDownloadURL();
      }catch (e){
        log(e.toString());
      }
      return null;
    }
    ///remove avatar to storage
     static Future<bool?> removeFileFromStorage({required String url})async{
      try{
    var ref = _firebaseStorage.refFromURL(url);
    await ref.delete();
    return true;
      }catch(e){
        log(e.toString());
      }
      return null;
     }

    static Future<bool?> uploadPost ({
      required PostModel? post, required File? imageFile}) async{
        try{
          String? postId = const Uuid().v1();
          UserModel?  user = await AuthSrc.getCurrentuser;
          String? uploadImageUrl = await uploadFileToStorage(
            fileName: postId + imageFile!.path.split('/').last, file: imageFile);
            PostModel newPost = post!.copyWith(
             postId: postId,
             userId: user!.uid,
             username: user.username,
             like: [],
             comments: 0,
             userAvatar: user.photoAvatarUrl,
             imageUrl: uploadImageUrl,
             datePublished: DateTime.now().toString()
            );
            await _firebaseFirestore.collection('posts').doc(postId).set(newPost.toJson());
            PostModel? resultPost = PostModel.fromDocumentSnapshot(
              await _firebaseFirestore.collection('posts').doc(postId).get());
             bool? isPublished = resultPost.postId != null;
             return isPublished;

        } on FirebaseException catch(e){
          log(e.toString());
        }
        return null;
      }


      // add Like
   static Future<bool?> addLike({required PostModel? mypost}) async{
  try{
     final currentUser =  _firebaseauth.currentUser!.uid;
     DocumentSnapshot<Map<String, dynamic>> myDocument =
     await _firebaseFirestore
     .collection('posts')
     .doc(mypost!.postId).get();
     if(!(myDocument.data()!['like'] as List).contains(currentUser)){
      _firebaseFirestore.collection('posts').doc(mypost.postId).update({
        'like': FieldValue.arrayUnion([currentUser]),
      }
      );
      return true;
     }
     return true;

  } on FirebaseException catch(e){
    log(e.toString());
  }
  return null;
 }


 ///is liked
  static  bool? isLiked ({required PostModel? myPost}) {
    try{
    final currentUser =  _firebaseauth.currentUser!.uid;
    if(myPost!.like!.contains(currentUser)){
      return true;
    }
    return false;
  
    }on FirebaseException catch(e){
      log(e.toString());
    }
    return null;
  }

  ///removeLikes
   
  static Future<bool?> removeLikes({required PostModel? myPost})async{
    try{
      final currentUser =  _firebaseauth.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> myDocument =
      await _firebaseFirestore
      .collection('posts')
      .doc(myPost!.postId)
      .get();
    if(!(myDocument.data()!['like'] as List).contains(currentUser)){
      _firebaseFirestore.collection('posts').doc(myPost.postId).update({
        'like': FieldValue.arrayRemove([currentUser]),
      }
      );
      return false;
     }
     return false;

    }on FirebaseException catch(e){
      log(e.toString());
    }
   }


 /// FOR COMMENT
  static Future<bool?> postComment(
    {required String? postId, required CommentModel? comment}) async{
      try{  
        final commentId = const Uuid().v1();
        CommentModel? newComment = comment!.copyWith(commentId: commentId);
        await _firebaseFirestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .set(newComment.toJson());
        await _firebaseFirestore
        .collection('posts')
        .doc(postId)
        .update({
          'comments': FieldValue.increment(1),
        });

        CommentModel? requestCommentModel = await getComment();
        if(requestCommentModel!.uid !=null){
          return true;
        }
        return false;
      }on FirebaseException catch(e){
        log(e.toString());
      }
      return null;
    }

   
   static Future<CommentModel?> getComment({String? postId}) async{
    try{
        final commntId = const Uuid().v1();
        DocumentSnapshot<Map<String,dynamic>> commenSnapchot = 
        await _firebaseFirestore
        .collection('comments')
        .doc(commntId)
        .get();
        Map<String, dynamic>? data = commenSnapchot.data();
        if(data !=null){
          return CommentModel.fromJson(data);
        } 
        return CommentModel.fromJson({});
    }on FirebaseException catch(e){
      log(e.toString());
    }
    return null;
   }


   // followers
   static Future<bool?> followUser(
      {required String? followingUserId,
      required String? followedUserId}) async {
    try {
      final userFollowing = await _firebaseFirestore
          .collection('users')
          .doc(followingUserId)
          .get();
      final userFollowed = await _firebaseFirestore
          .collection('users')
          .doc(followedUserId)
          .get();

      bool? isFollowed = false;
      bool? isFollowing = false;
      log(userFollowing.data()!['followers'].toString());
      if (!userFollowing.data()!['followers'].contains(followedUserId)) {
        await _firebaseFirestore
            .collection('users')
            .doc(followingUserId)
            .update({
          'followers': FieldValue.arrayUnion([followedUserId])
        });

        isFollowed = true;
      }

      if (!userFollowed.data()!['following'].contains(followingUserId)) {
        await _firebaseFirestore
            .collection('users')
            .doc(followedUserId)
            .update({
          'following': FieldValue.arrayUnion([followingUserId])
        });
        isFollowing = true;
      }

      return isFollowing && isFollowed;
    } on FirebaseException catch (e) {
      log(e.toString());
    }

    return null;
  }

  static Future<bool?> checkFollowing(
      {required String? followingUserId,
      required String? followedUserId}) async {
    try {
      final userFollowing = await _firebaseFirestore
          .collection('users')
          .doc(followingUserId)
          .get();
      var data = userFollowing.data();

      if (data!['followers']!.contains(followedUserId)) {
        return true;
      }
      return false;
    } on FirebaseException catch (e) {
      log(e.toString());
    }

    return null;
  }

  static Future<bool?> unfollowUser(
      {required String? followingUserId,
      required String? followedUserId}) async {
    try {
      final userFollowing = await _firebaseFirestore
          .collection('users')
          .doc(followingUserId)
          .get();
      final userFollowed = await _firebaseFirestore
          .collection('users')
          .doc(followedUserId)
          .get();

      bool? isFollowRemoved = false;
      bool? isFollowingRemoved = false;
      log(userFollowing.data()!['followers'].toString());
      if (userFollowing.data()!['followers'].contains(followedUserId)) {
        await _firebaseFirestore
            .collection('users')
            .doc(followingUserId)
            .update({
          'followers': FieldValue.arrayRemove([followedUserId])
        });

        isFollowRemoved = true;
      }

      if (userFollowed.data()!['following'].contains(followingUserId)) {
        await _firebaseFirestore
            .collection('users')
            .doc(followedUserId)
            .update({
          'following': FieldValue.arrayRemove([followingUserId])
        });
        isFollowingRemoved = true;
      }

      return isFollowingRemoved && isFollowRemoved;
    } on FirebaseException catch (e) {
      log(e.toString());
    }

    return null;
  }
 


   static Future<int?> getCommentLength ({String? postId})async{
    try{
          QuerySnapshot<Map<String, dynamic>> commentSnapshot = 
          await _firebaseFirestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();
          int? data =commentSnapshot.size;
          return data;
    }on FirebaseException catch(e){
      log(e.toString());
    }
    return null;
   }

   ///add reaction
   static Future<void> addReaction({
    ReactionModel? reactionModel,
   })async{
    try{
      return _firebaseFirestore
      .collection('notification')
      .doc(reactionModel!.userId)
      .collection('reaction')
      .doc(reactionModel.reactionId)
      .set(reactionModel.toJson());
    }on FirebaseException catch(e){
      log(e.toString());
    }
   }


    static Future<void> removeReaction ({
      required String? postUserId, required String? reactionId
    })async{
try{
     return _firebaseFirestore
     .collection('notification')
     .doc(postUserId)
     .collection('reaction')
     .doc(reactionId)
     .delete();
    
}on FirebaseException catch(e){
  log(e.toString());
}
    } 
   

static Future<ReactionModel?> getReaction({
  required String? postUserId, required String? reactionId
})async{
  try{
  final document = await _firebaseFirestore
  .collection('notification')
  .doc(postUserId)
  .collection('reaction')
  .doc(reactionId)
  .get();
  final reaction = ReactionModel.fromDocumentSnapshot(document);
  return reaction;

  }on FirebaseException catch(e){
    log(e.toString());
  }
  return ReactionModel.emty();
}
  
static Future<bool?> uploadStory({
   required StoryModel? story, required 
})



  static FirebaseFirestore get firebaseFirestore => _firebaseFirestore;
}