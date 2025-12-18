import 'package:fitness_app/features/exercises/data/models/exercise_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<ExerciseModel>>(
  (ref) => FavoritesNotifier(),
);

class FavoritesNotifier extends StateNotifier<List<ExerciseModel>> {
  FavoritesNotifier() : super(Hive.box<ExerciseModel>('favoritesBox').values.toList());

  final Box<ExerciseModel> _box = Hive.box<ExerciseModel>('favoritesBox');

  void addFavorite(ExerciseModel exercise) {
    if (!_box.values.any((e) => e.id == exercise.id)) {
      _box.put(exercise.id, exercise);
      state = _box.values.toList();
    }
  }

  void removeFavorite(ExerciseModel exercise) {
    _box.delete(exercise.id);
    state = _box.values.toList();
  }

  bool isFavorite(String id) {
    return _box.containsKey(id);
  }
}
