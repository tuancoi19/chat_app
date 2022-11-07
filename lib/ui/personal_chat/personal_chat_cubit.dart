import 'package:chat_app/functions/database_functions.dart';
import 'package:chat_app/ui/personal_chat/personal_chat_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/entities/messages.dart';
import '../../models/entities/rooms.dart';

class PersonalChatCubit extends Cubit<PersonalChatState> {
  PersonalChatCubit() : super(const PersonalChatState());

  void changeName({required String name}) {
    emit(state.copyWith(name: name));
  }

  void changeRoom({required Room room}) {
    emit(state.copyWith(room: room));
  }

  void changeMessages({required List<Message> messages}) {
    emit(state.copyWith(messages: messages));
  }

  void changeisReply({required bool isReply}) {
    emit(state.copyWith(isReply: isReply));
  }

  void changeReplyMessage({required Message? replyMessage}) {
    emit(state.copyWith(replyMessage: replyMessage));
  }

  void getMessages(Room data) {
    FirebaseFirestore.instance
        .collection('room')
        .where('roomID', isEqualTo: data.roomID)
        .snapshots()
        .listen((event) {
      event.docs.single.reference
          .collection('listMessages')
          .withConverter(
              fromFirestore: Message.fromFirestore,
              toFirestore: (value, options) => value.toFirestore())
          .snapshots()
          .listen((event) {
        List<Message> result = event.docs.map((e) => e.data()).toList();
        result.sort((a, b) => b.createdTime.compareTo(a.createdTime));
        changeMessages(messages: result);
      });
    });
  }
}
