import 'package:equatable/equatable.dart';

import '../../../models/entities/rooms.dart';

class ChatsState extends Equatable {
  final List<Room>? listRoom;

  const ChatsState({this.listRoom = const []});

  @override
  List<Object?> get props => [listRoom];

  ChatsState copyWith({List<Room>? listRoom}) {
    return ChatsState(listRoom: listRoom);
  }
}
