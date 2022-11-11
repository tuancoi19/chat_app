import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppState extends Equatable {
  final User? user;

  const AppState({this.user});

  @override
  List<Object?> get props => [user];

  AppState copyWith({User? user}) {
    return AppState(user: user ?? this.user);
  }
}
