import 'package:flutter/material.dart';
import 'package:vut_itu/create_trip_list_view/views/profileView/user_profile_screen.dart';

class FollowingTab extends StatefulWidget {
  @override
  FollowingTabState createState() => FollowingTabState();
}

class FollowingTabState extends State<FollowingTab> {
  // Mock data for users the profile is following
  static List<Map<String, String>> following = [
    {
      "name": "Eve Carter",
      "bio": "Graphic Designer",
      "profileImage": "https://via.placeholder.com/150"
    },
    {
      "name": "Mike Wilson",
      "bio": "Software Engineer",
      "profileImage": "https://via.placeholder.com/150"
    },
    {
      "name": "Lisa Ray",
      "bio": "Content Creator",
      "profileImage": "https://via.placeholder.com/150"
    },
  ];

  // Method to remove a user from the following list
  void unfollow(int index) {
    setState(() {
      following.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return following.isEmpty
        ? Center(
            child: Text(
              "You're not following anyone!",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : ListView.builder(
            itemCount: following.length,
            itemBuilder: (context, index) {
              final user = following[index];
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
                  onPressed: () => unfollow(index), // Unfollow action
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
