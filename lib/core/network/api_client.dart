import 'package:dio/dio.dart';
import 'package:fitness_app/features/exercises/data/models/exercise_model.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://exercisedb.p.rapidapi.com',
    headers: {
      'x-rapidapi-key': '59f6597dd6msh9286b1746afd865p12bbbcjsn1c54ae44b90e',
      'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
    },
  ));

  /// جلب كل التمارين
  Future<List<ExerciseModel>> getExercises() async {
    final response = await _dio.get('/exercises');
    print('API Response: ${response.data.length} items');

    final exercises = (response.data as List)
        .map((e) => ExerciseModel.fromJson(e))
        .toList();

    return exercises;
  }

  /// URL مباشر للـ GIF لكل تمرين
  String getGifUrl(String exerciseId, {int resolution = 360}) {
    return 'https://exercisedb.p.rapidapi.com/image?exerciseId=$exerciseId&resolution=$resolution&rapidapi-key=59f6597dd6msh9286b1746afd865p12bbbcjsn1c54ae44b90e';
  }

  /// جلب قائمة أجزاء الجسم للفلاتر
  Future<List<String>> getBodyParts() async {
    final response = await _dio.get('/exercises/bodyPartList');
    return List<String>.from(response.data);
  }
}
