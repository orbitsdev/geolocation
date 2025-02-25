import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatRoomController extends GetxController {
  static ChatRoomController controller = Get.find();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxString chatRoomId = ''.obs;
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

  /// Function to check if the chat room exists, and create it if not
  Future<void> initializeChatRoom(String councilId, String councilName) async {
    chatRoomId.value = councilId;

    DocumentReference chatRoomRef = firestore.collection('chat_rooms').doc(councilId);
    var chatRoom = await chatRoomRef.get();

    if (!chatRoom.exists) {
      await chatRoomRef.set({
        'name': councilName,
        'created_at': FieldValue.serverTimestamp(),
      });
    }

    // Start listening for messages
    listenToMessages();
  }

  /// Function to listen for new messages in real-time
  void listenToMessages() {
    firestore
        .collection('chat_rooms')
        .doc(chatRoomId.value)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id; // ✅ Store document ID for deletion
        return data;
      }).toList();
    });
  }

  /// Function to send a message (with optional image)
  Future<void> sendMessage({
    required String userId,
    required String userName,
    required String? userImage,
    required String text,
    String? imageUrl, // Nullable image URL
  }) async {
    if (chatRoomId.value.isEmpty) return;

    await firestore
        .collection('chat_rooms')
        .doc(chatRoomId.value)
        .collection('messages')
        .add({
      'sender_id': userId,
      'sender_name': userName,
      'sender_image': userImage,
      'text': text,
      'image': imageUrl, // Nullable
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// ✅ Function to delete a message
  Future<void> deleteMessage(String messageId) async {
    if (chatRoomId.value.isEmpty) {
      print("❌ ChatRoom ID is empty!");
      return;
    }

    try {
      print("🗑️ Deleting message with ID: $messageId");

      await firestore
          .collection('chat_rooms')
          .doc(chatRoomId.value)
          .collection('messages')
          .doc(messageId)
          .delete();

      print("✅ Message deleted successfully!");
    } catch (e) {
      print("❌ Error deleting message: $e");
    }
  }
}
