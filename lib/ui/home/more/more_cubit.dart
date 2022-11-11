import 'package:chat_app/functions/database_functions.dart';
import 'package:chat_app/models/entities/users.dart';
import 'package:chat_app/ui/home/more/more_state.dart';
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

  Future<void> getUser(String number) async {
    emit(state.copyWith(fetchDataStatus: LoadStatus.loading));
    try {
      UserChat? data = await DatabaseFunctions().getUserProfile(number);
      changeAvatarURL(avatarURL: data!.avatarURL);
      changeName(name: '${data.name.firstName} ${data.name.lastName}');
      emit(state.copyWith(fetchDataStatus: LoadStatus.success));
    } catch (e) {
      emit(state.copyWith(fetchDataStatus: LoadStatus.failure));
    }
  }
}
