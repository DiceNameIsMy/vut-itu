import 'package:flutter/material.dart';

class UserFollowingTab extends StatelessWidget {
  final String name;

  UserFollowingTab({required this.name});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3, // Mock number of following
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.greenAccent,
            child: Text('Fo$index'),
          ),
          title: Text('$name\'s Following $index'),
          subtitle: Text("Tech Enthusiast"),
        );
      },
    );
  }
}
