import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:split_it/login/otp.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNumber = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading;

  @override
  void initState() {
    super.initState();
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            IgnorePointer(
              ignoring: loading,
              child: Opacity(
                opacity: loading ? 0.5 : 1,
                child: Container(
                  child: Form(
                    key: formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                                letterSpacing: 1.2,
                                fontSize: 32,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 40),
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 25),
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.phone,
                                controller: phoneNumber,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.grey.shade400)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.blue.withOpacity(0.5),
                                  )),
                                  labelText: "Phone Number",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade500,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Colors.grey.shade700,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                validator: (value) {
                                  if (value.length != 10) {
                                    return "Invalid phone number";
                                  }
                                  return null;
                                },
                              )),
                          SizedBox(height: 30),
                          Builder(
                            builder: (context) => TextButton(
                                onPressed: () async {
                                  if (formKey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    await OTPService().sendOTP(
                                        "+91${phoneNumber.text}",
                                        context,
                                        false, stopLoading: () {
                                      setState(() {
                                        loading = false;
                                      });
                                    });
                                  } else
                                    print("Error!!!!!");
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: Text(
                                  "Send OTP",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
            loading ? Center(child: CircularProgressIndicator()) : Container()
          ],
        ),
      ),
    );
  }
}
