import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:split_it/constants.dart';
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
      body: SafeArea(
        child: Stack(
          children: [
            IgnorePointer(
              ignoring: loading,
              child: Opacity(
                opacity: loading ? 0.5 : 1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/login.jpg',
                            height: 150,
                          ),
                          Text(
                            "Welcome",
                            style: TextStyle(
                                letterSpacing: 1.2,
                                fontSize: 32,
                                // color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Sign in",
                            style: TextStyle(
                                letterSpacing: 1,
                                fontSize: 20,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 40),
                          PhoneTextField(phoneNumber: phoneNumber),
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
                                    backgroundColor: kBlue2,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 18)),
                                child: Container(
                                  width: double.infinity,
                                  child: Center(
                                    child: Text(
                                      "GET OTP",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
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

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    Key key,
    @required this.phoneNumber,
  }) : super(key: key);

  final TextEditingController phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextFormField(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.phone,
      controller: phoneNumber,
      style:
          TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.grey.shade400)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          width: 2,
          color: kBlue2,
        )),
        labelText: "Phone Number",
        labelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: kBlue2,
        ),
        hintText: "Phone Number",
        hintStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade400,
        ),
        prefixIcon: Icon(
          Icons.phone,
          color: Colors.grey.shade700,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value.length != 10) {
          return "Invalid phone number";
        }
        return null;
      },
    ));
  }
}
