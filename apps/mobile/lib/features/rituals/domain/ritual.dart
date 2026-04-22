import 'package:freezed_annotation/freezed_annotation.dart';

part 'ritual.freezed.dart';
part 'ritual.g.dart';

enum RitualCategory {
  festival,
  lifecycle,
  monthly,
  seasonal;

  String get displayName => switch (this) {
        RitualCategory.festival => 'Festival',
        RitualCategory.lifecycle => 'Lifecycle',
        RitualCategory.monthly => 'Monthly',
        RitualCategory.seasonal => 'Seasonal',
      };
}

enum RitualTradition {
  north,
  south,
  east,
  west,
  jain,
  sikh,
  buddhist;

  String get displayName => switch (this) {
        RitualTradition.north => 'North',
        RitualTradition.south => 'South',
        RitualTradition.east => 'East',
        RitualTradition.west => 'West',
        RitualTradition.jain => 'Jain',
        RitualTradition.sikh => 'Sikh',
        RitualTradition.buddhist => 'Buddhist',
      };
}

@freezed
class Ritual with _$Ritual {
  const factory Ritual({
    required String id,
    required String name,
    String? nameHi,
    required RitualCategory category,
    required RitualTradition tradition,
    @Default(false) bool isLocked,
    String? imageUrl,
    String? description,
    int? durationMinutes,
  }) = _Ritual;

  factory Ritual.fromJson(Map<String, dynamic> json) => _$RitualFromJson(json);
}
