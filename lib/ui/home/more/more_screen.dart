import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../commons/app_commons.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      color: text_color)),
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.only(top: 29),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50)),
                        child: Image.asset('assets/images/Avatar.png')),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Test',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: text_color,
                                fontSize: 14)),
                        Text('Test',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: disable_text_color,
                                fontSize: 12)),
                        const SizedBox(height: 4)
                      ],
                    )
                  ]),
                  Icon(Icons.navigate_next, color: text_color)
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 32),
                child: Column(
                  children: [
                    itemMore(SvgPicture.asset('assets/images/Account.svg'),
                        'Account'),
                    itemMore(
                        SvgPicture.asset('assets/images/Chats.svg'), 'Chats')
                  ],
                )),
            Container(
              margin: const EdgeInsets.only(top: 24),
              child: Column(
                children: [
                  itemMore(SvgPicture.asset('assets/images/Appearence.svg'),
                      'Appearence'),
                  itemMore(SvgPicture.asset('assets/images/Notification.svg'),
                      'Notification'),
                  itemMore(
                      SvgPicture.asset('assets/images/Privacy.svg'), 'Privacy'),
                  itemMore(
                      SvgPicture.asset('assets/images/Data.svg'), 'Data Usage'),
                  Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: const Divider(
                          color: Color.fromRGBO(237, 237, 237, 1),
                          thickness: 1)),
                  itemMore(SvgPicture.asset('assets/images/Help.svg'), 'Help'),
                  itemMore(SvgPicture.asset('assets/images/Invite.svg'),
                      'Invite Your Friends'),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
                      color: text_color))
            ],
          ),
          Icon(Icons.navigate_next, color: text_color)
        ],
      ),
    );
  }
}
