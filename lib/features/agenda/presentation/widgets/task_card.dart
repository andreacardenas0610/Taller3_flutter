import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isCompleted;

  const TaskCard({
    Key? key,
    required this.title,
    required this.description,
    required this.isCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: Icon(
          isCompleted ? Icons.check_circle : Icons.pending,
          color: isCompleted ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}