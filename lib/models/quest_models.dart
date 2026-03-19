import 'package:freezed_annotation/freezed_annotation.dart';

part 'quest_models.freezed.dart';
part 'quest_models.g.dart';

@freezed
class MainQuest with _$MainQuest {
  const factory MainQuest({
    required String id,
    required String title,
    required String description,
    required String location,
    required bool isMainQuest,
    required int questOrder,
    required List<String> prerequisites,
    required String estimatedDuration,
    required int totalSubQuests,
    required bool isAvailable,
    required StartingLocation startingLocation,
    required QuestRewards rewards,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MainQuest;

  factory MainQuest.fromJson(Map<String, dynamic> json) => _$MainQuestFromJson(json);
}