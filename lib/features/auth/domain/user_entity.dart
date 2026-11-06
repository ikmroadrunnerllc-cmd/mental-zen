import 'package:flutter/foundation.dart';

@immutable
class UserEntity {
  final String uid;
  final String email;
  final String? displayName;

  const UserEntity({required this.uid, required this.email, this.displayName});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          email == other.email &&
          displayName == other.displayName;

  @override
  int get hashCode =>
      uid.hashCode ^ email.hashCode ^ (displayName?.hashCode ?? 0);
}
