import 'package:chat_app/models/entities/users.dart';
import 'package:equatable/equatable.dart';

class ContactsState extends Equatable {
  final List<UserChat> listContacts;

  const ContactsState({this.listContacts = const []});

  @override
  List<Object?> get props => [listContacts];

  ContactsState copyWith({List<UserChat>? listContacts}) {
    return ContactsState(listContacts: listContacts ?? this.listContacts);
  }
}
