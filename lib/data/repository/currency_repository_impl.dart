import 'package:currency_app/data/source/remote/api/currency_api.dart';
import 'package:currency_app/data/source/remote/response/currency_response.dart';
import 'package:currency_app/domain/repository/currency_repository.dart';
import 'package:dio/dio.dart';

class CurrencyRepositoryImpl extends CurrencyRepository {
  final currencyApi = CurrencyApi();

  @override
  Future<List<CurrencyResponse>> getCurrency() async {
    try {
      return await currencyApi.getCurrencies();
    } on DioException {
      rethrow;
    }
  }
  @override
  Future<List<CurrencyResponse>> getCurrencyByDate(String date) async {
    try {
      return await currencyApi.getCurrenciesByDate(date);
    } on DioException {
      rethrow;
    }
  }
}
