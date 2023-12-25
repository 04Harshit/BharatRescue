import 'package:flutter/material.dart';

class ComplaintTile extends StatelessWidget {
  final bool resolved;
  final String title;
  final String date;
  const ComplaintTile({
    super.key,
    required this.resolved,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: (resolved)
          ? const Icon(
              Icons.check_circle,
              color: Colors.green,
            )
          : const Icon(
              Icons.error,
              color: Colors.red,
            ),
      title: Text(title),
      subtitle: Text(date),
    );
  }
}
