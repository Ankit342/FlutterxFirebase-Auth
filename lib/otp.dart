import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/phone.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';

class MyOtp extends StatefulWidget {
  const MyOtp({Key? key}) : super(key: key);

  @override
  State<MyOtp> createState() => _MyOtpState();
}

class _MyOtpState extends State<MyOtp> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoaded = false;
  final _formKey = GlobalKey<FormState>();
  final SmsAutoFill smsAutoFill = SmsAutoFill();
  late String verificationCode;

  @override
  void initState() {
    _listenOtp();
    super.initState();
  }

  void _listenOtp() async {
    await smsAutoFill.listenForCode;
    print("OTP Listen is called");
  }

  @override
  void dispose() {
    smsAutoFill.unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img1.png',
                  width: 150,
                  height: 150,
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Phone Verification",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "We need to register your phone before getting started!",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Pinput(
                  length: 6,
                  onChanged: (value) {
                    verificationCode = value;
                  },
                  showCursor: true,
                  onCompleted: (pin) => print(pin),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      print("OTP: $verificationCode");
                      setState(() {
                        isLoaded = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        try {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                            verificationId: MyPhone.verificationId,
                            smsCode: verificationCode,
                          );

                          setState(() {
                            isLoaded = false;
                          });

                          final UserCredential userCredential =
                              await auth.signInWithCredential(credential);
                          final User? user = userCredential.user;

                          if (user != null) {
                            // Check if user data exists for the current user
                            final currentUser =
                                FirebaseAuth.instance.currentUser;
                            final usersCollection =
                                FirebaseFirestore.instance.collection('Users');
                            final userData = await usersCollection
                                .doc(currentUser!.uid)
                                .get();

                            if (userData.exists) {
                              // User data exists, navigate to UserInfoView page
                              Navigator.pushReplacementNamed(
                                  context, 'showData');
                            } else {
                              // User data doesn't exist, navigate to Register page
                              Navigator.pushReplacementNamed(
                                  context, 'register');
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Wrong OTP! Please enter again"),
                              ),
                            );
                            print("Wrong OTP");
                          }
                        } catch (e) {
                          setState(() {
                            isLoaded = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Wrong OTP! Please enter again"),
                            ),
                          );
                          print("Wrong OTP");
                        }
                      }
                    },
                    child: Text("Verify Phone Number"),
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          'phone',
                          (route) => false,
                        );
                      },
                      child: Text(
                        "Edit Phone Number?",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
