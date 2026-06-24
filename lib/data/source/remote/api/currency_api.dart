import 'package:currency_app/data/source/remote/response/currency_response.dart';
import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

class CurrencyApi {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://cbu.uz/uz/arkhiv-kursov-valyut/json/',
      receiveDataWhenStatusError: true,
      receiveTimeout: Duration(seconds: 30),
      sendTimeout: Duration(seconds: 30),
      connectTimeout: Duration(seconds: 30),
      contentType: 'application/json',
    ))..interceptors.add(
    TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(
        printResponseData: true,
        printRequestData: false,
        printResponseHeaders: true,
        printRequestHeaders: true,
      ),
    ),
  );

  Future<List<CurrencyResponse>> getCurrencies() async {
    try {
      final response = await dio.get("");
      return (response.data as List)
          .map((e) => CurrencyResponse.fromJson(e))
          .toList();
    } on DioException {
      rethrow;
    }
  }
  Future<List<CurrencyResponse>> getCurrenciesByDate(String date) async {
    print("AAA");
    try {
      final response = await dio.get("all/${date}");
      return (response.data as List)
          .map((e) => CurrencyResponse.fromJson(e))
          .toList();
    } on DioException {
      rethrow;
    }
  }
}
