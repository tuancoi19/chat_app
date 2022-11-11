import 'package:chat_app/app_cubit.dart';
import 'package:chat_app/functions/database_functions.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/ui/home/more/more_cubit.dart';
import 'package:chat_app/ui/home/more/more_state.dart';
import 'package:chat_app/ui/walkthrough_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../commons/app_commons.dart';
import '../../../models/enums/load_status.dart';
import '../../profile_account/profile_account_cubit.dart';
import '../../profile_account/profile_account_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MoreScreen();
}

class _MoreScreen extends State<MoreScreen> {
  late MoreCubit cubit;
  late AppCubit appCubit;

  @override
  void initState() {
    super.initState();
    appCubit = BlocProvider.of<AppCubit>(context);
    cubit = BlocProvider.of<MoreCubit>(context);
    cubit.getUser(appCubit.state.user!.phoneNumber!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoreCubit, MoreState>(
        bloc: cubit,
        builder: (context, state) {
          if (state.fetchDataStatus == LoadStatus.success) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 59, left: 8, right: 8),
                      child: Text('More',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: textColor)),
                    ),
                    Container(
                        height: 50,
                        margin: const EdgeInsets.only(top: 29),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                              create: (context) =>
                                                  ProfileAccountCubit(),
                                              child: const ProfileAccountScreen(
                                                  isInSetting: true))));
                                },
                                child: Row(children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: state.avatarURL!.isEmpty
                                          ? Image.asset(
                                              'assets/images/Avatar.png')
                                          : Image.network(
                                              state.avatarURL!,
                                              fit: BoxFit.cover,
                                            )),
                                  const SizedBox(width: 20),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(state.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: textColor,
                                              fontSize: 14)),
                                      Text(appCubit.state.user!.phoneNumber!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: disableTextColor,
                                              fontSize: 12)),
                                      const SizedBox(height: 4)
                                    ],
                                  )
                                ])),
                            GestureDetector(
                              child:
                                  Icon(Icons.navigate_next, color: textColor),
                              onTap: () {
                                signOutDialog(context, appCubit);
                              },
                            ),
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.only(top: 32),
                        child: Column(
                          children: [
                            itemMore(
                                SvgPicture.asset('assets/images/Account.svg'),
                                'Account'),
                            itemMore(
                                SvgPicture.asset('assets/images/Chats.svg'),
                                'Chats')
                          ],
                        )),
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      child: Column(
                        children: [
                          itemMore(
                              SvgPicture.asset('assets/images/Appearence.svg'),
                              'Appearence'),
                          itemMore(
                              SvgPicture.asset(
                                  'assets/images/Notification.svg'),
                              'Notification'),
                          itemMore(
                              SvgPicture.asset('assets/images/Privacy.svg'),
                              'Privacy'),
                          itemMore(SvgPicture.asset('assets/images/Data.svg'),
                              'Data Usage'),
                          Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: const Divider(
                                  color: Color.fromRGBO(237, 237, 237, 1),
                                  thickness: 1)),
                          itemMore(SvgPicture.asset('assets/images/Help.svg'),
                              'Help'),
                          itemMore(SvgPicture.asset('assets/images/Invite.svg'),
                              'Invite Your Friends'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget itemMore(SvgPicture pic, String text) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              pic,
              const SizedBox(width: 6),
              Text(text,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: textColor))
            ],
          ),
          Icon(Icons.navigate_next, color: textColor)
        ],
      ),
    );
  }
}

Future signOutDialog(BuildContext context, AppCubit appCubit) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Sign Out'),
            content: const Text('Do you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () async {
                  await DatabaseFunctions().updateUserProfile(
                      'isActive', false, appCubit.state.user!.phoneNumber!);
                  await AuthRepository().signOut().then((value) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WalkthroughScreen()),
                        (route) => false);
                  });
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
            ],
          ));
}
