import 'package:vut_itu/create_trip_list_view/views/profileView/profile_header_view.dart';
import 'package:vut_itu/create_trip_list_view/views/profileView/posts_grid.dart';
import 'package:vut_itu/create_trip_list_view/views/profileView/profile_tabs_view.dart';
import 'package:vut_itu/create_trip_list_view/views/profileView/followers_tab_view.dart';
import 'package:vut_itu/create_trip_list_view/views/profileView/following_tab_view.dart';
import 'package:flutter/material.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
    // Initial data
  String name = "John Doe";
  String bio = "Flutter Developer | Tech Enthusiast";
  String profileImage = "https://via.placeholder.com/150";

  void updateProfile(String newName, String newBio, String newProfileImage) {
    setState(() {
      name = newName;
      bio = newBio;
      profileImage = newProfileImage;
    });
  }
  // Mock data for dynamic values
  final int postCount = 20;
  int followersCount = FollowersTabState.followers.length;
  int followingCount = FollowingTabState.following.length;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Profile Header
            ProfileHeader(
            name: name,
            bio: bio,
            profileImage: profileImage,
            onEdit: (updatedName, updatedBio, updatedProfileImage) {
              // Update profile data dynamically
              updateProfile(updatedName, updatedBio, updatedProfileImage);
            },
          ),

            // Tab Buttons with Values
            TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Posts ($postCount)'),       // Dynamic label for Posts
                Tab(text: 'Followers ($followersCount)'), // Dynamic label for Followers
                Tab(text: 'Following ($followingCount)'), // Dynamic label for Following
              ],
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                children: [
                  PostsTab(postCount: postCount),         // Pass post count to PostsTab
                  FollowersTab(),    // Updated FollowersTab with unfollow functionality
                  FollowingTab(),    // Updated FollowingTab with unfollow functionality
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

