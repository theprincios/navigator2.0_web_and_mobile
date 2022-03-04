import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:es_2022_02_02_1/core/networking/services/authentication/authentication_provider.dart';
import 'api_service.dart';

class ApiInterceptor extends Interceptor {
  @override
  FutureOr<dynamic> onRequest(
      // ignore: avoid_renaming_method_parameters
      RequestOptions request,
      RequestInterceptorHandler handler) async {
    log('REQUEST[${request.method}] => PATH: ${request.path}');
    log('Autority[${request.method}] => PATH: ${request.headers}');
    print('queryParams${request.queryParameters}');

    final String? accessToken =
        await AuthenticationProvider.authenticationProvider.getAccessToken;

    if (accessToken != null) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }

    log('HEADERS : ${request.headers}');

    return super.onRequest(request, handler);
  }

  @override
  FutureOr<dynamic> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    print('RESPONSE[${response.statusCode}] => BODY: ${response.data}');

    return super.onResponse(response, handler);
  }

  @override
  FutureOr<dynamic> onError(
      DioError err, ErrorInterceptorHandler handler) async {
    log('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');

    if (err.response?.statusCode == 401) {
      if (err.requestOptions.headers['Authorization'] != null) {
        final bool refreshtokenIsUpdated =
            await AuthenticationProvider.authenticationProvider.refreshToken();
        if (refreshtokenIsUpdated) {
          return await _retryRequest(err.requestOptions);
        }
      }
    }

    return super.onError(err, handler);
  }

  Future<dynamic> _retryRequest(RequestOptions requestOptions) async {
    final Options options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return ApiService.create.dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
