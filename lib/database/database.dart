import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:split_it/models/contact.dart';
import 'package:split_it/models/userData.dart';
import 'package:intl/intl.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

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
    print(user.uid);
    if (userDoc.exists) {
      return true;
    }
    return false;
  }

  Future<void> createNewDocument({@required String name}) async {
    User user = auth.currentUser;
    await userCollection.doc(user.uid).set({
      'name': name,
      'createdAt': DateFormat.yMMMd().format(DateTime.now()),
      'phoneNumber': user.phoneNumber ?? "",
    });
  }

  Future<List<UserContact>> addContacts() async {
    if (await Permission.contacts.request().isGranted) {
      User user = auth.currentUser;
      var query = await userCollection.get();
      Set<UserContact> userContacts = {};
      Iterable<Contact> contacts =
          await ContactsService.getContacts(withThumbnails: false);
      contacts.forEach((element) {
        String displayName = element.displayName;
        element.phones.forEach((element) async {
          String phoneNumber = element.value.replaceAll(RegExp(r"\s+"), "");
          phoneNumber = phoneNumber.substring(
              (phoneNumber.length - 10).clamp(0, phoneNumber.length));
          phoneNumber = '+91' + phoneNumber;

          if (phoneNumber.length == 13) {
            try {
              var doc = query.docs
                  .where((element) =>
                      element.data()['phoneNumber'] == phoneNumber &&
                      element.data()['phoneNumber'] != user.phoneNumber)
                  .first;

              if (doc != null) {
                String contactId = doc.id;
                final userContact =
                    UserContact(displayName, phoneNumber, contactId);
                userContacts.add(userContact);
              }
            } catch (e) {}
          }
        });
      });
      print('----->${userContacts.length}');

      userContacts.forEach((element) {
        print(element);
      });
      return userContacts.toList();
      // await userCollection.doc(user.uid).update({
      //   // 'contacts':contacts
      // });
    }
// You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses =
        await [Permission.contacts].request();
    print(statuses[Permission.contacts]);
    return null;
  }
}
