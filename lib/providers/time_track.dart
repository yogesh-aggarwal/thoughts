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

  String listenedForUserID = "";

  changeSortOrder(SortOrder sortOrder) {
    this.sortOrder = sortOrder;
    if (timeTracks != null) {
      timeTracks = timeTracks!.reversed.toList();
    }
    notifyListeners();
  }

  listenForDay(int dayTimestamp) {
    if (_listeningForDay == dayTimestamp &&
        auth.currentUser?.uid == listenedForUserID) return;

    final userID = auth.currentUser?.uid;
    if (userID == null) return;

    listenedForUserID = userID;

    timeTracks = null;
    if (_listener != null) notifyListeners();

    _listener?.cancel();
    _listeningForDay = dayTimestamp;

    _listener = timeTracksColl
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

    await timeTracksColl.doc(timeTrack.id).set(timeTrack.toMap());
  }

  delete(String id) async {
    await timeTracksColl.doc(id).delete();
  }

  play(String id) async {
    final userID = auth.currentUser?.uid;
    if (userID == null) return;

    timeTracks ??= [];

    final timeTrack = timeTracks?.firstWhere((e) => e.id == id);
    if (timeTrack == null) return;

    final session = TimeTrackingSession(
      start: DateTime.now().millisecondsSinceEpoch,
      end: null,
    );

    timeTrack.sessions.add(session);

    await timeTracksColl.doc(id).update(timeTrack.toMap());
  }

  pause(String id) async {
    final userID = auth.currentUser?.uid;
    if (userID == null) return;

    timeTracks ??= [];

    final timeTrack = timeTracks?.firstWhere((e) => e.id == id);
    if (timeTrack == null) return;

    timeTrack.sessions.last.end = DateTime.now().millisecondsSinceEpoch;

    await timeTracksColl.doc(id).update(timeTrack.toMap());
  }
}
