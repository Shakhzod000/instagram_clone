import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.g.dart';
part 'user_model.freezed.dart';
@freezed
class UserModel with _$UserModel{
  @JsonSerializable()
  const factory  UserModel({
    @JsonKey(name: 'username') String? username,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'bio')  String? bio,
    @JsonKey(name: 'followers') List? followers,
    @JsonKey(name: 'following') List? following,
    @JsonKey(name: 'uid') String? uid,
    @JsonKey(name: 'photoAvatarUrl') String? photoAvatarUrl,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?>json) => 
  _$UserModelFromJson(json);


  factory UserModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>?>? dataSnapshot
  ){
    final data = dataSnapshot!.data();

   return UserModel(
      username: data!['username'],
      bio: data['bio'],
      email: data['email'],
      photoAvatarUrl: data['photoAvatarUrl'],
      followers: data['followers'],
      following: data['following'],
      uid: data['uid']
    );
  }
} 