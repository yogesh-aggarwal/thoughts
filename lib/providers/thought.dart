import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:thoughts/core/firebase.dart';
import 'package:thoughts/types/misc.dart';
import 'package:thoughts/types/thought.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';

class ThoughtsProvider with ChangeNotifier {
  List<Thought>? thoughts;
  SortOrder sortOrder = SortOrder.descending;

  int? _listeningForDay;
  StreamSubscription? _listener;

  listenForDay(int dayTimestamp) {
    if (_listeningForDay == dayTimestamp) return;

    thoughts = null;
    if (_listener != null) notifyListeners();

    _listener?.cancel();
    _listeningForDay = dayTimestamp;

    _listener = thoughtsColl
        .where("dayCreated", isEqualTo: dayTimestamp)
        .where("createdBy", isEqualTo: auth.currentUser!.uid)
        .snapshots()
        .listen(
      (event) {
        final sortOrder = this.sortOrder == SortOrder.ascending ? 1 : -1;
        if (event.docs.isEmpty) {
          thoughts = [];
        } else {
          thoughts = event.docs
              .map((e) => Thought.fromMap(e.data()))
              .sortedBy((a, b) => (a.dateCreated - b.dateCreated) * sortOrder)
              .toList();
        }

        notifyListeners();
      },
    );
  }

  changeSortOrder(SortOrder sortOrder) {
    this.sortOrder = sortOrder;
    if (thoughts != null) {
      thoughts = thoughts!.reversed.toList();
    }
    notifyListeners();
  }

  add(String content) async {
    final thought = Thought(
      id: Uuid().v4(),
      content: content,
      createdBy: auth.currentUser!.uid,
      dayCreated: _listeningForDay!,
      dateCreated: DateTime.now().millisecondsSinceEpoch,
    );

    await thoughtsColl.doc(thought.id).set(thought.toMap());
  }

  delete(String id) async {
    await thoughtsColl.doc(id).delete();
  }
}
