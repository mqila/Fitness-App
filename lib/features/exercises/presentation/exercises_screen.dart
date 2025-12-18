import 'package:fitness_app/features/exercises/presentation/exercise_details_screen.dart';
import 'package:fitness_app/features/favorites/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'search_filter_provider.dart';

// مؤقتاً، Provider لاسم المستخدم
final userNameProvider = Provider<String>((ref) => "Mohamed");

class ExercisesScreen extends ConsumerWidget {
     String? userName;
   ExercisesScreen({super.key,this.userName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(filteredExercisesProvider);
    final bodyPartsAsync = ref.watch(bodyPartsProvider);
    final userName = ref.watch(userNameProvider); // جلب اسم المستخدم

    final isLoading = exercisesAsync.isLoading || bodyPartsAsync.isLoading;
    final hasError = exercisesAsync.hasError || bodyPartsAsync.hasError;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError) {
      return const Scaffold(
        body: Center(child: Text('Error loading exercises')),
      );
    }

    final exercises = exercisesAsync.value!;
    final bodyParts = bodyPartsAsync.value!;
    final selectedFilter = ref.watch(bodyPartFilterProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Exercises',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black45,
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: Container(
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🟢 بطاقة الترحيب
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.waving_hand, color: Colors.blue, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Welcome, $userName! Ready for your workout today?',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 🔍 Search + Filter
            TextField(
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: selectedFilter == null ? Colors.grey : Colors.blue,
                  ),
                  onPressed: () {
                    _showFilterBottomSheet(context, ref, bodyParts);
                  },
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),

            const SizedBox(height: 16),

            /// Exercises List
            Expanded(
              child: exercises.isEmpty
                  ? const Center(child: Text('No exercises available'))
                  : ListView.separated(
                      itemCount: exercises.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final e = exercises[index];
                        final isFav = ref.watch(favoritesProvider).any((f) => f.id == e.id);

                        return Material(
                          elevation: 3,
                          shadowColor: Colors.black26,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ExerciseDetailsScreen(exercise: e, heroTag: e.exerciseId),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  /// Hero icon
                                  Hero(
                                    tag: e.exerciseId,
                                    child: Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.fitness_center,
                                        color: Colors.blue,
                                        size: 30,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Target: ${e.target}',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                          ),
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

                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors.grey,
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

  /// Bottom Sheet للفلترة
  void _showFilterBottomSheet(BuildContext context, WidgetRef ref, List<String> bodyParts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final selected = ref.watch(bodyPartFilterProvider);

        return FractionallySizedBox(
          heightFactor: 0.6,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter by body part',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  ListTile(
                    title: const Text('All'),
                    trailing: selected == null ? const Icon(Icons.check, color: Colors.blue) : null,
                    onTap: () {
                      ref.read(bodyPartFilterProvider.notifier).state = null;
                      Navigator.pop(context);
                    },
                  ),

                  ...bodyParts.map(
                    (part) => ListTile(
                      title: Text(part[0].toUpperCase() + part.substring(1)),
                      trailing: selected == part ? const Icon(Icons.check, color: Colors.blue) : null,
                      onTap: () {
                        ref.read(bodyPartFilterProvider.notifier).state = part;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
