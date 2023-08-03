import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp();
}

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;

final usersColl = firestore.collection('Users');
final thoughtsColl = firestore.collection('Thoughts');
