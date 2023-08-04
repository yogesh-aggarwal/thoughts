import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/core/date.dart';
import 'package:thoughts/dialogs/time_tracker/view_time_track.dart';
import 'package:thoughts/providers/time_track.dart';
import 'package:thoughts/types/time_tracking.dart';

class TimeTrackTile extends StatelessWidget {
  final TimeTrack timeTrack;

  const TimeTrackTile({super.key, required this.timeTrack});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          showViewTimeTrackDialog(context, timeTrack);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    timeTrack.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: timeTrack.sessions.isEmpty ||
                              timeTrack.sessions.last.end != null
                          ? Colors.grey.shade400
                          : Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "Duration: ${visualDuration(timeTrack.duration)}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeTrackingScreen extends StatelessWidget {
  const TimeTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timeTracks = context.watch<TimeTracksProvider>().timeTracks;

    if (timeTracks == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (timeTracks.isEmpty) {
      return const Center(child: Text("No timers yet."));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      children: timeTracks
          .map((thought) => TimeTrackTile(timeTrack: thought))
          .toList(),
    );
  }
}
