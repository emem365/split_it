import 'package:flutter/material.dart';

class STransaction {
  String id;
  String title;
  double amount;
  String date;
  List members;
  String description;

  STransaction({
    this.id,
    this.title,
    this.amount,
    this.date,
    this.members,
    this.description,
  });

  factory STransaction.empty() => STransaction();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
      'members': members,
      'description': description,
    };
  }

  STransaction.fromMapObject(
      {@required String id, @required Map<String, dynamic> data}) {
    this.id = id;
    this.title = data['title'] ?? "";
    this.amount = data['amount'] ?? 0.0;
    this.date = data['date'] ?? "";
    this.members = data['members'] ?? [];
    this.description = data['description'] ?? "";
  }
}
