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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              padding: EdgeInsets.all(16),
              children: [
                Container(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.green.shade600,
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                if (userData['name'] != null)
                  UserInfoField(
                    label: 'Name:',
                    value: userData['name'],
                  ),
                if (userData['address'] != null)
                  UserInfoField(
                    label: 'Address:',
                    value: userData['address'],
                  ),
                if (userData['dob'] != null)
                  UserInfoField(
                    label: 'Date of Birth:',
                    value: userData['dob'],
                  ),
              ],
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
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
          ),
          Divider(height: 20),
        ],
      ),
    );
  }
}
