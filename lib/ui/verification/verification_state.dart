import 'package:equatable/equatable.dart';

class SignInState extends Equatable {
  final String phoneCode;
  final String? phoneNumber;

  const SignInState({this.phoneCode = '84', this.phoneNumber});

  @override
  List<Object?> get props => [phoneCode, phoneNumber];

  SignInState copyWith({String? phoneCode, String? phoneNumber}) {
    return SignInState(
        phoneCode: phoneCode ?? this.phoneCode,
        phoneNumber: phoneNumber ?? this.phoneNumber);
  }
}
