import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/sms_service.dart';

var repositoryProviders = [
  RepositoryProvider<SmsService>(
    create: (context) => SmsRepository(),
  ),
];
