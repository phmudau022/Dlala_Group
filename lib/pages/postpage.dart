import 'package:flutter/material.dart';

class CreatePostCard extends StatelessWidget {
  final Function(String) onPost;

  CreatePostCard({required this.onPost});

  void showInput(BuildContext context) {
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
    return InkWell(
      onTap: () {
        showInput(context);
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
    );
  }
}
