import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String roomID;
  final Timestamp updatedTime;
  final List<String> listMembers;

  Room(
      {required this.roomID,
      required this.updatedTime,
      required this.listMembers});

  factory Room.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Room(
        roomID: data?['roomID'],
        updatedTime: data?['updatedTime'],
        listMembers: List<String>.from(data?['listMembers']));
  }

  Map<String, dynamic> toFirestore() {
    return {
      'roomID': roomID,
      'updatedTime': updatedTime,
      'listMembers': listMembers
    };
  }
}
