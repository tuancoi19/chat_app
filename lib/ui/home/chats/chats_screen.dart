import 'package:chat_app/app_cubit.dart';
import 'package:chat_app/commons/app_commons.dart';
import 'package:chat_app/functions/database_functions.dart';
import 'package:chat_app/models/entities/messages.dart';
import 'package:chat_app/models/entities/users.dart';
import 'package:chat_app/ui/home/chats/chats_cubit.dart';
import 'package:chat_app/ui/home/chats/chats_state.dart';
import 'package:chat_app/ui/home/chats/widget/item_chat.dart';
import 'package:chat_app/ui/home/chats/widget/item_chat_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:intl/intl.dart';

import '../../../models/entities/rooms.dart';
import '../../personal_chat/personal_chat_cubit.dart';
import '../../personal_chat/personal_chat_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChatsScreen();
}

class _ChatsScreen extends State<ChatsScreen> {
  late ChatsCubit cubit;
  late AppCubit appCubit;
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    controller = TextEditingController();
    appCubit = BlocProvider.of<AppCubit>(context);
    cubit = BlocProvider.of<ChatsCubit>(context);
    cubit.getListRoom(appCubit.state.user!.phoneNumber!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusNode.unfocus(),
      child: BlocBuilder<ChatsCubit, ChatsState>(
          bloc: cubit,
          builder: (context, state) {
            return Scaffold(
              body: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 47),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: disableTextColor))),
                    child: Container(
                      margin: const EdgeInsets.only(left: 24, right: 24),
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text('Chats',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: textColor)),
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/images/Vector.svg',
                                            color: textColor),
                                        const SizedBox(width: 8),
                                        IconButton(
                                            icon: Icon(
                                              Icons.playlist_add_check,
                                              color: textColor,
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
                                      margin: const EdgeInsets.only(
                                          top: 16, bottom: 16),
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
                                                    color: textColor))
                                          ]));
                                } else {
                                  return itemStory();
                                }
                              },
                              itemCount: 1,
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
                                  color: boxColor),
                              child: TextField(
                                onChanged: (value) async {
                                  List<UserChat>? listSearch =
                                      await DatabaseFunctions().getAllUser(
                                          appCubit.state.user!.phoneNumber!);
                                  List<UserChat> listResult;
                                  if (value.isEmpty) {
                                    cubit.getUserChat(
                                        appCubit.state.user!.phoneNumber!);
                                    listResult = state.listUserChat;
                                  } else {
                                    if (value[0] == '+') {
                                      listResult = listSearch!
                                          .where((element) => element
                                              .phoneNumber
                                              .contains(value))
                                          .toList();
                                    } else {
                                      listResult = listSearch!
                                          .where((element) =>
                                              ('${element.name.firstName} ${element.name.lastName}')
                                                  .toLowerCase()
                                                  .contains(
                                                      value.toLowerCase()))
                                          .toList();
                                    }
                                  }
                                  cubit.changeListUserChat(
                                      listUserChat: listResult);
                                },
                                controller: controller,
                                maxLines: 1,
                                textInputAction: TextInputAction.search,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search,
                                        color: disableTextColor),
                                    border: InputBorder.none,
                                    hintText: 'Placeholder',
                                    hintStyle: TextStyle(
                                        color: disableTextColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                              )),
                          Expanded(
                              child: controller.text.isNotEmpty
                                  ? ListView.builder(
                                      itemBuilder: (context, index) {
                                        return itemUserChat(
                                            state.listUserChat[index]);
                                      },
                                      itemCount: state.listUserChat.length,
                                    )
                                  : state.listRoom.isNotEmpty
                                      ? ListView.builder(
                                          itemBuilder: (context, index) {
                                            return BlocProvider(
                                              key: Key(index.toString()),
                                              create: (context) =>
                                                  ItemChatCubit(),
                                              child: ItemChat(
                                                  room: state.listRoom[index]),
                                            );
                                          },
                                          itemCount: state.listRoom.length)
                                      : const SizedBox()),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
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
                  fontWeight: FontWeight.w400, fontSize: 10, color: textColor))
        ],
      ),
    );
  }

  Widget itemUserChat(UserChat? item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => PersonalChatCubit(),
              child: PersonalChatScreen(guest: item),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: disableTextColor))),
        width: 327,
        height: 68,
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Stack(children: [
              Container(
                width: 56,
                height: 56,
                decoration: item!.storyURL!.isNotEmpty
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: const GradientBoxBorder(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromRGBO(210, 213, 249, 1),
                                  Color.fromRGBO(44, 55, 225, 1)
                                ]),
                            width: 2))
                    : null,
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: item.avatarURL!.isEmpty
                        ? Image.asset('assets/images/Avatar.png',
                            fit: BoxFit.contain)
                        : Image.network(item.avatarURL!, fit: BoxFit.contain),
                  )),
                ),
              ),
              item.isActive == true
                  ? Container(
                      height: 14,
                      width: 14,
                      margin: const EdgeInsets.only(
                          left: 38, bottom: 38, right: 2, top: 2),
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.circular(90),
                          color: const Color.fromRGBO(44, 192, 105, 1)),
                    )
                  : const SizedBox()
            ]),
            const SizedBox(width: 12),
            SizedBox(
              height: 56,
              width: 259,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('${item.name.firstName} ${item.name.lastName}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: textColor)),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.isActive == true ? 'Online' : 'Offline',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: disableTextColor),
                    ),
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
