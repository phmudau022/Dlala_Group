import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String _searchResult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Users'),
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
              onPressed: _isLoading ? null : () => _searchUser(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Search'),
                  if (_isLoading)
                    SizedBox(
                      width: 10,
                    ),
                  if (_isLoading)
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (_searchResult.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfilePage(email: _searchResult),
                    ),
                  );
                },
                child: Text(
                  _searchResult,
                  style: TextStyle(
                    color: _searchResult.contains('found') ? Colors.deepPurple : Colors.red,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchUser(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _searchResult = '';
    });

    try {
      String searchEmail = _searchController.text.trim();
      bool userExists = await _checkUserExists(searchEmail);

      setState(() {
        _isLoading = false;
        if (userExists) {
          _searchResult = 'User found: $searchEmail';
        } else {
          _searchResult = 'User not found';
        }
      });
    } catch (e) {
      print('Error searching user: $e');
      setState(() {
        _isLoading = false;
        _searchResult = 'Error searching user';
      });
    }
  }

  Future<bool> _checkUserExists(String email) async {
    try {
      QuerySnapshot users = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return users.docs.isNotEmpty;
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }
}

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => SearchPageState();
}

class UserProfilePage extends StatelessWidget {
  final String email;

  UserProfilePage({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'User Profile',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
