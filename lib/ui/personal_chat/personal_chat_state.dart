import 'package:chat_app/models/entities/messages.dart';
import 'package:chat_app/models/enums/load_status.dart';
import 'package:equatable/equatable.dart';

import '../../models/entities/rooms.dart';

class PersonalChatState extends Equatable {
  final String? name;
  final Room? room;
  final List<Message>? messages;
  final bool? isReply;
  final Message? replyMessage;
  final LoadStatus fetchDataStatus;

  const PersonalChatState(
      {this.name,
      this.room,
      this.fetchDataStatus = LoadStatus.initial,
      this.messages = const [],
      this.isReply = false,
      this.replyMessage});

  @override
  List<Object?> get props =>
      [name, room, messages, isReply, replyMessage, fetchDataStatus];

  PersonalChatState copyWith({
    String? name,
    Room? room,
    List<Message>? messages,
    bool? isReply,
    Message? replyMessage,
    LoadStatus? fetchDataStatus,
  }) {
    return PersonalChatState(
        fetchDataStatus: fetchDataStatus ?? this.fetchDataStatus,
        name: name ?? this.name,
        room: room ?? this.room,
        messages: messages ?? this.messages,
        isReply: isReply ?? this.isReply,
        replyMessage: replyMessage ?? this.replyMessage);
  }
}
