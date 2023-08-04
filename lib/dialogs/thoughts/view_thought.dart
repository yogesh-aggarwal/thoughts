import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/providers/thought.dart';
import 'package:thoughts/types/thought.dart';

class ViewThoughtDialog extends StatelessWidget {
  final Thought thought;

  const ViewThoughtDialog({super.key, required this.thought});

  @override
  Widget build(BuildContext context) {
    final DateTime thoughtAt =
        DateTime.fromMillisecondsSinceEpoch(thought.dateCreated);

    return AlertDialog(
      title: Text(
        "thought at ${thoughtAt.hour}:${thoughtAt.minute}",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                thought.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Close"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<ThoughtsProvider>().delete(thought.id);
          },
          child: Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

showViewThoughtDialog(BuildContext context, Thought thought) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ViewThoughtDialog(thought: thought);
    },
  );
}
