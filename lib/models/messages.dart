import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  bool isRead;
  //final String receiverName;
  final Timestamp timeStamp;

  Message({
    required this.senderId,
    //required this.receiverName,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timeStamp,
     required this.isRead,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timeStamp': timeStamp,
       'isRead': isRead,
    };
  }
}
