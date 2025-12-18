import 'package:fitness_app/core/network/providers.dart';
import 'package:fitness_app/features/exercises/data/models/exercise_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final exercisesProvider =
    FutureProvider<List<ExerciseModel>>((ref) async {
  final api = ref.read(apiClientProvider);
  return api.getExercises();
});