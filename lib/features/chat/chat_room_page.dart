import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting timestamps
import 'package:geolocation/features/chat/chat_room_controller.dart';

class ChatRoomPage extends StatefulWidget {
  final String councilId;
  final String councilName;
  final String userId;
  final String userName;
  final String? userImage;

  const ChatRoomPage({
    Key? key,
    required this.councilId,
    required this.councilName,
    required this.userId,
    required this.userName,
    this.userImage,
  }) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final ChatRoomController chatController = Get.find<ChatRoomController>();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatController.initializeChatRoom(widget.councilId, widget.councilName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        title: Text(widget.councilName, style: TextStyle(color: Colors.white),), backgroundColor: Palette.PRIMARY,),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (chatController.messages.isEmpty) {
                return Center(child: Text("No messages yet."));
              }

             return ListView.builder(
  reverse: true, // Show latest messages at the bottom
  itemCount: chatController.messages.length,
  itemBuilder: (context, index) {
    var message = chatController.messages[index];
    bool isMyMessage = message['sender_id'] == widget.userId;
    String? senderImage = message['sender_image']; // Sender's profile image

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ✅ Receiver's Profile Image (Only for received messages)
          if (!isMyMessage)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                child: OnlineImage(
                  imageUrl: senderImage ?? '',
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

          // ✅ Chat Bubble
          Flexible(
            child: Column(
              crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Sender Name (Only for received messages)
                if (!isMyMessage)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      message['sender_name'],
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),

                // Chat Bubble Container
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMyMessage ? Palette.deYork600 : Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: isMyMessage ? Radius.circular(12) : Radius.zero,
                      bottomRight: isMyMessage ? Radius.zero : Radius.circular(12),
                    ),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      // Message Text
                      if (message['text'] != null && message['text'].isNotEmpty)
                        Text(
                          message['text'],
                          style: TextStyle(
                            fontSize: 16,
                            color: isMyMessage ? Colors.white : Colors.black,
                          ),
                        ),

                      // Image (if available)
                      if (message['image'] != null && message['image'].isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              message['image'],
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // ✅ Timestamp & Delete Button (Properly aligned)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Timestamp
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 8, right: 8),
                      child: Text(
                        _formatTimestamp(message['timestamp']),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),

                    // Delete Button (Only for sender)
                    if (isMyMessage)
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red, size: 18),
                        onPressed: () {
                          _confirmDeleteMessage(context, message['id']);
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),

          // ✅ Sender's Profile Image (Only for sent messages)
          if (isMyMessage)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                child: OnlineImage(
                  imageUrl: senderImage ?? '',
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
        ],
      ),
    );
  },
);



            }),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  /// **Message Input Field**
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Enter message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Palette.DARK_PRIMARY),
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                chatController.sendMessage(
                  userId: widget.userId,
                  userName: widget.userName,
                  userImage: widget.userImage,
                  text: _messageController.text,
                );
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  /// **Delete Message Confirmation**
  void _confirmDeleteMessage(BuildContext context, String messageId) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Delete Message"),
      content: Text("Are you sure you want to delete this message?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            print("🚀 Confirming delete for message ID: $messageId");
            chatController.deleteMessage(messageId);
            Navigator.pop(context);
          },
          child: Text("Delete", style: TextStyle(color: Palette.RED)),
        ),
      ],
    ),
  );
}


  /// **Format Timestamp for Display**
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Unknown Time";
    DateTime date = timestamp.toDate();
    return DateFormat('hh:mm a').format(date); // Example: "12:30 PM"
  }
}
