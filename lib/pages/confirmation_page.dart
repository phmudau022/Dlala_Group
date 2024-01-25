import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfirmationPage extends StatefulWidget {
  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Invitations'),
        backgroundColor: Colors.deepPurple, // Set app bar background color
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('invited').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final invitations = snapshot.data!.docs;

          if (invitations.isEmpty) {
            return Center(child: Text('No invitations available.'));
          }

          return ListView.builder(
            itemCount: invitations.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> invitationData = invitations[index].data() as Map<String, dynamic>;
              String receiverEmail = invitationData['receiverEmail'];
              bool isConfirmed = invitationData['status'] == 'Confirmed';

              return Card(
                margin: EdgeInsets.all(8),
                color: Colors.deepPurple[100], // Set card color
                child: ListTile(
                  title: Text('Invitation to: $receiverEmail'),
                  subtitle: Text('Status: ${invitationData['status']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isConfirmed
                          ? Icon(Icons.check, color: Colors.green) // Show tick icon if confirmed
                          : ElevatedButton(
                              onPressed: () {
                                _confirmInvitation(invitations[index].id, receiverEmail);
                              },
                              child: Text('Confirm'),
                            ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _resetInvitation(invitations[index].id, receiverEmail);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmInvitation(String invitationId, String receiverEmail) async {
    try {
      await FirebaseFirestore.instance.collection('friends').add({
        'user1Email': FirebaseAuth.instance.currentUser?.email,
        'user2Email': receiverEmail,
      });

      await FirebaseFirestore.instance
          .collection('invited')
          .doc(invitationId)
          .update({'status': 'Confirmed'});

    } catch (e) {
      print('Error confirming invitation: $e');
    }
  }

  Future<void> _resetInvitation(String invitationId, String receiverEmail) async {
    try {
      await FirebaseFirestore.instance.collection('friends').where('user2Email', isEqualTo: receiverEmail).get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      await FirebaseFirestore.instance
          .collection('invited')
          .doc(invitationId)
          .update({'status': 'Confirm'});
    } catch (e) {
      print('Error resetting invitation: $e');
    }
  }
}
