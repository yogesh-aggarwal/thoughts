import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/providers/thought.dart';
import 'package:thoughts/providers/time_track.dart';

class AddTimeTrackForm extends StatefulWidget {
  final int dayTimestamp;

  const AddTimeTrackForm({super.key, required this.dayTimestamp});

  @override
  State<AddTimeTrackForm> createState() => AddTimeTrackFormState();
}

class AddTimeTrackFormState extends State<AddTimeTrackForm> {
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
        content: TextField(
          maxLines: 4,
          autofocus: true,
          controller: _content,
          decoration: const InputDecoration(
            hintText: "What's on your mind?",
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

              context.read<TimeTracksProvider>().add(_content.text);
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

void showAddTimeTrackDialog({
  required BuildContext context,
  required int dayTimestamp,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AddTimeTrackForm(dayTimestamp: dayTimestamp);
    },
  );
}
