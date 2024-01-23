import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dlala_group/pages/search_page.dart';
import 'package:dlala_group/pages/view_userpage.dart';

class HomePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dlala Group'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                ),
                if (user != null)
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                  ),
              ],
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                // Implement the action when the plus sign is tapped
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  user != null ? 'Signed In as: ${user?.email!}' : 'Not Signed In',
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              if (user != null)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewUsersPage()),
                    );
                  },
                  child: Text('View Friends List'),
                ),
              ListTile(
                title: Text(user != null ? 'Sign Out' : 'Sign In'),
                onTap: () async {
                  if (user == null) {
                    // Navigate to the login page if not signed in
                    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  } else {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
