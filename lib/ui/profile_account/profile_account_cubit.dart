import 'package:chat_app/functions/database_functions.dart';
import 'package:chat_app/ui/profile_account/profile_account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileAccountCubit extends Cubit<ProfileAccountState> {
  ProfileAccountCubit() : super(const ProfileAccountState());

  void changeAvatar({required String? avatar}) {
    emit(state.copyWith(avatar: avatar));
  }

  void changeFirstName({required String firstname}) {
    emit(state.copyWith(firstName: firstname));
  }

  void changeLastName({required String lastname}) {
    emit(state.copyWith(lastName: lastname));
  }

  Future<void> getData(String number) async {
    final data = await DatabaseFunctions().getUserProfile(number);
    if (data != null) {
      changeAvatar(avatar: data.avatarURL);
      changeFirstName(firstname: data.name.firstName);
      changeLastName(lastname: data.name.lastName);
    }
  }
}
