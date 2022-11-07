import 'package:chat_app/models/entities/messages.dart';
import 'package:equatable/equatable.dart';

import '../../models/entities/rooms.dart';

class PersonalChatState extends Equatable {
  final String? name;
  final Room? room;
  final List<Message>? messages;
  final bool? isReply;
  final Message? replyMessage;

  const PersonalChatState(
      {this.name,
      this.room,
      this.messages = const [],
      this.isReply = false,
      this.replyMessage});

  @override
  List<Object?> get props => [name, room, messages, isReply, replyMessage];

  PersonalChatState copyWith(
      {String? name,
      Room? room,
      List<Message>? messages,
      bool? isReply,
      Message? replyMessage}) {
    return PersonalChatState(
        name: name ?? this.name,
        room: room ?? this.room,
        messages: messages ?? this.messages,
        isReply: isReply ?? this.isReply,
        replyMessage: replyMessage ?? this.replyMessage);
  }
}
