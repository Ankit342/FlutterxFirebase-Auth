import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/userinfo_view.dart';
import 'package:intl/intl.dart';

class UserInfoForm extends StatefulWidget {
  const UserInfoForm({Key? key}) : super(key: key);

  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  bool isUserExists = false;

  @override
  void initState() {
    super.initState();
    checkUserExists();
  }

  Future<void> checkUserExists() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final usersCollection = FirebaseFirestore.instance.collection('Users');
    final userDoc = await usersCollection.doc(currentUser!.uid).get();
    if (userDoc.exists) {
      setState(() {
        isUserExists = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("User Register")),
        backgroundColor: Colors.green.shade600,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/img1.png',
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 25,
              ),
              Center(
                child: Text(
                  'Register Page',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _nameController,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Full Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _addressController,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: 'Address',
                          icon: Icon(Icons.home),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _dobController,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          icon: Icon(Icons.calendar_today_rounded),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _dobController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your date of birth';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green.shade600,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Check if user data exists for the current user
                              final currentUser =
                                  FirebaseAuth.instance.currentUser;
                              final usersCollection = FirebaseFirestore.instance
                                  .collection('Users');
                              final userData = await usersCollection
                                  .doc(currentUser!.uid)
                                  .get();

                              if (userData.exists) {
                                // User data exists, navigate to UserInfoView page
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserInfoView()),
                                );
                              } else {
                                // User data doesn't exist, save the form data to Firebase
                                saveUserData(
                                  _nameController.text,
                                  _addressController.text,
                                  _dobController.text,
                                );
                                print("User registered.");
                              }
                            }
                          },
                          child: Text("Register"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveUserData(String name, String address, String dob) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final usersCollection = FirebaseFirestore.instance.collection('Users');
    print('${address}');
    print('${dob}');
    print('${name}');
    await usersCollection.doc(currentUser!.uid).set({
      "address": address,
      "dob": dob,
      "name": name,
    });
  }
}
