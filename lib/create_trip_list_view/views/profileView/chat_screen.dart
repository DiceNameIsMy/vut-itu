import 'dart:convert'; // For JSON encoding/decoding
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

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
  List<Map<String, String>> messages = []; // List of messages (with text and timestamp)
  TextEditingController messageController = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadMessages(); // Load chat history
  }

  // Load messages from SharedPreferences
  Future<void> _loadMessages() async {
    prefs = await SharedPreferences.getInstance();
    String? storedMessages = prefs.getString(widget.userName); // Unique key for the chat
    if (storedMessages != null) {
      setState(() {
        messages = (json.decode(storedMessages) as List)
    .map((item) => Map<String, String>.from(item))
    .toList();
      });
    }
  }

  // Save messages to SharedPreferences
  Future<void> _saveMessages() async {
    String jsonMessages = json.encode(messages); // Convert messages to JSON
    await prefs.setString(widget.userName, jsonMessages); // Save messages under the user's key
  }

  // Send a new message
  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      setState(() {
        messages.add({
          'text': messageController.text,
          'time': TimeOfDay.now().format(context), // Add timestamp
        });
      });
      messageController.clear(); // Clear input field
      _saveMessages(); // Save updated messages
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
                        messages[index]['time']!, // Timestamp
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
