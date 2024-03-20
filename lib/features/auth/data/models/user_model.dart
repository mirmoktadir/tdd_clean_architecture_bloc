import 'dart:convert';

import '../../../../core/utils/typedef.dart';
import '../../domain/entities/user_entity.dart';

/// use for API
//  from dart model to json  => toJSON
//  from json to dart model  => fromJSON
/// Use for local data
//  from dart model to Map  => toMap
//  from Map to dart model  => fromMap

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.createdAt,
    required super.name,
    required super.avatar,
  });

  const UserModel.empty()
      : this(
            id: "1",
            createdAt: "empty.createdAt",
            name: "empty.name",
            avatar: "empty.avatar");

  factory UserModel.fromJson(String jsonResponse) =>
      UserModel.fromMap(jsonDecode(jsonResponse) as DataMap);

  factory UserModel.fromMap(DataMap map) => UserModel(
        id: map["id"] as String,
        createdAt: map["createdAt"] as String,
        name: map["name"] as String,
        avatar: map["avatar"] as String,
      );

  DataMap toMap() => {
        "id": id,
        "createdAt": createdAt,
        "name": name,
        "avatar": avatar,
      };

  String toJson() => jsonEncode(toMap());

  UserModel copyWith({
    String? id,
    String? createdAt,
    String? name,
    String? avatar,
  }) {
    return UserModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }
}
