import 'package:flutter/material.dart';
import '../shared/0021_profil.dart';

class KonselorProfilTab extends StatelessWidget {
  const KonselorProfilTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScreen(isKonselor: true);
  }
}