import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/providers/thought.dart';
import 'package:thoughts/providers/user.dart';

class ThoughtsScreen extends StatefulWidget {
  const ThoughtsScreen({super.key});

  @override
  State<ThoughtsScreen> createState() => _ThoughtsScreenState();
}

class _ThoughtsScreenState extends State<ThoughtsScreen> {
  int selectedDayTimestamp = 1685039400000;

  @override
  void initState() {
    super.initState();

    context.read<ThoughtsProvider>().listenForDay(selectedDayTimestamp);
  }

  @override
  Widget build(BuildContext context) {
    final thoughts = context.watch<ThoughtsProvider>().thoughts;

    if (thoughts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (thoughts.isEmpty) {
      return const Center(child: Text("No thoughts yet"));
    }

    return ListView(
      children: thoughts.map((thought) {
        return ListTile(
          onTap: () {},
          title: Text(
            "This is a thought",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          leading: Icon(Icons.lightbulb_outline),
          subtitle: Text(
            "thought at 10:30",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        );
      }).toList(),
    );
  }
}
