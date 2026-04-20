import 'package:autoreply_ai/core/api/base_response/base_response.dart';
import 'package:autoreply_ai/data/model/request/login_request_model.dart';
import 'package:autoreply_ai/data/model/response/user_profile_response.dart';

abstract class AuthRepository {
  Future<BaseResponse<UserData?>> signIn(LoginRequestModel request);

  Future<BaseResponse> logout();
}
