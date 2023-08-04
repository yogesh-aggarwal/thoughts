import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/providers/time_track.dart';
import 'package:thoughts/types/time_tracking.dart';

class ViewTimeTrackDialog extends StatelessWidget {
  final TimeTrack timeTrack;

  const ViewTimeTrackDialog({super.key, required this.timeTrack});

  @override
  Widget build(BuildContext context) {
    final DateTime thoughtAt =
        DateTime.fromMillisecondsSinceEpoch(timeTrack.dateCreated);

    return AlertDialog(
      title: Text(
        "thought at ${thoughtAt.hour}:${thoughtAt.minute}",
        style: Theme.of(context).textTheme.bodySmall,
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
                timeTrack.name,
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
            print(timeTrack.id);
            context.read<TimeTracksProvider>().delete(timeTrack.id);
            Navigator.pop(context);
          },
          child: Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

showViewTimeTrackDialog(BuildContext context, TimeTrack timeTrack) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ViewTimeTrackDialog(timeTrack: timeTrack);
    },
  );
}
