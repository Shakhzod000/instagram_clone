// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserModel _$$_UserModelFromJson(Map<String, dynamic> json) => _$_UserModel(
      username: json['username'] as String?,
      email: json['email'] as String?,
      bio: json['bio'] as String?,
      followers: json['followers'] as List<dynamic>?,
      following: json['following'] as List<dynamic>?,
      uid: json['uid'] as String?,
      photoAvatarUrl: json['photoAvatarUrl'] as String?,
    );

Map<String, dynamic> _$$_UserModelToJson(_$_UserModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'bio': instance.bio,
      'followers': instance.followers,
      'following': instance.following,
      'uid': instance.uid,
      'photoAvatarUrl': instance.photoAvatarUrl,
    };
