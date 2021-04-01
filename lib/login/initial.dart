import 'package:flutter/material.dart';
import 'package:split_it/constants.dart';
import 'package:split_it/dashboard/dashboard.dart';
import 'package:split_it/database/database.dart';

class InitialDetailPage extends StatefulWidget {
  InitialDetailPage({Key key}) : super(key: key);

  @override
  _InitialDetailPageState createState() => _InitialDetailPageState();
}

class _InitialDetailPageState extends State<InitialDetailPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Name",
                    ),
                    validator: (String s) {
                      if (s.isEmpty) {
                        return "Enter Name";
                      }
                      return null;
                    },
                  ),
                  Center(
                      child: TextButton(
                          onPressed: () => updateDetails(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: kBlue2,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              'Save',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  updateDetails(BuildContext context) async {
    if (formKey.currentState.validate()) {
      await DatabaseService()
          .createNewDocument(name: nameController.text.trim());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    }
  }
}
