import 'package:flutter/material.dart';
import 'package:thoughts/core/firebase.dart';
import 'package:thoughts/types/user.dart';

class UserProvider with ChangeNotifier {
  User? user;
  bool isListening = false;

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

  void initAuth() {
    auth.authStateChanges().listen((user) {
      print(user);
      if (user == null) {
        this.user = null;
        notifyListeners();
      } else {
        listen(user.uid);
      }
    });
  }
}
