import 'package:chat_app/functions/generate_random_string.dart';
import 'package:chat_app/models/entities/messages.dart';
import 'package:chat_app/models/entities/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/entities/rooms.dart';
import '../models/enums/status.dart';

class DatabaseFunctions {
  final db = FirebaseFirestore.instance;

  Future<UserChat?> getUserProfile(String number) async {
    UserChat? data;
    await db
        .collection('userchat')
        .where('phoneNumber', isEqualTo: number)
        .withConverter(
          fromFirestore: UserChat.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        data = querySnapshot.docs.single.data();
      }
    });
    return data;
  }

  Future<List<UserChat>?> getAllUser(String number) async {
    List<UserChat>? data;
    await db
        .collection('userchat')
        .where('phoneNumber', isNotEqualTo: number)
        .withConverter(
          fromFirestore: UserChat.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .get()
        .then((value) {
      data = value.docs.map((e) => e.data()).toList();
    });
    return data;
  }

  addUserProfile(String firstName, String lastName, String? avatarURL,
      String phoneNumber) async {
    Name userChatName = Name(
        firstName: firstName.replaceAll(RegExp(r"\s+"), " ").trim(),
        lastName: lastName..replaceAll(RegExp(r"\s+"), " ").trim());
    UserChat userChat = UserChat(
        name: userChatName,
        avatarURL: avatarURL,
        phoneNumber: phoneNumber,
        isActive: true,
        storyURL: []);
    await db.collection('userchat').doc().set(userChat.toFirestore());
  }

  updateUserProfile(String field, data, String phoneNumber) async {
    await db
        .collection('userchat')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .withConverter(
            fromFirestore: UserChat.fromFirestore,
            toFirestore: (value, options) => value.toFirestore())
        .get()
        .then((value) async =>
            await value.docs.single.reference.update({field: data}));
  }

  checkRoom(String member1, String member2) async {
    List<Room>? data;
    Room? result;
    await db
        .collection('room')
        .withConverter(
            fromFirestore: Room.fromFirestore,
            toFirestore: (value, options) => value.toFirestore())
        .get()
        .then((value) async {
      data = value.docs.map((e) => e.data()).toList();
      for (var i in data!) {
        if (i.listMembers.contains(member1) &&
            i.listMembers.contains(member2)) {
          result = i;
        }
      }
      result ??= await createRoom(member1, member2);
    });
    return result;
  }

  createRoom(String member1, String member2) async {
    Room room = Room(
        roomID: 'room${getRandomString(12)}',
        updatedTime: Timestamp.now(),
        listMembers: [member1, member2],
        haveMessage: false);
    await db.collection('room').doc().set(room.toFirestore());
    return room;
  }

  sendTextMessage(String author, String content, Room room,
      {String? replyID}) async {
    Message message = Message(
        createdTime: Timestamp.now(),
        messageID: 'message${getRandomString(12)}',
        content: content,
        author: author,
        replyID: replyID,
        status: Status.sent.name);
    await db
        .collection('room')
        .where('roomID', isEqualTo: room.roomID)
        .get()
        .then((value) async {
      await value.docs.single.reference
          .collection('listMessages')
          .doc()
          .set(message.toFirestore());
      await value.docs.single.reference
          .withConverter(
              fromFirestore: Room.fromFirestore,
              toFirestore: (value, options) => value.toFirestore())
          .update({'updatedTime': Timestamp.now(), 'haveMessage': true});
    });
  }

  sendAttachmentMessage(
      String author, String attachURL, String attachType, Room room,
      {String? replyID, String? thumbnailURL, String? attachName}) async {
    Message message = Message(
        createdTime: Timestamp.now(),
        messageID: 'message${getRandomString(12)}',
        content: '',
        author: author,
        replyID: replyID,
        status: Status.sent.name,
        attachType: attachType,
        attachURL: attachURL,
        thumbnailURL: thumbnailURL,
        attachName: attachName);
    await db
        .collection('room')
        .where('roomID', isEqualTo: room.roomID)
        .get()
        .then((value) async {
      await value.docs.single.reference
          .collection('listMessages')
          .doc()
          .set(message.toFirestore());
      await value.docs.single.reference
          .withConverter(
              fromFirestore: Room.fromFirestore,
              toFirestore: (value, options) => value.toFirestore())
          .update({'updatedTime': Timestamp.now(), 'haveMessage': true});
    });
  }

  getAllRoom(String number) async {
    List<Room>? data;
    await db
        .collection('room')
        .where('listMembers', arrayContains: number)
        .withConverter(
            fromFirestore: Room.fromFirestore,
            toFirestore: (value, options) => value.toFirestore())
        .get()
        .then((value) => data = value.docs.map((e) => e.data()).toList());
    return data;
  }
}
