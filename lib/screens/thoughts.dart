import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/dialogs/view_thought.dart';
import 'package:thoughts/providers/thought.dart';
import 'package:thoughts/types/thought.dart';

class ThoughtTile extends StatelessWidget {
  final Thought thought;

  const ThoughtTile({super.key, required this.thought});

  @override
  Widget build(BuildContext context) {
    final DateTime thoughtAt =
        DateTime.fromMillisecondsSinceEpoch(thought.dateCreated);

    return Card(
      elevation: 1,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          showViewThoughtDialog(context, thought);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(thought.content),
              SizedBox(height: 12),
              Text(
                "thought at ${thoughtAt.hour}:${thoughtAt.minute}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThoughtsScreen extends StatefulWidget {
  const ThoughtsScreen({super.key});

  @override
  State<ThoughtsScreen> createState() => _ThoughtsScreenState();
}

class _ThoughtsScreenState extends State<ThoughtsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final thoughts = context.watch<ThoughtsProvider>().thoughts;

    if (thoughts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (thoughts.isEmpty) {
      return const Center(child: Text("No thoughts yet."));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      children:
          thoughts.map((thought) => ThoughtTile(thought: thought)).toList(),
    );
  }
}
