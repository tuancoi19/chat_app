import 'package:cloud_firestore/cloud_firestore.dart';

class UserChat {
  final Name name;
  final String? avatarURL;
  final String phoneNumber;
  final bool isActive;
  final List<String>? storyURL;

  UserChat(
      {required this.name,
      this.avatarURL,
      required this.phoneNumber,
      required this.isActive,
      this.storyURL});

  factory UserChat.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return UserChat(
        name: (data?['name'] is Map)
            ? Name(
                firstName: data?['name']['firstName'],
                lastName: data?['name']['lastName'])
            : const Name(firstName: '', lastName: ''),
        avatarURL: data?['avatarURL'],
        phoneNumber: data?['phoneNumber'],
        isActive: data?['isActive'],
        storyURL: List<String>.from(data?['storyURL']));
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name.toFirestore(),
      if (avatarURL != null) "avatarURL": avatarURL else "avatarURL": "",
      "phoneNumber": phoneNumber,
      "isActive": isActive,
      if (storyURL != null) "storyURL": storyURL else "storyURL": []
    };
  }
}

class Name {
  final String firstName;
  final String lastName;

  const Name({required this.firstName, required this.lastName});

  factory Name.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Name(firstName: data?['firstName'], lastName: data?['lastName']);
  }

  Map<String, String> toFirestore() {
    return {
      "firstName": firstName,
      "lastName": lastName,
    };
  }
}
