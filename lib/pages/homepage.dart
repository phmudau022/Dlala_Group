import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('socials'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            if (user != null)
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                ),
                child: Text(
                  "Signed in as: ${user?.email!}",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ListTile(
              title: Text(user != null ? 'Sign Out' : 'Sign In'),
              onTap: () async {
                if (user != null) {
                  await FirebaseAuth.instance.signOut();
                } else {
                  // You can implement sign-in logic here.
                  // For testing purposes, you can navigate to the login page.
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => YourLoginPage(),
                  //   ),
                  // );
                }
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to SUPERRIDES!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Connecting People, Creating Memories',
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Additional widgets can be added here as needed.
            Text(
              'Recent Rides',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            // Add a list of recent rides here

            SizedBox(height: 20),
            Text(
              'Featured Destinations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            // Add a list of featured destinations here

            SizedBox(height: 20),
            Text(
              'User Recommendations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            // Add a list of user recommendations here
          ],
        ),
      ),
    );
  }
}
