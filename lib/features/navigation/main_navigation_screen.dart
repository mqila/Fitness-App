import 'package:fitness_app/features/exercises/presentation/favorites_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/features/exercises/presentation/exercises_screen.dart';
import 'package:fitness_app/features/settings/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  
  @override
void initState() {
  super.initState();
  _screens = [
    ExercisesScreen(userName: FirebaseAuth.instance.currentUser?.displayName ?? "User"),
    FavoritesScreen(),
    SettingsScreen(),
  ];
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
