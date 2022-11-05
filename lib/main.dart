import 'package:chat_app/app_cubit.dart';
import 'package:chat_app/ui/personal_chat/personal_chat_screen.dart';
import 'package:chat_app/ui/test.dart';
import 'package:chat_app/ui/walkthrough_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          darkTheme: ThemeData.dark().copyWith(
              textTheme:
                  ThemeData.light().textTheme.apply(fontFamily: 'Mulish'),
              primaryColor: const Color.fromRGBO(15, 24, 40, 1)),
          home: WalkthroughScreen()),
    );
  }
}
