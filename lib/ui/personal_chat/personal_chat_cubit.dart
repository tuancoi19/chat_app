import 'package:chat_app/functions/database_functions.dart';
import 'package:chat_app/models/enums/load_status.dart';
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

  Future<void> fetchMessages(String guest, String me) async {
    emit(state.copyWith(fetchDataStatus: LoadStatus.loading));
    try {
      Room data = await DatabaseFunctions().checkRoom(guest, me);
      changeRoom(room: data);
      FirebaseFirestore.instance
          .collection('room')
          .where('roomID', isEqualTo: data.roomID)
          .snapshots()
          .listen((value) {
        value.docs.single.reference
            .collection('listMessages')
            .withConverter(
                fromFirestore: Message.fromFirestore,
                toFirestore: (value, options) => value.toFirestore())
            .snapshots()
            .listen((value) {
          List<Message> result = value.docs.map((e) => e.data()).toList();
          result.sort((a, b) => b.createdTime.compareTo(a.createdTime));
          changeMessages(messages: result);
        });
      });
      emit(state.copyWith(fetchDataStatus: LoadStatus.success));
    } catch (e) {
      emit(state.copyWith(fetchDataStatus: LoadStatus.failure));
    }
  }

  void getMessages() {
    FirebaseFirestore.instance
        .collection('room')
        .where('roomID', isEqualTo: state.room!.roomID)
        .snapshots()
        .listen((value) {
      value.docs.single.reference
          .collection('listMessages')
          .withConverter(
              fromFirestore: Message.fromFirestore,
              toFirestore: (value, options) => value.toFirestore())
          .snapshots()
          .listen((value) {
        List<Message> result = value.docs.map((e) => e.data()).toList();
        result.sort((a, b) => b.createdTime.compareTo(a.createdTime));
        changeMessages(messages: result);
      });
    });
  }
}
