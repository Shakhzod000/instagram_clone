// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ReactionModel _$$_ReactionModelFromJson(Map<String, dynamic> json) =>
    _$_ReactionModel(
      imageUrl: json['imageUrl'] as String?,
      myUsername: json['myUsername'] as String?,
      postId: json['postId'] as String?,
      reactionId: json['reactionId'] as String?,
      myUid: json['myUid'] as String?,
      userId: json['userId'] as String?,
      myAvatarUrl: json['myAvatarUrl'] as String?,
      reactionPublishDate: json['reactionPublishDate'] as String?,
      reactionTex: json['reactionTex'] as String?,
      isFollowed: json['isFollowed'] as bool? ?? false,
      storyUrl: json['storyUrl'] as String?,
      storyId: json['storyId'] as String?,
    );

Map<String, dynamic> _$$_ReactionModelToJson(_$_ReactionModel instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'myUsername': instance.myUsername,
      'postId': instance.postId,
      'reactionId': instance.reactionId,
      'myUid': instance.myUid,
      'userId': instance.userId,
      'myAvatarUrl': instance.myAvatarUrl,
      'reactionPublishDate': instance.reactionPublishDate,
      'reactionTex': instance.reactionTex,
      'isFollowed': instance.isFollowed,
      'storyUrl': instance.storyUrl,
      'storyId': instance.storyId,
    };
