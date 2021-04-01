import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:split_it/database/database.dart';
import 'package:split_it/login/OtpVerificationPage.dart';
import 'package:split_it/dashboard/dashboard.dart';
import 'package:split_it/login/initial.dart';

class OTPService {
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> signInWithCred(AuthCredential authCred, BuildContext context,
      Function stopLoading) async {
    try {
      UserCredential authResult = await auth.signInWithCredential(authCred);
      if (authResult.user != null) {
        print("uid :: " + authResult.user.uid + "Logged in successfully");
        bool isDocExists = await DatabaseService().isUserDocExists();
        if (isDocExists) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(),
              ),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => InitialDetailPage(),
              ),
              (route) => false);
        }
      } else {
        print("Else part!!!!");
      }
    } catch (e) {
      print("exception in signinwithcred $e");
      stopLoading();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text("Invalid OTP! Please Try Again"),
      ));
      return;
    }
    return;
  }

  Future sendOTP(
    String phoneNumber,
    BuildContext context,
    bool toReplaceCurrentScreen, {
    Function stopLoading,
  }) async {
    print(phoneNumber);
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 30),
      verificationCompleted: (AuthCredential authCred) async {
        print("Success!!");
      },
      verificationFailed: (FirebaseAuthException exception) {
        stopLoading();
        print("exception ${exception.code} \nmessage\n${exception.message}");
      },
      codeSent: (String verificationID, [int i]) {
        if (stopLoading != null) {
          stopLoading();
        }
        print("after stop loading");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OtpVerification(
                      verID: verificationID,
                      phoneNumber: phoneNumber,
                    )));
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        //do nothing
        print("time out");
      },
    );
  }
}
