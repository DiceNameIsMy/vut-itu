import 'package:flutter/material.dart';

class UserPostsTab extends StatelessWidget {
  final int postCount;

  UserPostsTab({required this.postCount});

  @override
  Widget build(BuildContext context) {
    return postCount == 0
        ? Center(child: Text("No posts yet!"))
        : GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: postCount,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.grey[300],
                child: Center(
                  child: Text('Post ${index + 1}'), // Mock posts
                ),
              );
            },
          );
  }
}
