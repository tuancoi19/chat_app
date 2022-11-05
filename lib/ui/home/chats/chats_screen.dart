import 'package:chat_app/commons/app_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 47),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: disable_text_color))),
            child: Container(
              margin: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.only(bottom: 13),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text('Chats',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: text_color)),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset('assets/images/Vector.svg',
                                    color: text_color),
                                const SizedBox(width: 8),
                                IconButton(
                                    icon: Icon(
                                      Icons.playlist_add_check,
                                      color: text_color,
                                    ),
                                    onPressed: null),
                              ],
                            ),
                          ])),
                  SizedBox(
                    height: 108,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Container(
                              width: 56,
                              height: 76,
                              margin:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 56,
                                      height: 56,
                                      child: SvgPicture.asset(
                                          'assets/images/AvatarStory.svg'),
                                    ),
                                    Text('Your Story',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10,
                                            color: text_color))
                                  ]));
                        } else {
                          return itemStory();
                        }
                      },
                      itemCount: 4,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: box_color),
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                            prefixIcon:
                                Icon(Icons.search, color: disable_text_color),
                            border: InputBorder.none,
                            hintText: 'Placeholder',
                            hintStyle: TextStyle(
                                color: disable_text_color,
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                      )),
                  Expanded(
                    child: ListView.builder(
                        itemBuilder: (context, index) {
                          return itemChat();
                        },
                        itemCount: 3),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  itemStory() {
    return Container(
      width: 56,
      height: 76,
      margin: const EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: const GradientBoxBorder(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(210, 213, 249, 1),
                          Color.fromRGBO(44, 55, 225, 1)
                        ]),
                    width: 2)),
            child: Center(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset('assets/images/lion.jpg',
                  height: 48, width: 48, fit: BoxFit.contain),
            )),
          ),
          Text('Lion',
              style: TextStyle(
                  fontWeight: FontWeight.w400, fontSize: 10, color: text_color))
        ],
      ),
    );
  }

  Widget itemChat() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Stack(children: [
            SizedBox(
              width: 56,
              height: 56,
              child: Center(
                  child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset('assets/images/lion.jpg',
                    height: 48, width: 48, fit: BoxFit.contain),
              )),
            ),
            Container(
              height: 14,
              width: 14,
              margin:
                  const EdgeInsets.only(top: 2, left: 38, right: 2, bottom: 38),
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white),
                  borderRadius: BorderRadius.circular(90),
                  color: const Color.fromRGBO(44, 192, 105, 1)),
            )
          ]),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 56,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text('Lion',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: text_color)),
                      )),
                      Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            'Today',
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(173, 181, 189, 1)),
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Online',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: disable_text_color),
                          ),
                        ),
                      ),
                      Container(
                          height: 20,
                          width: 22,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: const Color.fromRGBO(210, 213, 249, 1)),
                          child: Center(
                              child: Text('1',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                      color: Color.fromRGBO(0, 26, 131, 1))))),
                    ],
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
