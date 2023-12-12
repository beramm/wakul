import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController {
  final isLoading = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamRole() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection("users").doc(uid).snapshots();
  }

  // Stream<String> streamUserName() async* {
  //   String uid = auth.currentUser!.uid;

  //   yield* firestore.collection("users").doc(uid).snapshots().map(
  //     (snapshot) {
  //       final data = snapshot.data() as Map<String, dynamic>;
  //       final name = data["name"] as String;

  //       return name;
  //     },
  //   );
  // }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUsername() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection("users").doc(uid).snapshots();
  }
}
