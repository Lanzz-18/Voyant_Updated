import 'package:flutter/material.dart';
import 'package:voyant/screens/home/views/root_screen.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RootScreen();
  }

  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Map(),
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
  }*/
}
