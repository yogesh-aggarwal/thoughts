import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/core/date.dart';
import 'package:thoughts/providers/time_track.dart';
import 'package:thoughts/types/time_tracking.dart';

class ViewTimeTrackDialog extends StatelessWidget {
  final TimeTrack timeTrack;

  const ViewTimeTrackDialog({super.key, required this.timeTrack});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            timeTrack.name,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: timeTrack.sessions.isEmpty ||
                          timeTrack.sessions.last.end != null
                      ? Colors.grey.shade400
                      : Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Text(
                timeTrack.sessions.isEmpty ||
                        timeTrack.sessions.last.end != null
                    ? "Inactive"
                    : "Active",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          )
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
          minWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              ...timeTrack.sessions.map((session) {
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Start",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            visualTime(session.start),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "End",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            session.end == null
                                ? "..."
                                : visualTime(session.end!),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: 12),
              Text(
                "Total time: ${visualDuration(timeTrack.duration)}",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        timeTrack.sessions.isNotEmpty && timeTrack.sessions.last.end == null
            ? TextButton(
                onPressed: () {
                  context.read<TimeTracksProvider>().pause(timeTrack.id);
                  Navigator.pop(context);
                },
                child: Text("End"),
              )
            : TextButton(
                onPressed: () {
                  context.read<TimeTracksProvider>().play(timeTrack.id);
                  Navigator.pop(context);
                },
                child: Text("Start"),
              ),
        SizedBox(width: 16),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Close"),
        ),
        TextButton(
          onPressed: () {
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
