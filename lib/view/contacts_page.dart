import 'package:flutter/material.dart';
import 'package:split_it/database/database.dart';
import 'package:split_it/models/contact.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage({Key key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseService().addContacts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          List<UserContact> userContacts = snapshot.data;
          return Container(
            padding: EdgeInsets.all(15),
            child: Center(
                child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(milliseconds: 600), () {
                  setState(() {});
                });
                return Future.value(0);
              },
              child: ListView(
                children: [
                  ...userContacts.map((e) => ListTile(
                        leading: Icon(Icons.person),
                        title: Text(e.name),
                        subtitle: Text(e.mobile),
                      )),
                ],
              ),
            )),
          );
        });
  }
}
