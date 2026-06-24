class CurrencyResponse {
  int? id;
  String? code;
  String? ccy;
  String? ccyNmRU;
  String? ccyNmUZ;
  String? ccyNmUZC;
  String? ccyNmEN;
  String? nominal;
  String? rate;
  String? diff;
  String? date;

  CurrencyResponse(
      {this.id,
        this.code,
        this.ccy,
        this.ccyNmRU,
        this.ccyNmUZ,
        this.ccyNmUZC,
        this.ccyNmEN,
        this.nominal,
        this.rate,
        this.diff,
        this.date});

  CurrencyResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['Code'];
    ccy = json['Ccy'];
    ccyNmRU = json['CcyNm_RU'];
    ccyNmUZ = json['CcyNm_UZ'];
    ccyNmUZC = json['CcyNm_UZC'];
    ccyNmEN = json['CcyNm_EN'];
    nominal = json['Nominal'];
    rate = json['Rate'];
    diff = json['Diff'];
    date = json['Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Code'] = code;
    data['Ccy'] = ccy;
    data['CcyNm_RU'] = ccyNmRU;
    data['CcyNm_UZ'] = ccyNmUZ;
    data['CcyNm_UZC'] = ccyNmUZC;
    data['CcyNm_EN'] = ccyNmEN;
    data['Nominal'] = nominal;
    data['Rate'] = rate;
    data['Diff'] = diff;
    data['Date'] = date;
    return data;
  }
}
