import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatelessWidget {
  final Map<String, dynamic> userData;

  UserProfilePage({required this.userData});

  @override
  Widget build(BuildContext context) {
    String userEmail = userData['email'];

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Name: ${userData['firstName']} ${userData['lastName']}'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Email: $userEmail'),
          ),
          ElevatedButton(
            onPressed: () {
              
              User? currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser != null && currentUser.email == userEmail) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You cannot send a friend request to yourself.'),
                  ),
                );
              } else {
                _sendFriendInvitation(context, userEmail);
              }
            },
            child: Text('Send Invitation'),
          ),
        ],
      ),
    );
  }

  void _sendFriendInvitation(BuildContext context, String userEmail) {
    
    print('Friend invitation sent to $userEmail.');

    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Friend invitation sent to $userEmail.'),
      ),
    );
  }
}
