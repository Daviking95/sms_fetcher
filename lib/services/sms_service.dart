import 'package:dartz/dartz.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:sms_fetcher/model/ErrorResponse.dart';

import '../utils.dart';

abstract class SmsService {
  Future<Either<ErrorResponse, List<SmsMessage>>> fetchSmsFromDevice();
}

class SmsRepository extends SmsService {
  @override
  Future<Either<ErrorResponse, List<SmsMessage>>> fetchSmsFromDevice() async {
    try {
      List<SmsMessage> messages = await AppUtils.query.getAllSms;

      return Right(messages);
    } catch (e) {
      return Left(
          ErrorResponse(errorMessage: 'No data found', statusCode: 404));
      throw Exception();
    }
  }
}
