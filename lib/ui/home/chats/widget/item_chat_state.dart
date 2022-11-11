import 'package:equatable/equatable.dart';

import '../../../../models/entities/messages.dart';
import '../../../../models/enums/load_status.dart';

class ItemChatState extends Equatable {
  final Message? message;
  final LoadStatus fetchDataStatus;

  const ItemChatState(
      {this.message, this.fetchDataStatus = LoadStatus.initial});

  @override
  List<Object?> get props => [message, fetchDataStatus];

  ItemChatState copyWith({Message? message, LoadStatus? fetchDataStatus}) {
    return ItemChatState(
        message: message ?? this.message,
        fetchDataStatus: fetchDataStatus ?? this.fetchDataStatus);
  }
}
