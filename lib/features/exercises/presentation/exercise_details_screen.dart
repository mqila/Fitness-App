import 'package:fitness_app/core/network/api_client.dart';
import 'package:fitness_app/features/exercises/data/models/exercise_model.dart';
import 'package:fitness_app/features/favorites/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciseDetailsScreen extends ConsumerWidget {
  final ExerciseModel exercise;
  final ApiClient apiClient = ApiClient();
  final String? heroTag; 

  ExerciseDetailsScreen({super.key, required this.exercise, this.heroTag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gifUrl = apiClient.getGifUrl(exercise.exerciseId);
    final isFav = ref.watch(favoritesProvider).any((f) => f.id == exercise.id);
    final tag = heroTag ?? exercise.id;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// 🖼 SliverAppBar مع Hero للصورة
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: tag,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      gifUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.broken_image, size: 80, color: Colors.grey),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Card تحت الصورة يحتوي على اسم التمرين وأيقونة المفضلة
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            sliver: SliverToBoxAdapter(
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: ListTile(
                  title: Text(
                    exercise.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      final notifier = ref.read(favoritesProvider.notifier);
                      if (isFav) {
                        notifier.removeFavorite(exercise);
                      } else {
                        notifier.addFavorite(exercise);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),

          /// Card واحد للنصوص (Target, Body Part, Equipment)
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow('Target', exercise.target),
                      const SizedBox(height: 8),
                      _infoRow('Body Part', exercise.bodyPart),
                      const SizedBox(height: 8),
                      _infoRow('Equipment', exercise.equipment),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// نصوص تعليمات أو وصف التمرين
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Exercise Instructions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Vestibulum vehicula ex eu lacus convallis, at dapibus purus convallis',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
