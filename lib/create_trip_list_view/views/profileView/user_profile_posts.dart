import 'package:flutter/material.dart';

class UserPostsTab extends StatefulWidget {
  final List<Map<String, dynamic>> userPosts; // Posts for the selected user

  UserPostsTab({required this.userPosts});

  @override
  _UserPostsTabState createState() => _UserPostsTabState();
}

class _UserPostsTabState extends State<UserPostsTab> {
  // Track liked posts for this user
  Set<int> likedPosts = {};

  // Toggle like status
  void toggleLike(int index) {
    setState(() {
      if (likedPosts.contains(index)) {
        likedPosts.remove(index);
        widget.userPosts[index]['likeCount']--; // Decrement like count
      } else {
        likedPosts.add(index);
        widget.userPosts[index]['likeCount']++; // Increment like count
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
      itemCount: widget.userPosts.length,
      itemBuilder: (context, index) {
        final post = widget.userPosts[index];

        return GestureDetector(
          onTap: () {
            // Show post in a dialog
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      final isLiked = likedPosts.contains(index);

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
                                post['posts'][0]['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 10),

                            // Post Description
                            Text(
                              post['posts'][0]['description']!,
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),

                            // Like Button and Counter
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isLiked ? Colors.red : Colors.grey,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (isLiked) {
                                        likedPosts.remove(index);
                                        post['posts'][0]['likeCount']--; // Decrement
                                      } else {
                                        likedPosts.add(index);
                                        post['posts'][0]['likeCount']++; // Increment
                                      }
                                    });
                                  },
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '${post['posts'][0]['likeCount']} likes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
                image: NetworkImage(post['posts'][0]['image']!),
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
