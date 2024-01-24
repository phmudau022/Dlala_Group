import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  UserProfilePage({required this.userData});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late String invitationStatus;

  @override
  void initState() {
    super.initState();
    invitationStatus = 'Not Invited'; // Initialize with a default value
    _loadInvitationStatus();
  }

  Future<void> _loadInvitationStatus() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Query Firestore to check the invitation status
        QuerySnapshot invitedDocs = await FirebaseFirestore.instance
            .collection('invited')
            .where('senderEmail', isEqualTo: currentUser.email)
            .where('receiverEmail', isEqualTo: widget.userData['email'])
            .get();

        if (invitedDocs.docs.isNotEmpty) {
          setState(() {
            invitationStatus = 'Invited';
          });
        }
      }
    } catch (e) {
      print('Error loading invitation status: $e');
    }
  }

  Future<void> _sendFriendInvitation(BuildContext context, String userEmail) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && currentUser.email != userEmail) {
        // Save the invitation to Firestore "invited" collection
        await FirebaseFirestore.instance.collection('invited').add({
          'senderEmail': currentUser.email,
          'receiverEmail': userEmail,
          'status': 'Invited',
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {
          invitationStatus = 'Invited';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Friend invitation sent to $userEmail.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You cannot send a friend request to yourself.'),
          ),
        );
      }
    } catch (e) {
      print('Error sending friend invitation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String userEmail = widget.userData['email'];

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Name: ${widget.userData['firstName']} ${widget.userData['lastName']}'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Email: $userEmail'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Invitation Status: $invitationStatus'),
          ),
          ElevatedButton(
            onPressed: invitationStatus == 'Invited'
                ? null
                : () async {
                    await _sendFriendInvitation(context, userEmail);
                  },
            child: Text('Send Invitation'),
          ),
        ],
      ),
    );
  }
}
