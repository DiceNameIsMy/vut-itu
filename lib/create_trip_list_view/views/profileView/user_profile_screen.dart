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

  static List<Map<String, dynamic>> users = [
    {
      'name': 'John Doe',
      'profileImage': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      'posts': [
        {
          'image': 'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0',
          'description': 'John’s Post 1',
          'likeCount': 23,
        },
        {
          'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
          'description': 'John’s Post 2',
          'likeCount': 12,
        },
      ],
    },
    {
      'name': 'Jane Smith',
      'profileImage': 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
      'posts': [
        {
          'image': 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f',
          'description': 'Jane’s Post 1',
          'likeCount': 45,
        },
        {
          'image': 'https://images.unsplash.com/photo-1540202404-29c40f06d157',
          'description': 'Jane’s Post 2',
          'likeCount': 33,
        },
      ],
    },
  ];

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
                  UserPostsTab(userPosts: users), // Pass user-specific postsrPostsTab(postCount: 12),  // User-specific posts
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
