import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/providers/thought.dart';

class AddThoughtForm extends StatefulWidget {
  final int dayTimestamp;

  const AddThoughtForm({super.key, required this.dayTimestamp});

  @override
  State<AddThoughtForm> createState() => AddThoughtFormState();
}

class AddThoughtFormState extends State<AddThoughtForm> {
  bool _isLoading = false;
  final TextEditingController _content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !_isLoading;
      },
      child: AlertDialog(
        title: const Text("Add Thought"),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            minWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: TextField(
            maxLines: 4,
            autofocus: true,
            controller: _content,
            decoration: const InputDecoration(
              hintText: "What's on your mind?",
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: _isLoading ? Container() : Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              if (_content.text.isEmpty) return;

              setState(() {
                _isLoading = true;
              });

              context.read<ThoughtsProvider>().add(_content.text);
              Navigator.pop(context);
            },
            child: _isLoading
                ? SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Text("Add"),
          ),
        ],
      ),
    );
  }
}

void showAddThoughtDialog({
  required BuildContext context,
  required int dayTimestamp,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AddThoughtForm(dayTimestamp: dayTimestamp);
    },
  );
}
