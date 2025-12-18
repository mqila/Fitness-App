import 'package:hive/hive.dart';
part 'exercise_model.g.dart';

@HiveType(typeId: 0)
class ExerciseModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String exerciseId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String bodyPart;

  @HiveField(4)
  final String target;

  @HiveField(5)
  final String equipment;

  ExerciseModel({
    required this.id,
    required this.exerciseId,
    required this.name,
    required this.bodyPart,
    required this.target,
    required this.equipment,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'].toString(),
      exerciseId: json['id'].toString(),
      name: json['name'] ?? 'Unknown',
      bodyPart: json['bodyPart'] ?? 'Unknown',
      target: json['target'] ?? 'Unknown',
      equipment: json['equipment'] ?? 'Unknown',
    );
  }
}
