import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:split_it/login/OtpVerificationPage.dart';
import 'package:split_it/dashboard/dashboard.dart';

class OTPService {
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> signInWithCred(AuthCredential authCred, BuildContext context,
      Function stopLoading) async {
    try {
      UserCredential authResult = await auth.signInWithCredential(authCred);
      if (authResult.user != null) {
        print("uid:::  " +
            authResult.user.uid +
            " logged in successfully (inside verification complete callback)");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));

        return;
      } else {
        print("else part!!!!");
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
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => HomePage(), Route route=>false));
        // await signInWithCred(authCred, context);
      },
      verificationFailed: (FirebaseAuthException exception) {
        stopLoading();
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   duration: Duration(seconds: 2),
        //   content: Text("Oops! Unexpected Error occured. Please Try again."),
        // ));
        print("exception ${exception.code} \nmessage\n${exception.message}");
      },
      codeSent: (String verificationID, [int i]) {
        // print("code sent callback replace: true");
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
