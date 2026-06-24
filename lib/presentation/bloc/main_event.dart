part of 'main_bloc.dart';

abstract class MainEvent{}

class GetCurrenciesEvent extends MainEvent{
  final String? date;

  GetCurrenciesEvent({this.date});
}