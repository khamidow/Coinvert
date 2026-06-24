part of 'main_bloc.dart';

class MainState {
  final Status? status;
  final List<CurrencyResponse>? data;
  final String? errorMessage;

  MainState({this.status,  this.data,  this.errorMessage});

  MainState copyWith({
    Status? status,
    List<CurrencyResponse>? data,
    String? errorMessage,
  }) {
    return MainState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }
}

enum Status{initial,loading,success,fail}
