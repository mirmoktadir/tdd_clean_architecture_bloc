// what does the class depends on ?
// Answer -- No dependency
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_clean_architecture_bloc/features/auth/data/models/user_model.dart';
import 'package:tdd_clean_architecture_bloc/features/auth/domain/entities/user_entity.dart';

import '../../../../fixtures/fixtures_reader.dart';

void main() {
  const tModel = UserModel.empty();
  test("Should be subclass of UserEntity", () {
    //Assert
    expect(tModel, isA<UserEntity>());
  });

  final tJson = fixture(filename: 'user.json');
  final tMap = jsonDecode(tJson);
  group("fromMap", () {
    test("should return a UserModel with correct Data", () {
      //Act
      final result = UserModel.fromMap(tMap);
      //Assert
      expect(result, equals(tModel));
    });
  });

  group("fromJson", () {
    test("should return a UserModel with correct Data", () {
      //Act
      final result = UserModel.fromJson(tJson);
      //Assert
      expect(result, equals(tModel));
    });
  });

  group("toMap", () {
    test("should return a Map with correct data", () {
      //Act
      final result = tModel.toMap();
      //Assert
      expect(result, equals(tMap));
    });
  });

  group("toJson", () {
    test("should return a Json with correct data", () {
      //Act
      final result = tModel.toJson();
      //Assert
      expect(result, equals(tJson));
    });
  });

  group("copyWith", () {
    test("should return a User model with different data", () {
      //Act
      final result = tModel.copyWith(name: "moktadir");
      //Assert
      expect(result.name, equals('moktadir'));
    });
  });
}
