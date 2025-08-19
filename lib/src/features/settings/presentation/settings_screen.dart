import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/firebase_auth_repository.dart';

// TODO: Add settings screen

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              ref.read(authRepositoryProvider).signOut();
            },
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}