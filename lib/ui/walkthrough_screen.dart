import 'package:chat_app/app_cubit.dart';
import 'package:chat_app/ui/verification/verification_cubit.dart';
import 'package:chat_app/ui/verification/verification_screen_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WalkthroughScreen extends StatefulWidget {
  const WalkthroughScreen({super.key});

  @override
  State<WalkthroughScreen> createState() => _WalkthroughScreen();
}

class _WalkthroughScreen extends State<WalkthroughScreen> {
  late AppCubit appCubit;

  @override
  void initState() {
    super.initState();
    appCubit = BlocProvider.of<AppCubit>(context);
    appCubit.loadUserStatus(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 102),
                child: SvgPicture.asset('assets/images/Illustration.svg',
                    height: 271, width: 262)),
            Container(
                width: 280,
                height: 90,
                margin: const EdgeInsets.only(top: 42),
                child: const Text(
                    'Connect easily with your family and friends over countries',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Color.fromRGBO(15, 24, 40, 1)),
                    textAlign: TextAlign.center)),
            Container(
              margin: const EdgeInsets.only(top: 100),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Terms & Privacy Policy',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color.fromRGBO(15, 24, 40, 1)),
                ),
              ),
            ),
            Container(
              height: 52,
              width: 327,
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlocProvider(
                              create: (context) {
                                final appCubit =
                                    RepositoryProvider.of<AppCubit>(context);
                                return SignInCubit(appCubit: appCubit);
                              },
                              child: const VerificationScreen1())));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 45, 227, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: const Text('Start Messaging',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              ),
            )
          ],
        )));
  }
}
