import 'package:chat_app/app_cubit.dart';
import 'package:chat_app/ui/verification/verification_screen_2.dart';
import 'package:chat_app/ui/verification/verification_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../functions/database_functions.dart';
import '../../functions/show_toast.dart';
import '../../repositories/auth_repository.dart';
import '../home/home_screen.dart';
import '../profile_account/profile_account_cubit.dart';
import '../profile_account/profile_account_screen.dart';

class SignInCubit extends Cubit<SignInState> {
  final FirebaseAuth fireBaseAuth = FirebaseAuth.instance;
  final AppCubit appCubit;
  SignInCubit({required this.appCubit}) : super(const SignInState());

  void changePhoneCode({required String phoneCode}) {
    emit(state.copyWith(phoneCode: phoneCode));
  }

  void changePhoneNumber({required String phoneNumber}) {
    emit(state.copyWith(phoneNumber: phoneNumber));
  }

  void verifyNumber(
      BuildContext context, String phoneCode, String phoneNumber) async {
    await fireBaseAuth.verifyPhoneNumber(
      phoneNumber: '+${phoneCode + phoneNumber}',
      timeout: const Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        showStatusToast('Authentication Successfully!');
      },
      verificationFailed: (FirebaseAuthException error) {
        showStatusToast('Authentication Failed!');
      },
      codeSent: (verificationId, forceResendingToken) {
        showStatusToast('A message will send to you');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                    create: (context) {
                      final appCubit = RepositoryProvider.of<AppCubit>(context);
                      return SignInCubit(appCubit: appCubit);
                    },
                    child: VerificationScreen2(
                        phoneCode: phoneCode,
                        phoneNumber: phoneNumber,
                        verifyID: verificationId))));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP(BuildContext context, String verifyID, String otpPin) async {
    await fireBaseAuth.signInWithCredential(PhoneAuthProvider.credential(
        verificationId: verifyID, smsCode: otpPin));
  }
}
