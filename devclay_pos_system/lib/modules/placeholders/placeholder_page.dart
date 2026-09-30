import 'package:flutter/material.dart';

import '../../widgets/empty_state.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: title,
      message: message,
      icon: icon,
    );
  }
}
