import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInfoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Information"),
        backgroundColor: Colors.green.shade600,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: getUserData(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserInfoField(
                    label: 'Name:',
                    value: userData['name'],
                  ),
                  UserInfoField(
                    label: 'Address:',
                    value: userData['address'],
                  ),
                  UserInfoField(
                    label: 'Date of Birth:',
                    value: userData['dob'],
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error retrieving user data'),
            );
          } else {
            return Center(
              child: Container(),
            );
          }
        },
      ),
    );
  }

  Future<DocumentSnapshot> getUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final usersCollection = FirebaseFirestore.instance.collection('Users');
    return await usersCollection.doc(currentUser!.uid).get();
  }
}

class UserInfoField extends StatelessWidget {
  final String label;
  final String value;

  const UserInfoField({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          children: [
            TextSpan(text: label),
            TextSpan(
              text: value,
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
