import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sms_advanced/sms_advanced.dart';

import '../model/ErrorResponse.dart';
import '../services/sms_service.dart';

part 'sms_fetch_event.dart';
part 'sms_fetch_state.dart';

class SmsFetchBloc extends Bloc<SmsFetchEvent, SmsFetchState> {
  final SmsService _smsService;

  SmsFetchBloc(SmsService smsService)
      : _smsService = smsService,
        super(SmsFetchInitial()) {
    _mapEventToState();
  }

  _mapEventToState() async {
    on<FetchSmsButtonPressEvent>((event, emit) async {
      await fetchSmsButtonPress(event, emit);
    });
  }

  fetchSmsButtonPress(
      FetchSmsButtonPressEvent event, Emitter<SmsFetchState> emit) async {
    emit(SmsFetchLoadingState());

    try {
      final Either<ErrorResponse, List<SmsMessage>> serverResponse =
          await _smsService.fetchSmsFromDevice();

      return serverResponse.fold((errorResponseModel) {
        emit(SmsFetchFailureState(errorResponseModel));
      }, (smsfetchResponseModel) {
        emit(SmsFetchSuccessState(smsfetchResponseModel));
      });
    } catch (e) {
      emit(SmsFetchFailureState(
          ErrorResponse(errorMessage: "No data found", statusCode: 404)));
    }
  }
}
