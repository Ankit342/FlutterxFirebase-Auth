import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/userinfo_view.dart';

//import 'package:flutter_application_3/showData.dart';

import 'otp.dart';
import 'phone.dart';
import 'register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.green),
    initialRoute: 'phone',
    debugShowCheckedModeBanner: false,
    routes: {
      'phone': (context) => MyPhone(),
      'verify': (context) => MyOtp(),
      'register': (context) => UserInfoForm(),
      'showData': (context) => UserInfoView()
    },
  ));
}
