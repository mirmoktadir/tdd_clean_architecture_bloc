import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_architecture_bloc/core/errors/exceptions.dart';
import 'package:tdd_clean_architecture_bloc/core/utils/constants.dart';
import 'package:tdd_clean_architecture_bloc/features/auth/data/models/user_model.dart';
import 'package:tdd_clean_architecture_bloc/features/auth/data/sources/auth_remote_data_source.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthRemoteDataSource authRemoteDataSource;

  setUp(() {
    client = MockClient();
    authRemoteDataSource = AuthRemoteDataSourceImpl(client);
    registerFallbackValue(Uri());
  });

  group("createUser", () {
    test("complete successfully when the status code is 200 or 201", () async {
      //Arrange
      when(
        () => client.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response('User created successfully', 201),
      );
      // Act
      final methodCall = authRemoteDataSource.createUser;
      //Assert
      expect(
          methodCall(
            createdAt: 'createdAt',
            name: 'name',
            avatar: 'avatar',
          ),
          completes);
      verify(() => client.post(
            Uri.https(kBaseUrl, kCreateUserEndpoint),
            body: jsonEncode({
              'createdAt': 'createdAt',
              'name': 'name',
              'avatar': 'avatar',
            }),
            headers: {'Content-Type': 'application/json'},
          )).called(1);
      verifyNoMoreInteractions(client);
    });

    test("should throw [APIException] when the status code is not 200 or 201",
        () async {
      //Arrange
      when(
        () => client.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Something went wrong', 400),
      );
      // Act
      final methodCall = authRemoteDataSource.createUser;
      //Assert
      expect(
        () async => methodCall(
          createdAt: 'createdAt',
          name: 'name',
          avatar: 'avatar',
        ),
        throwsA(
          const APIException(
            message: 'Something went wrong',
            statusCode: 400,
          ),
        ),
      );
      verify(() => client.post(
            Uri.https(kBaseUrl, kCreateUserEndpoint),
            body: jsonEncode({
              'createdAt': 'createdAt',
              'name': 'name',
              'avatar': 'avatar',
            }),
            headers: {'Content-Type': 'application/json'},
          )).called(1);
      verifyNoMoreInteractions(client);
    });
  });
  group("getUsers", () {
    const tUsers = [UserModel.empty()];
    test("complete successfully when the status code is 200", () async {
      //Arrange
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response(jsonEncode([tUsers.first.toMap()]), 200),
      );
      //Act
      final result = await authRemoteDataSource.getUsers();
      //Assert
      expect(result, equals(tUsers));
      verify(() => client.get(
            Uri.https(kBaseUrl, kGetUserEndpoint),
          )).called(1);
      verifyNoMoreInteractions(client);
    });
    test("should throw [APIException] when the status code is not 200",
        () async {
      //Arrange
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response('Something went wrong', 500),
      );
      //Act
      final methodCall = authRemoteDataSource.getUsers;
      //Assert
      expect(
        () async => methodCall(),
        throwsA(
          const APIException(
            message: 'Something went wrong',
            statusCode: 500,
          ),
        ),
      );
      verify(() => client.get(
            Uri.https(kBaseUrl, kGetUserEndpoint),
          )).called(1);
      verifyNoMoreInteractions(client);
    });
  });
}
