import 'package:equatable/equatable.dart';

import '../../../models/entities/rooms.dart';
import '../../../models/entities/users.dart';

class ChatsState extends Equatable {
  final List<Room> listRoom;
  final List<UserChat> listUserChat;

  const ChatsState({this.listRoom = const [], this.listUserChat = const []});

  @override
  List<Object?> get props => [listRoom, listUserChat];

  ChatsState copyWith({List<Room>? listRoom, List<UserChat>? listUserChat}) {
    return ChatsState(
        listRoom: listRoom ?? this.listRoom,
        listUserChat: listUserChat ?? this.listUserChat);
  }
}
