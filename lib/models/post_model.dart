
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'post_model.g.dart';
part 'post_model.freezed.dart';

@freezed
class PostModel with _$PostModel{
  @JsonSerializable()
  factory PostModel({
    String? description,
    String? username,
    String? userAvatar,
    String? datePublished,
    List? like,
    int? comments,
    String? imageUrl,
    String? postId,
    String? userId,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, Object?>json) =>
  _$PostModelFromJson(json);


  factory PostModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>?>? dataSnapshot){
    final data = dataSnapshot!.data();
   
   return PostModel(
    description: data!['description'],
    username: data['username'],
userAvatar: data['userAvatar'],
imageUrl: data['imageUrl'],
postId: data['postId'],
userId: data['userId'],
like: data['like'],
comments: data['comments'],
datePublished: data['datePublished']
   );
   
    }


}

