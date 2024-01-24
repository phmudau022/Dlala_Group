import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dlala_group/pages/search_page.dart';
import 'package:dlala_group/pages/view_userpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  List<String> posts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Container(
          margin: EdgeInsets.only(right: 10),
          child: Text(
            'Dlala Group',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          SizedBox(width: 16),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                user != null
                    ? 'Signed In as:\n${user?.email!}'
                    : 'Not Signed In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            if (user != null)
              ListTile(
                title: Text('View Friends List'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewUsersPage()),
                  );
                },
              ),
            ListTile(
              title: Text(user != null ? 'Sign Out' : 'Sign In'),
              onTap: () async {
                if (user == null) {
                  
                } else {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          CreatePostCard(
            onPost: (post) {
              setState(() {
                posts.add(post);
              });
            },
          ),
          for (int i = 0; i < posts.length; i++)
            PostWidget(posts[i]),
          CardOption(
            title: 'Update Friends',
            icon: Icons.people,
            onTap: () {
              // Implement action for updating friends
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: SearchPageDelegate());
                },
              ),
              InkWell(
                onTap: () {
                  
                  // CreatePostCard.showInput(context);
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
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  // Implement the action when the settings icon is tapped
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreatePostCard extends StatelessWidget {
  final Function(String) onPost;

  CreatePostCard({required this.onPost});

  static void showInput(BuildContext context, Function(String) onPost) {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Post'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Type your post here...'),
            maxLines: 3,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Post'),
              onPressed: () {
                String post = _controller.text.trim();
                if (post.isNotEmpty) {
                  onPost(post);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CardOption(
      title: 'Create Post',
      icon: Icons.edit,
      onTap: () {
        showInput(context, onPost);
      },
    );
  }
}

class PostWidget extends StatelessWidget {
  final String post;

  PostWidget(this.post);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.grey,
        ),
        ListTile(
          title: Text(post),
        ),
        Container(
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}

class CardOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const CardOption({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}

class SearchPageDelegate extends SearchDelegate {
  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); 
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }
}
