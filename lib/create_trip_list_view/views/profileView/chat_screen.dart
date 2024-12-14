import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting time

class ChatScreen extends StatefulWidget {
  final String userName;
  final String userProfileImage;

  ChatScreen({
    required this.userName,
    required this.userProfileImage,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // List of messages (text and timestamp)
  List<Map<String, String>> messages = [];
  TextEditingController messageController = TextEditingController();

  // Send a new message with the current timestamp
  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      setState(() {
        messages.add({
          'text': messageController.text,
          'time': DateFormat('hh:mm a').format(DateTime.now()), // Add timestamp
        });
      });
      messageController.clear(); // Clear the input field
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.userProfileImage),
            ),
            SizedBox(width: 10),
            Text(widget.userName),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Message Text
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          messages[index]['text']!, // Message text
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      // Timestamp
                      Text(
                        messages[index]['time']!, // Message timestamp
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Message Input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.blue,
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
