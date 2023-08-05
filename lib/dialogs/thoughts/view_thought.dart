import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/dialogs/core/confirm.dart';
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
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
          minWidth: MediaQuery.of(context).size.width * 0.75,
        ),
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
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // copy to clipboard
                Clipboard.setData(ClipboardData(text: thought.content));
              },
              child: Text("Copy"),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Close"),
                ),
                TextButton(
                  onPressed: () {
                    showConfirmDialog(
                      context: context,
                      message:
                          "Once deleted, this thought cannot be bring back here. Are you absolutely sure about deleting this thought?",
                      onOkay: () {
                        context.read<ThoughtsProvider>().delete(thought.id);
                        Navigator.pop(context);
                      },
                      onCancel: () {},
                      okayButtonName: "Yes",
                      cancelButtonName: "No",
                    );
                  },
                  child: Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
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
