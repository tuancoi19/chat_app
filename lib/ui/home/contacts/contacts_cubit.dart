import 'package:chat_app/functions/database_functions.dart';
import 'package:chat_app/models/entities/users.dart';
import 'package:chat_app/ui/home/contacts/contacts_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(const ContactsState());
  final DatabaseFunctions databaseFunctions = DatabaseFunctions();

  void changeListContacts({required List<UserChat> listContacts}) {
    emit(state.copyWith(listContacts: listContacts));
  }

  void getContacts(String number) {
    FirebaseFirestore.instance
        .collection('userchat')
        .where('phoneNumber', isNotEqualTo: number)
        .withConverter(
          fromFirestore: UserChat.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .snapshots()
        .listen((event) {
      changeListContacts(
          listContacts: event.docs.map((e) => e.data()).toList());
    });
  }
}
