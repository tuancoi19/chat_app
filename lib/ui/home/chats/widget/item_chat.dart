import 'package:chat_app/app_cubit.dart';
import 'package:chat_app/ui/home/chats/widget/item_chat_cubit.dart';
import 'package:chat_app/ui/home/chats/widget/item_chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../commons/app_commons.dart';
import '../../../../functions/database_functions.dart';
import '../../../../models/entities/rooms.dart';
import '../../../../models/entities/users.dart';
import '../../../../models/enums/load_status.dart';
import '../../../personal_chat/personal_chat_cubit.dart';
import '../../../personal_chat/personal_chat_screen.dart';

class ItemChat extends StatefulWidget {
  final Room room;

  const ItemChat({super.key, required this.room});

  @override
  State<StatefulWidget> createState() => _ItemChat();
}

class _ItemChat extends State<ItemChat> {
  late AppCubit appCubit;
  late ItemChatCubit cubit;

  @override
  void initState() {
    super.initState();
    appCubit = BlocProvider.of(context);
    cubit = BlocProvider.of(context);
    cubit.getLatestMessage(
        widget.room.roomID, appCubit.state.user!.phoneNumber!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserChat?>(
        future: DatabaseFunctions().getUserProfile(widget.room.listMembers
            .singleWhere(
                (element) => element != appCubit.state.user!.phoneNumber)),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => PersonalChatCubit(),
                      child: PersonalChatScreen(guest: snapshot.data!),
                    ),
                  ),
                );
              },
              child: Container(
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
                          child: snapshot.data!.avatarURL!.isNotEmpty
                              ? Image.network(snapshot.data!.avatarURL!,
                                  fit: BoxFit.cover)
                              : Image.asset('assets/images/Avatar.png',
                                  fit: BoxFit.cover),
                        )),
                      ),
                      Container(
                        height: 14,
                        width: 14,
                        margin: const EdgeInsets.only(
                            top: 2, left: 38, right: 2, bottom: 38),
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(90),
                            color: const Color.fromRGBO(44, 192, 105, 1)),
                      )
                    ]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 64,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      '${snapshot.data!.name.firstName} ${snapshot.data!.name.lastName}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: textColor)),
                                )),
                                Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      (DateTime.fromMicrosecondsSinceEpoch(widget
                                                          .room
                                                          .updatedTime
                                                          .microsecondsSinceEpoch)
                                                      .day ==
                                                  DateTime.now().day &&
                                              DateTime.fromMicrosecondsSinceEpoch(widget
                                                          .room
                                                          .updatedTime
                                                          .microsecondsSinceEpoch)
                                                      .month ==
                                                  DateTime.now().month &&
                                              DateTime.fromMicrosecondsSinceEpoch(widget
                                                          .room
                                                          .updatedTime
                                                          .microsecondsSinceEpoch)
                                                      .year ==
                                                  DateTime.now().year)
                                          ? 'Today'
                                          : DateFormat('d/M').format(
                                              DateTime.fromMicrosecondsSinceEpoch(widget.room.updatedTime.microsecondsSinceEpoch)),
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromRGBO(173, 181, 189, 1)),
                                    ))
                              ],
                            ),
                            BlocBuilder<ItemChatCubit, ItemChatState>(
                                builder: (context, state) {
                              if (state.fetchDataStatus == LoadStatus.success) {
                                return Row(children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        state.message!.content!.isNotEmpty
                                            ? state.message!.content!
                                            : 'Sent an attachment 📎',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: disableTextColor),
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   height: 20,
                                  //   width: 22,
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(40),
                                  //       color: const Color.fromRGBO(
                                  //           210, 213, 249, 1)),
                                  //   child: const Center(
                                  //        child: Text('1',
                                  //            style: TextStyle(
                                  //                fontWeight: FontWeight.w600,
                                  //                fontSize: 10,
                                  //                color: Color.fromRGBO(
                                  //                    0, 26, 131, 1))))
                                  // ),
                                ]);
                              } else {
                                return const SizedBox();
                              }
                            }),
                            const SizedBox(height: 10)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
