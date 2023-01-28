class SmsResponseModel {
  SmsResponseModel({
    required this.smsProvider,
    required this.amount,
    required this.date,
    required this.message,
  });

  SmsResponseModel.fromJson(dynamic json) {
    smsProvider = json['sms_provider'];
    amount = json['amount'];
    date = json['date'];
    message = json['message'];
  }
  String? smsProvider;
  double? amount;
  String? date;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sms_provider'] = smsProvider;
    map['amount'] = amount;
    map['date'] = date;
    map['message'] = message;
    return map;
  }
}
