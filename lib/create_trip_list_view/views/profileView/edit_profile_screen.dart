import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String bio;
  final String profileImage;

  EditProfileScreen({
    required this.name,
    required this.bio,
    required this.profileImage,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  late TextEditingController profileImageController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current user data
    nameController = TextEditingController(text: widget.name);
    bioController = TextEditingController(text: widget.bio);
    profileImageController = TextEditingController(text: widget.profileImage);
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    profileImageController.dispose();
    super.dispose();
  }

  void saveProfile() {
    // Return updated data to the previous screen
    Navigator.of(context).pop({
      'name': nameController.text,
      'bio': bioController.text,
      'profileImage': profileImageController.text, // Return updated image URL
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: saveProfile, // Save profile changes
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Image (Preview)
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profileImageController.text),
              ),
            ),
            SizedBox(height: 20),

            // Name Input
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Bio Input
            TextField(
              controller: bioController,
              decoration: InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),

            // Profile Image URL Input
            TextField(
              controller: profileImageController,
              decoration: InputDecoration(
                labelText: 'Profile Image URL',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Update the preview when the URL changes
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
