import 'package:flutter/material.dart';

class UserFollowersTab extends StatelessWidget {
  final String name;

  UserFollowersTab({required this.name});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Mock number of followers
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text('F$index'),
          ),
          title: Text('$name\'s Follower $index'),
          subtitle: Text("Flutter Enthusiast"),
        );
      },
    );
  }
}
