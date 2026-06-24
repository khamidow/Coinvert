import 'package:bloc/bloc.dart';
import 'package:currency_app/data/repository/currency_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../data/source/remote/response/currency_response.dart';

part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState(status: Status.initial)) {
    final repository = CurrencyRepositoryImpl();

    on<GetCurrenciesEvent>((event, emit) async {
      emit(state.copyWith(status: Status.loading));
      try {
        if (event.date == null) {
          final currencies = await repository.getCurrency();
          emit(state.copyWith(status: Status.success, data: currencies));
        }else{
          print("BBB");
          final currencies = await repository.getCurrencyByDate(event.date.toString());
          emit(state.copyWith(status: Status.success, data: currencies));
        }
      } on DioException catch (e) {
        emit(
          state.copyWith(
            status: Status.fail,
            errorMessage: e.response?.data['message'] ?? 'unknown error',
          ),
        );
      }
    });
  }
}
