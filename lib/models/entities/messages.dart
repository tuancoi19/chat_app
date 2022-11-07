import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final Timestamp createdTime;
  final String? content;
  final String messageID;
  final String author;
  final String? attachName;
  final String? attachURL;
  final String? attachType;
  final String status;
  final String? replyID;
  final bool isDisable;
  final String? thumbnailURL;

  Message(
      {required this.createdTime,
      this.content,
      required this.messageID,
      required this.author,
      this.attachURL,
      this.attachType,
      required this.status,
      this.replyID,
      this.isDisable = false,
      this.thumbnailURL,
      this.attachName});

  factory Message.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Message(
        createdTime: data?['createdTime'],
        content: data?['content'],
        messageID: data?['messageID'],
        author: data?['author'],
        attachURL: data?['assetURL'],
        attachType: data?['assetType'],
        status: data?['status'],
        replyID: data?['replyID'],
        isDisable: data?['isDisable'],
        thumbnailURL: data?['thumbnailURL'],
        attachName: data?['attachName']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'createdTime': createdTime,
      if (content != null) 'content': content else 'content': '',
      'messageID': messageID,
      'author': author,
      if (attachURL != null) 'assetURL': attachURL else 'assetURL': '',
      if (attachType != null) 'assetType': attachType else 'assetType': '',
      'status': status,
      if (replyID != null) 'replyID': replyID else 'replyID': '',
      'isDisable': isDisable,
      'thumbnailURL': thumbnailURL,
      if (attachType != null) 'attachName': attachName else 'attachName': ''
    };
  }
}
