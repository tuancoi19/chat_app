import 'package:chat_app/ui/walkthrough_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_cubit.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData.light().copyWith(
              textTheme:
                  ThemeData.light().textTheme.apply(fontFamily: 'Mulish'),
              primaryColor: Colors.white),
          // darkTheme: ThemeData.dark().copyWith(
          //     textTheme:
          //         ThemeData.light().textTheme.apply(fontFamily: 'Mulish'),
          //     primaryColor: const Color.fromRGBO(15, 24, 40, 1)),
          home: const WalkthroughScreen()),
    );
  }
}
