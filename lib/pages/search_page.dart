import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Lifts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter user email...',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String searchEmail = _searchController.text.trim();
                User? user = await _searchUserByEmail(searchEmail);

                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchResultPage(user: user),
                    ),
                  );
                } else {
                  // User not found, show a message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No user found with email: $searchEmail'),
                    ),
                  );
                }
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }

  Future<User?> _searchUserByEmail(String email) async {
    try {
      // Query Firestore to find a user with the specified email
      QuerySnapshot users = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      // If a user is found, return it
      if (users.docs.isNotEmpty) {
        // Extract user data from the Firestore document
        Map<String, dynamic> userData = users.docs.first.data() as Map<String, dynamic>;

        // Use the extracted email to sign in
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userData['email'],
          password: '123456',
        );

        // Return the user
        return userCredential.user;
      } else {
        return null;
      }
    } catch (e) {
      print('Error searching user: $e');
      return null;
    }
  }
}

class SearchResultPage extends StatelessWidget {
  final User user;

  const SearchResultPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('User Found'),
            subtitle: Text('Email: ${user.email}'),
          ),
        ],
      ),
    );
  }
}
