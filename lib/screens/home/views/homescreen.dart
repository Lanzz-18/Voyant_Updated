import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voyant/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:voyant/screens/map/map.dart';
import 'package:voyant/screens/avatar/views/avatar_screen.dart';
import 'package:voyant/screens/classes/views/classScreen.dart';
import 'package:voyant/screens/leaderboard/leaderboard_screen.dart';


class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AvatarScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AvatarScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.school),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ClassScreen(),
                ),
              );
            },
          ),
        ],
        
      ),
      body: Stack(
        children: [
          const Map(),
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: FloatingActionButton(
                heroTag: 'leaderboard_btn',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LeaderboardScreen(),
                    ),
                  );
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.leaderboard, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      // Add a button to go to class selection screen

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Dispatch the logout event
          context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
        },
        label: const Text('Sign Out'),
        icon: const Icon(Icons.logout),
      ),
    );
  }
}