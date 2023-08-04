import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:thoughts/core/firebase.dart';
import 'package:thoughts/types/thought.dart';
import 'package:uuid/uuid.dart';

class ThoughtsProvider with ChangeNotifier {
  List<Thought>? thoughts;

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
        if (event.docs.isEmpty) {
          thoughts = [];
        } else {
          thoughts = event.docs.map((e) => Thought.fromMap(e.data())).toList();
        }

        notifyListeners();
      },
    );
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
}
