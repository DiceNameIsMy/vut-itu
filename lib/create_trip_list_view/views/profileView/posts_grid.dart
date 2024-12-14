import 'package:flutter/material.dart';

class PostsTab extends StatelessWidget {
  final int postCount;

  PostsTab({required this.postCount});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: postCount, // Use the dynamic count
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey[300],
          child: Center(
            child: Text('Post ${index + 1}'), // Placeholder for a post
          ),
        );
      },
    );
  }
}


