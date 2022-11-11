import 'package:chat_app/ui/home/chats/chats_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../functions/database_functions.dart';
import '../../../models/entities/rooms.dart';
import '../../../models/entities/users.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(const ChatsState());

  void changeListRooms({required List<Room> listRoom}) {
    emit(state.copyWith(listRoom: listRoom));
  }

  void getListRoom(String number) {
    List<Room> data = [];
    FirebaseFirestore.instance
        .collection('room')
        .where('listMembers', arrayContains: number)
        .where('haveMessage', isEqualTo: true)
        .withConverter(
            fromFirestore: Room.fromFirestore,
            toFirestore: (value, options) => value.toFirestore())
        .snapshots()
        .listen((event) {
      data = event.docs.map((e) => e.data()).toList();
      data.sort((a, b) => b.updatedTime.compareTo(a.updatedTime));
      changeListRooms(listRoom: data);
    });
  }

  final DatabaseFunctions databaseFunctions = DatabaseFunctions();

  void changeListUserChat({required List<UserChat> listUserChat}) {
    emit(state.copyWith(listUserChat: listUserChat));
  }

  void getUserChat(String number) {
    FirebaseFirestore.instance
        .collection('userchat')
        .where('phoneNumber', isNotEqualTo: number)
        .withConverter(
          fromFirestore: UserChat.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .snapshots()
        .listen((event) {
      changeListUserChat(
          listUserChat: event.docs.map((e) => e.data()).toList());
    });
  }
}
