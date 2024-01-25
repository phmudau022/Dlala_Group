import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Requests'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('friend_requests').doc(currentUser!.uid).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final requestsData = snapshot.data!.data() as Map<String, dynamic>;
          List<Map<String, dynamic>> friendRequests = requestsData['requests'] != null
              ? List<Map<String, dynamic>>.from(requestsData['requests'])
              : [];

          if (friendRequests.isEmpty) {
            return Center(child: Text('No friend requests.'));
          }

          return ListView.builder(
            itemCount: friendRequests.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> requestInfo = friendRequests[index];
              String senderEmail = requestInfo['senderEmail'];

              return ListTile(
                title: Text('Friend Request from $senderEmail'),
                trailing: ElevatedButton(
                  onPressed: () {
                    if (currentUser != null && currentUser.email != senderEmail) {
                      _acceptFriendRequest(context, senderEmail);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You cannot accept your own friend request.'),
                        ),
                      );
                    }
                  },
                  child: Text('Accept'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _acceptFriendRequest(BuildContext context, String senderEmail) {
    // Implement your logic to accept the friend request.
    print('Friend request from $senderEmail accepted.');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Friend request from $senderEmail accepted.'),
      ),
    );
  }
}
