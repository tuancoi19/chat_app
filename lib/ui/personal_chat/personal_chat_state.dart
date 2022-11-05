import 'package:chat_app/models/entities/messages.dart';
import 'package:equatable/equatable.dart';

import '../../models/entities/rooms.dart';

class PersonalChatState extends Equatable {
  final String? name;
  final Room? room;
  final List<Message>? messages;
  final Duration? duration;
  final Duration? position;
   

  const PersonalChatState(
      {this.name,
      this.room,
      this.messages = const [],
      this.duration,
      this.position});

  @override
  List<Object?> get props => [name, room, messages, duration, position];

  PersonalChatState copyWith({
    String? name,
    Room? room,
    List<Message>? messages,
    Duration? duration,
    Duration? position,
  }) {
    return PersonalChatState(
      name: name ?? this.name,
      room: room ?? this.room,
      messages: messages ?? this.messages,
      duration: duration ?? this.duration,
      position: position ?? this.position,
    );
  }
}
