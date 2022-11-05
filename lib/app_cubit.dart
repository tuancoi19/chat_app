import 'package:chat_app/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  void updateCurrentUser({required String number}) {
    emit(state.copyWith(userNumber: number));
  }
}
