import 'package:flutter/material.dart';
import 'package:vut_itu/create_trip_list_view/views/profileView/user_profile_following.dart';
import 'package:vut_itu/create_trip_list_view/views/profileView/user_profile_followers.dart';
import 'package:vut_itu/create_trip_list_view/views/profileView/user_profile_posts.dart';
import 'package:vut_itu/create_trip_list_view/views/profileView/follow_button.dart';
import 'package:vut_itu/create_trip_list_view/views/profileView/chat_screen.dart';

class UserProfileScreen extends StatelessWidget {
  final String name;
  final String bio;
  final String profileImage;

  UserProfileScreen({
    required this.name,
    required this.bio,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(name), // Display user's name in the app bar
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Profile Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profileImage), // User's profile picture
                  ),
                  SizedBox(height: 10),
                  Text(
                    name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    bio,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    ],
                  ),
                ],
              ),
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FollowButton(),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        userName: name, // Pass user's name
                        userProfileImage: profileImage, // Pass user's profile image
                      ),
                    ),
                  );
                },
                child: Text('Message'),
              ),
            ],
            ),
            // Tabs for Posts, Followers, Following
            TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: "Posts"),
                Tab(text: "Followers"),
                Tab(text: "Following"),
              ],
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                children: [
                  UserPostsTab(postCount: 12),  // User-specific posts
                  UserFollowersTab(name: name),       // Mock followers for this user
                  UserFollowingTab(name: name),       // Mock following for this user
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
