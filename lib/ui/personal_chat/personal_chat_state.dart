import 'package:chat_app/models/entities/messages.dart';
import 'package:equatable/equatable.dart';

import '../../models/entities/rooms.dart';

class PersonalChatState extends Equatable {
  final String? name;
  final Room? room;
  final List<Message>? messages;

  const PersonalChatState({this.name, this.room, this.messages = const []});

  @override
  List<Object?> get props => [name, room, messages];

  PersonalChatState copyWith(
      {String? name, Room? room, List<Message>? messages}) {
    return PersonalChatState(
        name: name ?? this.name,
        room: room ?? this.room,
        messages: messages ?? this.messages);
  }
}
