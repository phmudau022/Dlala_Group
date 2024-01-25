import 'package:dlala_group/pages/chatRoompage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
        backgroundColor: Colors.deepPurple, // Set app bar background color
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('friends').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final friends = snapshot.data!.docs;

          if (friends.isEmpty) {
            return Center(child: Text('No friends available.'));
          }

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> friendData = friends[index].data() as Map<String, dynamic>;
              String user1Email = friendData['user1Email'];
              String user2Email = friendData['user2Email'];

              // Determine the current user's email
              String currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';

              // Choose the other user's email to display
              String friendEmail = (currentUserEmail == user1Email) ? user2Email : user1Email;

              return Card(
                margin: EdgeInsets.all(8),
                color: Colors.deepPurple[100], // Set card color
                child: ListTile(
                  title: Text('Friendship with: $friendEmail'),
                  onTap: () {
                    // Navigate to the chat room with the friend
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoomPage(friendEmail),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
