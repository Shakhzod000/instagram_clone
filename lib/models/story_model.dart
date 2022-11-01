
import 'package:freezed_annotation/freezed_annotation.dart';
part 'story_model.g.dart';
part 'story_model.freezed.dart';


@freezed
class StoryModel with _$StoryModel{
  factory StoryModel({
     String? storyImage,
    String? datePublished,
    String? userId,
    String? description,
    String? profileAvatar,
    List? likes,
    String? fcmToken,
    List? watchList,
    String? username,
    String? storyId,
    }) = _StoryModel;

    factory StoryModel.fromJson(Map<String, dynamic> json) =>
    _$StoryModelFromJson(json);
}