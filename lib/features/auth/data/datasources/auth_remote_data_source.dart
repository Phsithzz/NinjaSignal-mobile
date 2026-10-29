import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<String> login({required String email, required String password});
  Future<UserModel> register({required String email, required String password, required String name});
  Future<UserModel> getMe();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<String> login({required String email, required String password}) async {
    final response = await client.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    final token = response['access_token'] as String;
    await client.saveToken(token);
    return token;
  }

  @override
  Future<UserModel> register({required String email, required String password, required String name}) async {
    final response = await client.post(
      ApiConstants.register,
      data: {'email': email, 'password': password, 'name': name},
    );
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> getMe() async {
    final response = await client.get(ApiConstants.me);
    return UserModel.fromJson(response);
  }

  @override
  Future<void> logout() async {
    try {
      await client.post(ApiConstants.logout);
    } finally {
      await client.clearToken();
    }
  }
}
