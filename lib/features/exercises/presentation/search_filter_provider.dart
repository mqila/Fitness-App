import 'package:fitness_app/core/network/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/exercise_model.dart';
import 'exercises_provider.dart';
import 'search_filter_provider.dart';



final searchQueryProvider = StateProvider<String>((ref) => '');

final bodyPartFilterProvider = StateProvider<String?>((ref) => null);


final bodyPartsProvider = FutureProvider<List<String>>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  return apiClient.getBodyParts()
  ;
});


final filteredExercisesProvider =
    Provider<AsyncValue<List<ExerciseModel>>>((ref) {
  final exercisesAsync = ref.watch(exercisesProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final bodyPart = ref.watch(bodyPartFilterProvider);

  return exercisesAsync.whenData((exercises) {
    return exercises.where((exercise) {
      final matchesSearch =
          exercise.name.toLowerCase().contains(searchQuery);

      final matchesBodyPart = bodyPart == null || exercise.bodyPart == bodyPart;


      return matchesSearch && matchesBodyPart;
    }).toList();
  });

  
});
