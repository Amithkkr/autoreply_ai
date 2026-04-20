import 'package:mobx/mobx.dart';
import 'package:autoreply_ai/data/repository_impl/auth_repo_impl.dart';
import 'package:autoreply_ai/data/model/request/login_request_model.dart';
import 'package:autoreply_ai/data/model/response/user_profile_response.dart';
import 'package:autoreply_ai/core/api/base_response/base_response.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  UserData? userData;

  @action
  Future<void> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;

    try {
      final request = LoginRequestModel(email: email, password: password);
      final BaseResponse<UserData?> response = await authRepo.signIn(request);

      if (response.data != null) {
        userData = response.data;
      } else {
        errorMessage = response.message ?? "Login failed";
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }
}
