


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'comment_model.g.dart';
part 'comment_model.freezed.dart';

@freezed
class CommentModel with _$CommentModel{
  @JsonSerializable()
  factory CommentModel({
    String? profilePic,
    String? datePublished,
    String? text,
    String? commentId,
    String? uid,
    String? username,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
  _$CommentModelFromJson(json);

  factory CommentModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
      final data = documentSnapshot.data();

      return CommentModel(
        profilePic: data!['profilePic'],
        datePublished: data['datePublished'],
        text: data['text'],
        commentId: data['commentId'],
        uid: data['uid'],
        username: data['username'],
      );
    }
}