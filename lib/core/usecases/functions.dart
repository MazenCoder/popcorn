import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:popcorn/core/usecases/keys.dart';
import 'constants.dart';
import 'dart:async';



void computeOnline() async {
  final uid = auth.currentUser?.uid;
  await FlutterIsolate.spawn(iamOnline, uid);
}

@pragma('vm:entry-point')
Future<void> iamOnline(String? uid) async {
  if (Firebase.apps.isEmpty) await Firebase.initializeApp();
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  int i = 0;
  Timer.periodic(const Duration(seconds: 1), (timer) {
    i++;
    if (i > 57) {
      i = 0;
      if (uid != null) {
        instance.collection(Keys.iamonline).doc(uid).set({
          "timestamp": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    }
  });
}
