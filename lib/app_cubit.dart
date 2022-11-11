import 'package:chat_app/app_state.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/ui/home/home_screen.dart';
import 'package:chat_app/ui/profile_account/profile_account_cubit.dart';
import 'package:chat_app/ui/profile_account/profile_account_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'functions/database_functions.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState());

  void updateCurrentUser({required User? user}) {
    emit(state.copyWith(user: user));
  }

  void getCurrentUser() {
    User? result = AuthRepository().getUser();
    updateCurrentUser(user: result);
  }

  void loadUserStatus(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        updateCurrentUser(user: user);
        await DatabaseFunctions()
            .getUserProfile(user.phoneNumber!)
            .then((value) async {
          if (value == null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                        create: (context) => ProfileAccountCubit(),
                        child:
                            const ProfileAccountScreen(isInSetting: false))));
          }
          await DatabaseFunctions()
              .updateUserProfile('isActive', true, user.phoneNumber!);
          Future.delayed(
              Duration.zero,
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                          create: (context) => ProfileAccountCubit(),
                          child: const HomeScreen(pageIndex: 0)))));
        });
      }
    });
  }
}
