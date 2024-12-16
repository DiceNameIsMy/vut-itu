import 'dart:math'; // For generating random like counts
import 'package:flutter/material.dart';

class PostsTab extends StatefulWidget {

  final VoidCallback deletePost; 

  PostsTab({required this.deletePost});

  @override
  PostsTabState createState() => PostsTabState();
}

class PostsTabState extends State<PostsTab> {
  // Mock list of posts (replace with dynamic data)
  static List<Map<String, dynamic>> posts = [
  {
    'image': 'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0',
    'description': 'A peaceful sunset by the lake 🌅',
    'likeCount': Random().nextInt(100) + 1,
  },
  {
    'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
    'description': 'Walking along the beach 🏖️',
    'likeCount': Random().nextInt(100) + 1,
  },
  {
    'image': 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
    'description': 'Coffee is life ☕ #MondayMood',
    'likeCount': Random().nextInt(100) + 1,
  },
  {
    'image': 'https://images.unsplash.com/photo-1517602302552-471fe67acf66',
    'description': 'Exploring the snowy mountains ❄️🏔️',
    'likeCount': Random().nextInt(100) + 1,
  },
  {
    'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
    'description': 'Lazy Sunday mornings 🌸🌞',
    'likeCount': Random().nextInt(100) + 1,
  },
  {
    'image': 'https://images.unsplash.com/photo-1522199755839-a2bacb67c546',
    'description': 'Sipping tea and watching the sunrise ☀️🍵',
    'likeCount': Random().nextInt(100) + 1,
  },
  {
    'image': 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f',
    'description': 'A scenic drive through the mountains 🚗🌄',
    'likeCount': Random().nextInt(100) + 1,
  },
  {
    'image': 'https://images.unsplash.com/photo-1551963831-b3b1ca40c98e',
    'description': 'Freshly brewed coffee and croissants 🥐☕',
    'likeCount': Random().nextInt(100) + 1,
  },
];

  void deletePost(int index) {
    setState(() {
      posts.removeAt(index); // Remove user from the list
    });
    widget.deletePost(); // Call the parent callback
  }

  // Track liked posts using a Set of indexes
  Set<int> likedPosts = {};

  // Toggle like status and update like count
  void toggleLike(int index) {
    setState(() {
      if (likedPosts.contains(index)) {
        likedPosts.remove(index);
        posts[index]['likeCount']--; // Decrement like count
      } else {
        likedPosts.add(index);
        posts[index]['likeCount']++; // Increment like count
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];

        return GestureDetector(
          onTap: () {
            // Show post in a dialog with delete button
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Post Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                post['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 10),

                            // Post Description
                            Text(
                              post['description']!,
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    likedPosts.contains(index)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: likedPosts.contains(index) ? Colors.red : Colors.grey,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (likedPosts.contains(index)) {
                                        likedPosts.remove(index);
                                        posts[index]['likeCount']--; // Decrement
                                      } else {
                                        likedPosts.add(index);
                                        posts[index]['likeCount']++; // Increment
                                      }
                                    });
                                  },
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '${posts[index]['likeCount']} likes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            // Delete Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                                deletePost(index); // Delete the post
                              },
                              child: Text('Delete Post'),
                            ),

                            // Close Button
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                              },
                              child: Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(post['image']!),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }
}