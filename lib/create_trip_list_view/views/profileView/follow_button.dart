import 'package:flutter/material.dart';

class FollowButton extends StatefulWidget {
  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool isFollowing = false; // Initial state (not following)

  void toggleFollow() {
    setState(() {
      isFollowing = !isFollowing; // Toggle follow state
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: toggleFollow, // Toggle follow/unfollow on press
      style: ElevatedButton.styleFrom(
        backgroundColor: !isFollowing ? Colors.grey : Colors.blue, // Color changes dynamically
      ),
      child: Text(isFollowing ? 'Follow' : 'Unfollow'), // Text changes dynamically
    );
  }
}
