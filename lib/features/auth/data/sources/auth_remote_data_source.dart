import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/typedef.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });
  Future<List<UserModel>> getUsers();
}

const kCreateUserEndpoint = '/test-api/users';
const kGetUserEndpoint = '/test-api/users';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._client);

  final http.Client _client;
  @override
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    //1. check to make sure that it returns the right data when the response status code is 200 or the proper response status code
    // 2. check to make sure that it "THROWS A CUSTOM EXCEPTION" with the right message when status code is the bad one
    try {
      final response = await _client.post(
        Uri.https(kBaseUrl, kCreateUserEndpoint),
        body: jsonEncode({
          'createdAt': createdAt,
          'name': name,
          //'avatar': avatar,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        /// NOTE: if server gives message in a map than decode response.body
        throw APIException(
            message: response.body, statusCode: response.statusCode);
      }
    } on APIException {
      /// Prevent API Exception to go in catch block.
      rethrow;
    } catch (e) {
      /// For dart error.
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _client.get(
        Uri.https(kBaseUrl, kGetUserEndpoint),
      );
      if (response.statusCode != 200) {
        throw APIException(
            message: response.body, statusCode: response.statusCode);
      }
      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map((userData) => UserModel.fromMap(userData))
          .toList();
    } on APIException {
      /// Prevent API Exception to go in catch block.
      rethrow;
    } catch (e) {
      /// For dart error.
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }
}
