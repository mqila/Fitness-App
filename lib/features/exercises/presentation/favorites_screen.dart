import 'package:fitness_app/features/favorites/favorites_provider.dart';
import 'package:fitness_app/features/exercises/presentation/exercise_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/core/network/api_client.dart';

// Provider مؤقت لاسم المستخدم
final userNameProvider = Provider<String>((ref) => "Mohamed");

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final apiClient = ApiClient();
    final userName = ref.watch(userNameProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
          
            const SizedBox(height: 16),

            /// قائمة المفضلة
            Expanded(
              child: favorites.isEmpty
                  ? const Center(
                      child: Text(
                        'No favorite exercises yet',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.separated(
                      itemCount: favorites.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (_, index) {
                        final e = favorites[index];
                        final gifUrl = apiClient.getGifUrl(e.exerciseId);
                        final isFav = ref.watch(favoritesProvider).any((f) => f.id == e.id);

                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ExerciseDetailsScreen(
                                    exercise: e,
                                    heroTag: 'fav_${e.id}', // لتجنب التضارب
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  /// GIF مصغر مع Hero
                                  Hero(
                                    tag: 'fav_${e.id}',
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        gifUrl,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return const SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) => const Icon(
                                          Icons.broken_image,
                                          size: 80,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  /// نصوص واسم التمرين
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.name,
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Target: ${e.target}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// أيقونة المفضلة فقط
                                  IconButton(
                                    icon: Icon(
                                      isFav ? Icons.favorite : Icons.favorite_border,
                                      color: isFav ? Colors.red : Colors.grey,
                                    ),
                                    onPressed: () {
                                      final notifier = ref.read(favoritesProvider.notifier);
                                      if (isFav) {
                                        notifier.removeFavorite(e);
                                      } else {
                                        notifier.addFavorite(e);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
