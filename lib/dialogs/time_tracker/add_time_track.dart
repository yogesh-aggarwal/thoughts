import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        title: const Text("Add tracker name"),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            minWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: TextField(
            maxLines: 1,
            autofocus: true,
            controller: _content,
            decoration: const InputDecoration(
              hintText: "Your concern name",
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
