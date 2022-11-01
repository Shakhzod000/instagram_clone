

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'reaction_model.g.dart';
part 'reaction_model.freezed.dart';

@freezed
class ReactionModel with _$ReactionModel{
  const factory ReactionModel({
    @JsonKey(name: 'imageUrl') String? imageUrl,
    @JsonKey(name: 'myUsername') String? myUsername,
    @JsonKey(name: 'postId') String? postId,
    @JsonKey(name: 'reactionId') String? reactionId,
    @JsonKey(name: 'myUid') String? myUid,
    @JsonKey(name: 'userId') String? userId,
    @JsonKey(name: 'myAvatarUrl') String? myAvatarUrl,
    @JsonKey(name: 'reactionPublishDate') String? reactionPublishDate,
    @JsonKey(name: 'reactionTex') String? reactionTex,
    @JsonKey(name: 'isFollowed') @Default(false) bool? isFollowed,
    @JsonKey(name: 'storyUrl') String? storyUrl,
    @JsonKey(name: 'storyId') String? storyId
  }) = _ReactionModel;

  factory ReactionModel.fromJson(Map<String, Object?> json) =>
   _$ReactionModelFromJson(json);


   factory ReactionModel.emty(){
    return ReactionModel.fromJson({});
   }

   factory ReactionModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String,dynamic>> snapshot
   ){
    final data = snapshot.data();
    return ReactionModel(
      imageUrl: data!['imageUrl'],
      postId: data['postId'],
        myUid: data['myUid'],
      myUsername: data['myUsername'],
      userId: data['userId'],
      reactionId: data['reactionId'],
      myAvatarUrl: data['myAvatarUrl'],
      reactionPublishDate: data['reactionPublishDate'],
      reactionTex: data['reactionTex'],
      isFollowed: data['isFollowed'],
      storyUrl: data['storyUrl'],
      storyId: data['storyId'],
    );
   }
}