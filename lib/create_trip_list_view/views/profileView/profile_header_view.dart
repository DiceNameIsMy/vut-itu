import 'package:flutter/material.dart';
import 'package:vut_itu/create_trip_list_view/views/profileView/edit_profile_screen.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String bio;
  final String profileImage;
  final Function(String, String, String) onEdit;
  final VoidCallback onAddPost; // Callback for creating a new post

  ProfileHeader({
    required this.name,
    required this.bio,
    required this.profileImage,
    required this.onEdit,
    required this.onAddPost,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(profileImage),
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
          ElevatedButton(
            onPressed: () async {
              // Navigate to EditProfileScreen and await the updated data
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    name: name,
                    bio: bio,
                    profileImage: profileImage,
                  ),
                ),
              );

              // If the result is valid, call the onEdit callback to update the profile
              if (result != null && result is Map<String, String>) {
                onEdit(result['name']!, result['bio']!, result['profileImage']!);
              }
            },
            child: Text('Edit Profile'),
          ),
          ElevatedButton(
                onPressed: onAddPost, // Call the function to add a new post
                child: Text('Add Post'),
          ),
          ],
          )
        ],
      ),
    );
  }
}
