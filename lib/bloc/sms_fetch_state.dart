part of 'sms_fetch_bloc.dart';

@immutable
abstract class SmsFetchState {}

class SmsFetchInitial extends SmsFetchState {}

class SmsFetchLoadingState extends SmsFetchState {}

class SmsFetchSuccessState extends SmsFetchState {
  List<SmsMessage> signupResponseModel;

  SmsFetchSuccessState(this.signupResponseModel);

  @override
  List<Object> get props => [signupResponseModel];
}

class SmsFetchFailureState extends SmsFetchState {
  final ErrorResponse errorResponseModel;

  SmsFetchFailureState(this.errorResponseModel);

  @override
  List<Object> get props => [errorResponseModel];
}
