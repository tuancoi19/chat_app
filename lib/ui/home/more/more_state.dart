import 'package:equatable/equatable.dart';

import '../../../models/enums/load_status.dart';

class MoreState extends Equatable {
  final String name;
  final String? avatarURL;
  final LoadStatus fetchDataStatus;

  const MoreState(
      {this.name = 'Guest',
      this.avatarURL,
      this.fetchDataStatus = LoadStatus.initial});

  @override
  List<Object?> get props => [name, avatarURL, fetchDataStatus];

  MoreState copyWith(
      {String? name, String? avatarURL, LoadStatus? fetchDataStatus}) {
    return MoreState(
        name: name ?? this.name,
        avatarURL: avatarURL ?? this.avatarURL,
        fetchDataStatus: fetchDataStatus ?? this.fetchDataStatus);
  }
}
