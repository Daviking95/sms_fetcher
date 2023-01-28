part of 'sms_fetch_bloc.dart';

@immutable
abstract class SmsFetchEvent extends Equatable {
  const SmsFetchEvent();

  @override
  List<Object> get props => [];
}

class FetchSmsButtonPressEvent extends SmsFetchEvent {}
