import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:thoughts/core/firebase.dart';
import 'package:thoughts/types/misc.dart';
import 'package:thoughts/types/time_tracking.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';

class TimeTracksProvider with ChangeNotifier {
  List<TimeTrack>? timeTracks;

  SortOrder sortOrder = SortOrder.descending;

  int? _listeningForDay;
  StreamSubscription? _listener;

  changeSortOrder(SortOrder sortOrder) {
    this.sortOrder = sortOrder;
    if (timeTracks != null) {
      timeTracks = timeTracks!.reversed.toList();
    }
    notifyListeners();
  }

  listenForDay(int dayTimestamp) {
    if (_listeningForDay == dayTimestamp) return;

    final userID = auth.currentUser?.uid;
    if (userID == null) return;

    timeTracks = null;
    if (_listener != null) notifyListeners();

    _listener?.cancel();
    _listeningForDay = dayTimestamp;

    _listener = thoughtsColl
        .where("dayCreated", isEqualTo: dayTimestamp)
        .where("createdBy", isEqualTo: userID)
        .snapshots()
        .listen(
      (event) {
        final sortOrder = this.sortOrder == SortOrder.ascending ? 1 : -1;
        if (event.docs.isEmpty) {
          timeTracks = [];
        } else {
          timeTracks = event.docs
              .map((e) => TimeTrack.fromMap(e.data()))
              .sortedBy((a, b) => (a.dateCreated - b.dateCreated) * sortOrder)
              .toList();
        }

        notifyListeners();
      },
    );
  }

  add(String name) async {
    final userID = auth.currentUser?.uid;
    if (userID == null) return;

    final timeTrack = TimeTrack(
      id: Uuid().v4(),
      name: name,
      sessions: [],
      createdBy: userID,
      dayCreated: _listeningForDay!,
      dateCreated: DateTime.now().millisecondsSinceEpoch,
    );

    await timeTracksColl.add(timeTrack.toMap());
  }

  delete(String id) async {
    await timeTracksColl.doc(id).delete();
  }
}
