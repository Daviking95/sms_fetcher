import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:sms_fetcher/utils.dart';

class StarterFunctions {
  static setupFunctions() async {
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: await getApplicationDocumentsDirectory());

    AppUtils.query = SmsQuery();
  }
}
