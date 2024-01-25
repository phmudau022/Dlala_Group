import 'package:dlala_group/pages/Userprofilepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewUsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Users', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple, // Set app bar background color
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.deepPurple)));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> userData = users[index].data() as Map<String, dynamic>;
              String userEmail = userData['email'];

              return ListTile(
                title: Text('${userData['firstName']} ${userData['lastName']}', style: TextStyle(color: Colors.deepPurple)),
                subtitle: Text('Email: $userEmail', style: TextStyle(color: Colors.deepPurple)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfilePage(userData: userData),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
