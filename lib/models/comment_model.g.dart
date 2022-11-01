// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CommentModel _$$_CommentModelFromJson(Map<String, dynamic> json) =>
    _$_CommentModel(
      profilePic: json['profilePic'] as String?,
      datePublished: json['datePublished'] as String?,
      text: json['text'] as String?,
      commentId: json['commentId'] as String?,
      uid: json['uid'] as String?,
      username: json['username'] as String?,
    );

Map<String, dynamic> _$$_CommentModelToJson(_$_CommentModel instance) =>
    <String, dynamic>{
      'profilePic': instance.profilePic,
      'datePublished': instance.datePublished,
      'text': instance.text,
      'commentId': instance.commentId,
      'uid': instance.uid,
      'username': instance.username,
    };
