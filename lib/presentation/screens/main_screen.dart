import 'package:currency_app/data/source/remote/response/currency_response.dart';
import 'package:currency_app/presentation/bloc/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enums/app_language.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int? expandedIndex;
  AppLanguage selectedLanguage = AppLanguage.uzLatin;
  final TextEditingController _firstInput = TextEditingController();
  final TextEditingController _secondInput = TextEditingController();
  DateTime? _selectedDate;
  bool _isReversed = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc()..add(GetCurrenciesEvent()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(
            appTitle(selectedLanguage),
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => _pickDate(context),
              icon: const Icon(Icons.calendar_month, color: Colors.white),
            ),
            IconButton(
              onPressed: () => {_showLanguageBottomSheet(context)},
              icon: const Icon(Icons.language, color: Colors.white),
            ),
            SizedBox(width: 12),
          ],
        ),
        body: BlocConsumer<MainBloc, MainState>(
          listener: (context, state) {
            if (state.status == Status.fail) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    state.errorMessage ?? 'An error occurred',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
            _selectedDate = null;
          },
          builder: (context, state) {
            if (_selectedDate != null) {
              context.read<MainBloc>().add(
                GetCurrenciesEvent(
                  date:
                      "${_selectedDate?.year}-${_selectedDate?.month.toString().padLeft(2, '0')}-${_selectedDate?.day.toString().padLeft(2, '0')}",
                ),
              );
            }
            switch (state.status) {
              case Status.initial:
              case Status.loading:
                return const Center(child: CircularProgressIndicator());

              case Status.fail:
                return Center(child: Text(state.errorMessage!));

              case Status.success:
                return RefreshIndicator(
                  color: Colors.deepPurple,
                  onRefresh: () async {
                    _selectedDate = null;
                    context.read<MainBloc>().add(GetCurrenciesEvent());
                  },
                  child: ListView.builder(
                    itemCount: state.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final currency = state.data?[index];

                      return Container(
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 1,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: ExpansionTile(
                          initiallyExpanded: expandedIndex == index,
                          title: Row(
                            children: [
                              Text(
                                '${getCurrencyName(currency!)} ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${currency?.diff.toString()}",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          trailing: expandedIndex == index
                              ? Icon(Icons.keyboard_arrow_up, size: 28)
                              : Icon(Icons.keyboard_arrow_down, size: 28),
                          onExpansionChanged: (isExpanded) {
                            setState(() {
                              if (isExpanded) {
                                expandedIndex = index;
                              } else if (expandedIndex == index) {
                                expandedIndex = null;
                              }
                            });
                          },
                          subtitle: Text(
                            "1 ${currency.ccy} => ${currency.rate} UZS | 📆 ${currency.date}",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          children: [
                            Row(
                              children: [
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    showCustomBottomSheet(context, currency);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      bottom: 12,
                                      right: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calculate,
                                          size: 22,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          calculate(selectedLanguage),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );

              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  void showCustomBottomSheet(BuildContext context, CurrencyResponse currency) {
    _firstInput.text = "1";
    _secondInput.text = currency.rate.toString();
    _isReversed = false;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 8,
                  width: 50,
                  margin: EdgeInsets.only(bottom: 16, top: 4),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              Text(
                getCurrencyName(currency),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12),
              Text(
                _isReversed ? "UZS" : currency.ccy.toString(),
                style: TextStyle(color: Colors.black26, fontSize: 18),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 4),
              TextField(
                controller: _firstInput,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  hintText: _isReversed ? "UZS" : currency.ccy.toString(),
                  hintStyle: TextStyle(color: Colors.black26, fontSize: 18),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black26, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black26, width: 2),
                  ),
                ),
                onChanged: (String text) {
                  if (text.isEmpty) {
                    _secondInput.text = "0.0";
                  } else if (_isReversed) {
                    _secondInput.text =
                        (double.parse(text) /
                                double.parse(currency.rate.toString()))
                            .toString();
                  } else {
                    _secondInput.text =
                        (double.parse(text) *
                                double.parse(currency.rate.toString()))
                            .toString();
                  }
                },
              ),
              SizedBox(height: 6),
              Text(
                _isReversed ? currency.ccy.toString() : "UZS",
                style: TextStyle(color: Colors.black26, fontSize: 18),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 4),
              TextField(
                controller: _secondInput,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  hintText: _isReversed ? currency.ccy.toString() : "UZS",
                  hintStyle: TextStyle(color: Colors.black45, fontSize: 18),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black26, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black26, width: 2),
                  ),
                ),
                onChanged: (String text) {
                  if (text.isEmpty) {
                    _firstInput.text = "0.0";
                  } else if (!_isReversed) {
                    _firstInput.text =
                        (double.parse(text) /
                                double.parse(currency.rate.toString()))
                            .toString();
                  } else {
                    _firstInput.text =
                        (double.parse(text) *
                                double.parse(currency.rate.toString()))
                            .toString();
                  }
                },
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      _isReversed = !_isReversed;
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.compare_arrows,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.deepPurple),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    selectLanguage(selectedLanguage),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 12),

                  RadioListTile<AppLanguage>(
                    value: AppLanguage.uzLatin,
                    groupValue: selectedLanguage,
                    activeColor: Colors.deepPurple,
                    title: const Text("O'zbek"),
                    onChanged: (value) {
                      setState(() => selectedLanguage = value!);
                      setModalState(() {});
                      Navigator.pop(context);
                    },
                  ),

                  RadioListTile<AppLanguage>(
                    value: AppLanguage.uzCyrillic,
                    groupValue: selectedLanguage,
                    activeColor: Colors.deepPurple,
                    title: const Text("Ўзбек"),
                    onChanged: (value) {
                      setState(() => selectedLanguage = value!);
                      setModalState(() {});
                      Navigator.pop(context);
                    },
                  ),

                  RadioListTile<AppLanguage>(
                    value: AppLanguage.russian,
                    groupValue: selectedLanguage,
                    activeColor: Colors.deepPurple,
                    title: const Text("Русский"),
                    onChanged: (value) {
                      setState(() => selectedLanguage = value!);
                      setModalState(() {});
                      Navigator.pop(context);
                    },
                  ),

                  RadioListTile<AppLanguage>(
                    value: AppLanguage.english,
                    groupValue: selectedLanguage,
                    activeColor: Colors.deepPurple,
                    title: const Text("English"),
                    onChanged: (value) {
                      setState(() => selectedLanguage = value!);
                      setModalState(() {});
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String getCurrencyName(CurrencyResponse currency) {
    switch (selectedLanguage) {
      case AppLanguage.uzLatin:
        return currency.ccyNmUZ ?? '';

      case AppLanguage.uzCyrillic:
        return currency.ccyNmUZC ?? '';

      case AppLanguage.russian:
        return currency.ccyNmRU ?? '';

      case AppLanguage.english:
        return currency.ccyNmEN ?? '';
    }
  }

  String appTitle(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.uzLatin:
        return "Valyuta";

      case AppLanguage.uzCyrillic:
        return "Валюта";

      case AppLanguage.russian:
        return "Валюта";

      case AppLanguage.english:
        return "Currency";
    }
  }

  String selectLanguage(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.uzLatin:
        return "Tilni tanlang";

      case AppLanguage.uzCyrillic:
        return "Тилни танланг";

      case AppLanguage.russian:
        return "Выберите язык";

      case AppLanguage.english:
        return "Select language";
    }
  }

  String calculate(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.uzLatin:
        return "Hisoblash";

      case AppLanguage.uzCyrillic:
        return "Ҳисоблаш";

      case AppLanguage.russian:
        return "Конвертер";

      case AppLanguage.english:
        return "Convert";
    }
  }
}
