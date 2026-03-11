import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voyant/blocs/authentication_bloc/authentication_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    const bgColor = Color.fromARGB(255, 0, 0, 1);
    
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text('User Profile'),
        centerTitle: true,
      ),
      body: SafeArea( //ensures that padding will be applied to avoid UI from overlaping with device notches or other features 
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const HeadSection(),
            const SizedBox(height: 24),
            const Stats(),
          ],
        ),
      ),
    );
  }
}

