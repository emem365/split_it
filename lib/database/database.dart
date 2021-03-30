import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:split_it/models/userData.dart';

class DatabaseService {
  final String uid;
  FirebaseAuth auth;
  DatabaseService({this.uid}) {
    auth = FirebaseAuth.instance;
  }

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<UserData> getUserDataStream() async* {
    await for (var firebaseUser in auth.authStateChanges()) {
      if (firebaseUser != null) {
        final id = firebaseUser.uid;
        final ref = userCollection.doc(id);
        yield* ref.snapshots().map(
          (snap) {
            if (snap.exists) {
              return UserData(doc: snap.data(), id: snap.id);
            } else {
              return UserData.empty();
            }
          },
        );
      } else {
        yield UserData.empty();
      }
    }
  }

  Future<bool> isUserDocExists() async {
    User user = auth.currentUser;
    DocumentSnapshot userDoc = await userCollection.doc(user.uid).get();
    if (userDoc.exists) {
      return true;
    }
    return false;
  }

  Future<void> createNewDocument() async {
    User user = auth.currentUser;
    DocumentSnapshot userDoc = await userCollection.doc(user.uid).get();
    if (!userDoc.exists) {
      await userCollection.doc(user.uid).set({
        'name': "",
        'email': "",
        'phoneNumber': user.phoneNumber ?? "",
      });
    }
  }
}
