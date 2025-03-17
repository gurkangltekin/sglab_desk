import 'package:sglab_desk/common/entities/entities.dart';
import 'package:sglab_desk/common/utils/utils.dart';
import 'package:sglab_desk/common/values/values.dart';

class UserAPI {
  static Future<UserLoginResponseEntity> Login({
    LoginRequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      'api/login',
      queryParameters: params?.toJson(),
    );
    return UserLoginResponseEntity.fromJson(response);
  }

  static Future<UserLoginResponseEntity> controlTokenIsExpired(
    String token
  ) async {
    var response = await HttpUtil().post(
      'api/v1/auth/controlTokenIsExpired',
      queryParameters: {"token": token},
    );
    return UserLoginResponseEntity.fromJson(response);
  }

  static Future<UserLoginResponseEntity> LoginWithThirdParty({
    LoginRequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      'api/v1/auth/loginWithThirdParts',
      data: params?.toJson(),
    );
    return UserLoginResponseEntity.fromJson(response);
  }

  static Future<UserLoginResponseEntity> get_profile() async {
    var response = await HttpUtil().post(
      'api/get_profile',
    );
    return UserLoginResponseEntity.fromJson(response);
  }

  static Future<BaseResponseEntity> UpdateProfile({
    LoginRequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      'api/update_profile',
      queryParameters: params?.toJson(),
    );
    return BaseResponseEntity.fromJson(response);
  }
}
