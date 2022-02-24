import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:es_2022_02_02_1/api_models/get/get_authorities_model.dart';
import 'package:es_2022_02_02_1/api_models/get/get_helpDesk_model.dart';
import 'package:es_2022_02_02_1/api_models/get/get_user_logged.dart';
import 'package:es_2022_02_02_1/core/networking/services/authentication/login_configuration.dart';

import 'package:tuple/tuple.dart';

import 'api_interceptor.dart';

class ApiService {
  static final ApiService create = ApiService();
  final ApiInterceptor _interceptor = ApiInterceptor();

  // inizialization

  final String _baseUrl = LoginConfigurations().getBaseUrl;

  // final String _placenameBaseUrl =
  //     "https://api-$porticiApiWorkEnvironmentName.smartpa.cloud/placename";

  Dio _dio = Dio();

  Dio get dio => _dio;
  // end inizialization

  int? _authorityId;

  int? get authorityId => _authorityId;
  void setAuthorityId(int authorityId) {
    _authorityId = authorityId;
    _options = authorityId != null
        ? Options(headers: {'AuthorityId': authorityId})
        : Options();
  }

  late Options _options;

  ApiService() {
    _options = authorityId != null
        ? Options(headers: {'AuthorityId': authorityId})
        : Options();

    _dio..interceptors.add(_interceptor);
  }

  //----------------------- GET ----------------

  Future<Tuple2<int?, UserLogged?>> profiles(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get<dynamic>(
        '$_baseUrl/v1/profiles',
        queryParameters: queryParameters,
        options: _options,
      );

      if (response.data != null) {
        final userLogged = UserLogged.fromJson(response.data);
        return Tuple2<int?, UserLogged?>(response.statusCode, userLogged);
      } else {
        throw Exception('la richiesta non ha prodotto risultati');
      }
    } on DioError catch (e) {
      log('ERRORE GET myProfile : ' + e.response!.statusCode!.toString());
      return Tuple2<int?, UserLogged?>(e.response!.statusCode!, null);
    }
  }

  // Future<Tuple2<int?, List<int>>> authorities(
  //     {Map<String, dynamic>? queryParameters}) async {
  //   try {
  //     final response = await dio.get<List<dynamic>>(
  //       '$_baseUrl/v1/profiles/authorities',
  //       queryParameters: queryParameters,
  //     );

  //     if (response.data != null) {
  //       final List<int> authoritis =
  //           response.data!.map((e) => e as int).toList();
  //       return Tuple2<int?, List<int>>(response.statusCode, authoritis);
  //     } else {
  //       throw Exception('la richiesta non ha prodotto risultati');
  //     }
  //   } on DioError catch (e) {
  //     log('ERRORE GET authorities : ' + e.response!.statusCode!.toString());
  //     return Tuple2<int?, List<int>>(e.response!.statusCode!, []);
  //   }
  // }

  Future<Tuple2<int?, List<Authority>>> authorities(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get<dynamic>(
        '$_baseUrl/v1/profiles/authorities',
        queryParameters: queryParameters,
      );

      if (response.data != null) {
        final listauthorities = List<dynamic>.from(response.data);

        final authorities =
            listauthorities.map((e) => Authority.fromJson(e)).toList();
        return Tuple2<int?, List<Authority>>(response.statusCode, authorities);
      } else {
        throw Exception('la richiesta non ha prodotto risultati');
      }
    } on DioError catch (e) {
      log('ERRORE GET myProfile : ' + e.response!.statusCode!.toString());
      return Tuple2<int?, List<Authority>>(e.response!.statusCode!, []);
    }
  }

  Future<Tuple2<int?, HelpDeskList?>> getHelpDesk(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get<dynamic>(
        '$_baseUrl/v1/helpdesk',
        queryParameters: queryParameters,
        options: _options,
      );
      final HelpDeskList data = HelpDeskList.fromJson(response.data);

      return Tuple2(response.statusCode, data);
    } on DioError catch (e) {
      log('ERRORE getHelpDesk : ' + e.toString());
      return Tuple2(e.response?.statusCode, null);
    }
  }

  Future<dynamic> getHelpDeskById(int helpDeskId,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get<dynamic>(
        '$_baseUrl/v1/helpdesk/$helpDeskId',
        queryParameters: queryParameters,
        options: _options,
      );

      return response.data;
    } catch (e) {
      log('ERRORE getHelpDeskById : ' + e.toString());
      return null;
    }
  }

  Future<Tuple2<String?, int>> postHelpDesk(Map<String, dynamic> data,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.post<dynamic>(
        '$_baseUrl/v1/helpdesk',
        data: data,
        queryParameters: queryParameters,
        options: _options,
      );

      return Tuple2<String, int>(
          response.data.toString(), response.statusCode!);
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        final errors = e.response!.data;

        final Map<String, dynamic> errorsJson = errors;

        final List<dynamic> error = errorsJson['errors'];

        return Tuple2<String, int>(error.first, e.response!.statusCode!);
      } else {
        return Tuple2<String?, int>(null, e.response!.statusCode!);
      }
    }
  }

  Future<Tuple2<String?, int>> putHelpDesk(int helpDeskId, dynamic data,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.put<dynamic>(
        '$_baseUrl/v1/helpdesk/$helpDeskId',
        queryParameters: queryParameters,
        options: _options,
        data: data,
      );

      return Tuple2<String, int>(
          response.data.toString(), response.statusCode!);
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        final errors = e.response!.data;

        final Map<String, dynamic> errorsJson = errors;

        final List<dynamic> error = errorsJson['errors'];

        return Tuple2<String, int>(error.first, e.response!.statusCode!);
      } else {
        return Tuple2<String?, int>(null, e.response!.statusCode!);
      }
    }
  }

  Future<dynamic> deleteHelpDeskById(int helpDeskId,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.delete<dynamic>(
        '$_baseUrl/v1/helpdesk/$helpDeskId',
        queryParameters: queryParameters,
        options: _options,
      );
    } on DioError catch (e) {
      log('deleteHelpDeskById : ' + e.toString());
      return null;
    }
  }

  Future<dynamic> getAddressAutocomplete(
      {required String search, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get<dynamic>(
        "https://api-dev.smartpa.cloud/placename/v1/PlaceName/addresses/numbers/autocomplete?authorityId=$authorityId&addressFullTextSearch=$search&maxItemsToView=200",
        queryParameters: queryParameters,
        options: _options,
      );

      return response.data;
    } catch (e) {
      log('ERRORE GET getAutocompleteTest : ' + e.toString());
      return null;
    }
  }
}
