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
          List<String> friendRequests = requestsData['requests'] != null
              ? List<String>.from(requestsData['requests'])
              : [];

          if (friendRequests.isEmpty) {
            return Center(child: Text('No friend requests.'));
          }

          return ListView.builder(
            itemCount: friendRequests.length,
            itemBuilder: (context, index) {
              String userEmail = friendRequests[index];

              return ListTile(
                title: Text('Friend Request from $userEmail'),
                // Add a button to accept the friend request
                trailing: ElevatedButton(
                  onPressed: () {
                    // Check if the request is not from the logged-in user
                    if (currentUser != null && currentUser.email != userEmail) {
                      _acceptFriendRequest(context, userEmail);
                    } else {
                      // Show a message that the user cannot accept their own request
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

  void _acceptFriendRequest(BuildContext context, String userEmail) {
    // Here, you can implement the logic to accept the friend request.
    // This may involve updating the user's friend list and removing the request.

    // For demonstration, you can print a message.
    print('Friend request from $userEmail accepted.');

    // Show a notification or perform any other desired action.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Friend request from $userEmail accepted.'),
      ),
    );
  }
}
