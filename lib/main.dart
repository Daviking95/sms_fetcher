import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_fetcher/bloc/sms_fetch_bloc.dart';
import 'package:sms_fetcher/services/sms_service.dart';
import 'package:sms_fetcher/view/sms_fetcher_screen.dart';

import 'core/app_functions.dart';
import 'core/repository_provider.dart';

void main() async {
  await StarterFunctions.setupFunctions();

  runApp(MultiRepositoryProvider(
    providers: repositoryProviders,
    child: MultiBlocProvider(providers: [
      BlocProvider<SmsFetchBloc>(
        create: (context) =>
            SmsFetchBloc(RepositoryProvider.of<SmsService>(context)),
        child: SmsFetcherScreen(title: "Messages"),
      )
    ], child: const MyApp()),
  ));
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sms Fetcher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SmsFetcherScreen(title: "Messages"),
    );
  }
}
