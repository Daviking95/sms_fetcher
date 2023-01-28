class ErrorResponse {
  ErrorResponse({
    required this.errorMessage,
    required this.statusCode,
  });

  ErrorResponse.fromJson(dynamic json) {
    errorMessage = json['error_message'];
    statusCode = json['status_code'];
  }
  String? errorMessage;
  int? statusCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error_message'] = errorMessage;
    map['status_code'] = statusCode;
    return map;
  }
}
