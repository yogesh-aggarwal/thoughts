import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:thoughts/core/firebase.dart';

class ThoughtsProvider with ChangeNotifier {
  List<String>? thoughts;

  int? _listeningForDay;
  StreamSubscription? _listener;

  listenForDay(int dayTimestamp) {
    if (_listeningForDay == dayTimestamp) return;

    thoughts = null;
    // notifyListeners();

    _listener?.cancel();
    _listeningForDay = dayTimestamp;

    _listener = thoughtsColl
        .where("dayCreated", isEqualTo: dayTimestamp)
        .where("createdBy", isEqualTo: auth.currentUser!.uid)
        .snapshots()
        .listen(
      (event) {
        print(event.docs);

        notifyListeners();
      },
    );
  }
}
