import 'package:flutter/material.dart';
import 'package:vut_itu/create_trip_list_view/views/profileView/user_profile_screen.dart';

class FollowersTab extends StatefulWidget {

  final VoidCallback onUnfollow; 

  FollowersTab({required this.onUnfollow});


  @override
  FollowersTabState createState() => FollowersTabState();
}

class FollowersTabState extends State<FollowersTab> {
  // Initial list of followers (mock data) 
  void unfollow(int index) {
    setState(() {
      followers.removeAt(index); // Remove user from the list
    });
    widget.onUnfollow(); // Call the parent callback
  }

  static List<Map<String, String>> followers = [
    {"name": "John Doe", "bio": "Flutter Developer", "profileImage": "https://via.placeholder.com/150"},
    {"name": "Jane Smith", "bio": "Tech Enthusiast", "profileImage": "https://via.placeholder.com/150"},
    {"name": "Alice Johnson", "bio": "UI/UX Designer", "profileImage": "https://via.placeholder.com/150"},
    {"name": "Chris Evans", "bio": "DevOps Engineer", "profileImage": "https://via.placeholder.com/150"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: followers.length,
      itemBuilder: (context, index) {
        final user = followers[index];
        return ListTile(
          leading: GestureDetector(
            onTap: () {
              // Navigate to User Profile on avatar tap
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserProfileScreen(
                    name: user['name']!,
                    bio: user['bio']!,
                    profileImage: user['profileImage']!,
                  ),
                ),
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(user['profileImage']!),
            ),
          ),
          title: GestureDetector(
            onTap: () {
              // Navigate to User Profile on name tap
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserProfileScreen(
                    name: user['name']!,
                    bio: user['bio']!,
                    profileImage: user['profileImage']!,
                  ),
                ),
              );
            },
            child: Text(user['name']!),
          ),
          subtitle: Text(user['bio']!),
          trailing: ElevatedButton(
            onPressed: () => unfollow(index),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Unfollow'),
          ),
        );
      },
    );
  }
}

