import 'package:chat_app/models/entities/users.dart';
import 'package:chat_app/ui/home/more/more_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/enums/load_status.dart';

class MoreCubit extends Cubit<MoreState> {
  MoreCubit() : super(const MoreState());

  void changeName({required String name}) {
    emit(state.copyWith(name: name));
  }

  void changeAvatarURL({required String? avatarURL}) {
    emit(state.copyWith(avatarURL: avatarURL));
  }

  void getUser(String number) {
    emit(state.copyWith(fetchDataStatus: LoadStatus.loading));
    try {
      FirebaseFirestore.instance
          .collection('userchat')
          .where('phoneNumber', isEqualTo: number)
          .withConverter(
              fromFirestore: UserChat.fromFirestore,
              toFirestore: (value, options) => value.toFirestore())
          .snapshots()
          .listen(
        (event) {
          changeAvatarURL(avatarURL: event.docs.single.data().avatarURL);
          changeName(
              name:
                  '${event.docs.single.data().name.firstName} ${event.docs.single.data().name.lastName}');
          emit(state.copyWith(fetchDataStatus: LoadStatus.success));
        },
      );
    } catch (e) {
      emit(state.copyWith(fetchDataStatus: LoadStatus.failure));
    }
  }
}
