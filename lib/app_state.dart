import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final String? userNumber;

  const AppState({this.userNumber});

  @override
  List<Object?> get props => [userNumber];

  AppState copyWith({String? userNumber}) {
    return AppState(userNumber: userNumber ?? this.userNumber);
  }
}
