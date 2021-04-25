import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_it/database/database.dart';
import 'package:split_it/models/transaction.dart';
import 'package:split_it/models/userData.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserData userDoc = Provider.of<UserData>(context);
    return Container(
      padding: EdgeInsets.all(15),
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          StreamBuilder<List<STransaction>>(
              stream: DatabaseService().getTransactions(userDoc.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                final transactions = snapshot.data;
                return ListView(
                  children: [
                    ...transactions.map((sTransaction) => ExpansionTile(
                          title: Text(sTransaction.title),
                          subtitle: Text(sTransaction.amount.toString()),
                          children: [
                            Column(
                              children: [
                                Text(sTransaction.description),
                                ...sTransaction.members.map(
                                  (memberId) {
                                    // if (userDoc.friends != null) {
                                    //   // userDoc.friends.forEach((contact) {
                                    //   //   print('-->${contact['contactId']}');
                                    //   // });
                                    //   var name = userDoc.friends
                                    //       .where((contact) =>
                                    //           contact['contactId'] == member)
                                    //       .toList();
                                    //   print('-->${name.first}');
                                    //   return Text('name');
                                    // } else
                                    return Text(memberId);
                                  },
                                )
                              ],
                            )
                          ],
                        ))
                  ],
                );
              }),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
