import 'package:vut_itu/create_trip_list_view/views/profileView/profile_header_view.dart';
import 'package:vut_itu/create_trip_list_view/views/profileView/posts_grid.dart';
import 'package:vut_itu/create_trip_list_view/views/profileView/profile_tabs_view.dart';
import 'package:vut_itu/create_trip_list_view/views/profileView/followers_tab_view.dart';
import 'package:vut_itu/create_trip_list_view/views/profileView/following_tab_view.dart';
import 'package:vut_itu/create_trip_list_view/views/profileView/new_post_screen.dart';
import 'package:flutter/material.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
    // Initial data
  String name = "Cool Name";
  String bio = "Flutter Developer | Tech Enthusiast";
  String profileImage = "https://images.prismic.io/doge/67848221-1f53-47ee-9585-85fe997fa4bc_scale_1200.webp?auto=compress,format&rect=239,0,721,721&w=456&h=456";

  void updateProfile(String newName, String newBio, String newProfileImage) {
    setState(() {
      name = newName;
      bio = newBio;
      profileImage = newProfileImage;
    });
  }
  // Mock data for dynamic values
  int postCount = PostsTabState.posts.length;
  int followersCount = FollowersTabState.followers.length;
  int followingCount = FollowingTabState.following.length;

    // Callback to decrement following count
  void decrementFollowingCount() {
    setState(() {
      if (followingCount > 0) {
        followingCount--;
      }
    });
  }

    void decrementPostsCount() {
    setState(() {
      if (postCount > 0) {
        postCount--;
      }
    });
  }

    void decrementFollowersCount() {
    setState(() {
      if (followersCount > 0) {
        followersCount--;
      }
    });
  }

    void addNewPost() async {
    final newPost = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewPostScreen(),
      ),
    );

    if (newPost != null && newPost is Map<String, String>) {
      setState(() {
        PostsTabState.posts.insert(0, {
          'image': newPost['image']!,
          'description': newPost['description']!,
          'likeCount': 0, // New posts start with 0 likes
        });
      });
    }
  }

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
            onAddPost: addNewPost,
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
                  PostsTab(deletePost: decrementPostsCount),         // Pass post count to PostsTab
                  FollowersTab(
                    onUnfollow: decrementFollowersCount, // Pass callback to update following count
                  ),    // Updated FollowersTab with unfollow functionality
                  FollowingTab(
                    onUnfollow: decrementFollowingCount, // Pass callback to update following count
                  ),    // Updated FollowingTab with unfollow functionality
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

