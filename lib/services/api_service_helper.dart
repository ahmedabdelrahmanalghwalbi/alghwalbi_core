import 'package:alghwalbi_core/alghwalbi_core.dart';

class ApiServiceHelper {
  static Future<OperationResult> getRefreshTokens() async {
    if (CoreApp.refreshTokenApiURL == null ||
        (CoreApp.refreshTokenApiURL?.isEmpty ?? true)) {
      return OperationResult(success: false, multiMessage: {
        "en": "refreshTokenApiURL is null or empty",
        "ar": "لا يوجد رابط للتحقق من التوكن"
      });
    }
    OperationResult result = await ApiService().httpGetDynamic(
        CoreApp.refreshTokenApiURL!,
        checkOnTokenExpiration: false);
    if (result.success) {
      return result;
    } else {
      return OperationResult(success: false, multiMessage: result.multiMessage);
    }
  }

  static bool isTokenExpired() {
    if (ConfigService.checkValueExist("tokenExp")) {
      if (DateTime.fromMillisecondsSinceEpoch(
              ConfigService.accessTokenExpDate * 1000)
          .isBefore(DateTime.now().subtract(const Duration(hours: 3)))) {
        return true;
      }
      return false;
    }
    return false;
  }

  static Future<bool> assignNewTokens() async {
    if (!isTokenExpired()) return true;
    if (ConfigService.checkValueExist("refreshTokenExp")) {
      //checks if refresh token is still valid
      if (DateTime.fromMillisecondsSinceEpoch(
              ConfigService.refreshTokenExpDate * 1000)
          .isAfter(DateTime.now())) {
        //overrides access token with refresh token
        ConfigService.token = ConfigService.refreshToken;
        OperationResult response = await getRefreshTokens();
        if (response.success) {
          ConfigService.token = response.data['token'];
          ConfigService.refreshToken = response.data['refreshToken'];
          ConfigService.accessTokenExpDate = response.data['tokenExp'];
          ConfigService.refreshTokenExpDate = response.data['refreshTokenExp'];
          return true;
        }
      }
    }
    return false;
  }

  static Future<OperationResult<T>> checkExpirationOfTokens<T>(
      {required bool checkOnTokenExpiration}) async {
    if (CoreApp.checkOnTokenExpiration == true) {
      if (checkOnTokenExpiration == true) {
        if (ConfigService.token.isNotEmpty &&
            ConfigService.refreshToken.isNotEmpty) {
          bool isRefreshedSuccessfully =
              await ApiServiceHelper.assignNewTokens();

          if (isRefreshedSuccessfully != true) {
            //call unauthorized callback and return OperationResult with false result
            if (IApiService.unauthrizedCallback != null) {
              IApiService.unauthrizedCallback?.call(401);
            }

            return OperationResult<T>(
                success: false, message: 'Refresh token is not valid');
          }
        }
      }
    }
    return OperationResult<T>(success: true, message: 'Token is valid');
  }
}
