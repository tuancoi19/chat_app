import 'package:chat_app/models/entities/messages.dart';
import 'package:chat_app/ui/home/chats/widget/item_chat_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/enums/load_status.dart';

class ItemChatCubit extends Cubit<ItemChatState> {
  ItemChatCubit() : super(const ItemChatState());

  void changeMessage({required Message message}) {
    emit(state.copyWith(message: message));
  }

  void getLatestMessage(String roomID, String user) {
    emit(state.copyWith(fetchDataStatus: LoadStatus.loading));
    try {
      FirebaseFirestore.instance
          .collection('room')
          .where('roomID', isEqualTo: roomID)
          .snapshots()
          .listen((event) => event.docs.single.reference
                  .collection('listMessages')
                  .orderBy('createdTime')
                  .withConverter(
                      fromFirestore: Message.fromFirestore,
                      toFirestore: (value, options) => value.toFirestore())
                  .snapshots()
                  .listen((event) {
                changeMessage(message: event.docs.last.data());
                emit(state.copyWith(fetchDataStatus: LoadStatus.success));
              }));
    } catch (e) {
      emit(state.copyWith(fetchDataStatus: LoadStatus.failure));
    }
  }
}
