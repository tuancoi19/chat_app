import 'package:equatable/equatable.dart';

class ProfileAccountState extends Equatable {
  final String? avatar;
  final String? firstName;
  final String? lastName;

  const ProfileAccountState({this.avatar, this.firstName, this.lastName});

  @override
  List<Object?> get props => [avatar, firstName, lastName];

  ProfileAccountState copyWith(
      {String? avatar, String? firstName, String? lastName}) {
    return ProfileAccountState(
        avatar: avatar ?? this.avatar,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName);
  }
}
