import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/core/firebase.dart';
import 'package:thoughts/providers/thought.dart';
import 'package:thoughts/types/user.dart';

class UserProvider with ChangeNotifier {
  User? user;
  bool isListening = false;

  StreamSubscription? _listener;

  void listen(String id) {
    if (isListening) return;
    isListening = true;

    usersColl.doc(id).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        user = User.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  initAuth({required Function onUserAvailable}) {
    _listener?.cancel();
    _listener = auth.authStateChanges().listen((user) async {
      if (user == null) {
        this.user = null;
        notifyListeners();
      } else {
        this.user = User(
          id: user.uid,
          name: user.displayName ?? "Anonymous",
          dp: user.photoURL ?? "https://picsum.photos/200",
          email: user.email ?? "",
          phoneNumber: user.phoneNumber,
        );
        notifyListeners();
        onUserAvailable();

        await usersColl.doc(user.uid).set(this.user!.toMap());
        listen(user.uid);
      }
    });
  }
}
