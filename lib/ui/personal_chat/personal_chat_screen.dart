import 'dart:io';

import 'package:chat_app/app_cubit.dart';
import 'package:chat_app/functions/upload.dart';
import 'package:chat_app/models/entities/users.dart';
import 'package:chat_app/models/enums/load_status.dart';
import 'package:chat_app/ui/personal_chat/personal_chat_cubit.dart';
import 'package:chat_app/ui/personal_chat/personal_chat_state.dart';
import 'package:chat_app/ui/personal_chat/widget/message_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../commons/app_commons.dart';
import '../../functions/database_functions.dart';
import '../../functions/show_picker.dart';
import '../../models/entities/rooms.dart';

class PersonalChatScreen extends StatelessWidget {
  final UserChat guest;
  const PersonalChatScreen({super.key, required this.guest});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonalChatCubit(),
      child: PersonalChatChildScreen(guest: guest),
    );
  }
}

class PersonalChatChildScreen extends StatefulWidget {
  final UserChat guest;
  const PersonalChatChildScreen({super.key, required this.guest});

  @override
  State<StatefulWidget> createState() => _PersonalChatChildScreen();
}

class _PersonalChatChildScreen extends State<PersonalChatChildScreen> {
  late TextEditingController controller;
  late FocusNode focusNode;
  late bool isDisable;
  late PersonalChatCubit cubit;
  late AppCubit appCubit;
  late Room data;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    controller = TextEditingController();
    isDisable = true;
    appCubit = BlocProvider.of<AppCubit>(context);
    cubit = BlocProvider.of<PersonalChatCubit>(context);
    cubit.changeName(
        name: '${widget.guest.name.firstName} ${widget.guest.name.lastName}');

    cubit.fetchMessages(
        widget.guest.phoneNumber, appCubit.state.user!.phoneNumber!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusNode.unfocus(),
      child: BlocBuilder<PersonalChatCubit, PersonalChatState>(
          bloc: cubit,
          builder: (context, state) {
            if (state.fetchDataStatus == LoadStatus.success) {
              return Scaffold(
                  body: Container(
                      margin: const EdgeInsets.only(top: 47),
                      child: Column(children: [
                        Container(
                          margin: const EdgeInsets.only(left: 16, right: 16),
                          padding: const EdgeInsets.only(bottom: 13),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    focusNode.unfocus();
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.navigate_before)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(state.name!,
                                    style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18)),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () {},
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: IconButton(
                                  icon: const Icon(Icons.menu),
                                  onPressed: () {},
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: Container(
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(237, 237, 237, 1)),
                          child: state.messages!.isNotEmpty
                              ? ListView.builder(
                                  key: Key('${DateTime.now()}'),
                                  itemBuilder: (context, index) {
                                    return itemMessage(
                                        state.messages![index],
                                        appCubit.state.user!.phoneNumber!,
                                        '${widget.guest.name.firstName} ${widget.guest.name.lastName}',
                                        context,
                                        focusNode,
                                        state.room!,
                                        widget.guest.phoneNumber,
                                        index,
                                        state.messages);
                                  },
                                  itemCount: state.messages!.length,
                                  reverse: true,
                                )
                              : const SizedBox(),
                        )),
                        Container(
                            margin: const EdgeInsets.only(left: 12, right: 12),
                            child: Column(
                              children: [
                                state.isReply == true
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                            replyChatForm(
                                                state.replyMessage!,
                                                appCubit
                                                    .state.user!.phoneNumber!,
                                                state.name!),
                                            IconButton(
                                                onPressed: () {
                                                  cubit.changeisReply(
                                                      isReply: false);
                                                  cubit.changeReplyMessage(
                                                      replyMessage: null);
                                                },
                                                icon: const Icon(Icons.cancel))
                                          ])
                                    : const SizedBox(),
                                StatefulBuilder(builder: (context, setState) {
                                  return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              XFile ivfile;
                                              File afFile;
                                              String path = '';
                                              Map result;
                                              Map<String, dynamic> detail =
                                                  await chooseAttachment(
                                                      context);
                                              if (detail['type'] == 'Image') {
                                                ivfile = await showImagePicker(
                                                    detail['source']);
                                                path =
                                                    await uploadImage(ivfile);
                                                state.isReply == false
                                                    ? DatabaseFunctions()
                                                        .sendAttachmentMessage(
                                                            appCubit.state.user!
                                                                .phoneNumber!,
                                                            path,
                                                            detail['type'],
                                                            state.room!)
                                                    : DatabaseFunctions()
                                                        .sendAttachmentMessage(
                                                            appCubit.state.user!
                                                                .phoneNumber!,
                                                            path,
                                                            detail['type'],
                                                            state.room!,
                                                            replyID: state
                                                                .replyMessage!
                                                                .messageID);
                                              }
                                              if (detail['type'] == 'Video') {
                                                ivfile = await showVideoPicker(
                                                    detail['source']);
                                                result =
                                                    await uploadVideo(ivfile);
                                                state.isReply == false
                                                    ? DatabaseFunctions()
                                                        .sendAttachmentMessage(
                                                            appCubit.state.user!
                                                                .phoneNumber!,
                                                            result['videoURL'],
                                                            detail['type'],
                                                            state.room!,
                                                            thumbnailURL: result[
                                                                'thumbnailURL'])
                                                    : DatabaseFunctions()
                                                        .sendAttachmentMessage(
                                                            appCubit.state.user!
                                                                .phoneNumber!,
                                                            result['videoURL'],
                                                            detail['type'],
                                                            state.room!,
                                                            thumbnailURL: result[
                                                                'thumbnailURL'],
                                                            replyID: state
                                                                .replyMessage!
                                                                .messageID);
                                              }
                                              if (detail['type'] == 'Audio') {
                                                afFile = await showPicker();
                                                path =
                                                    await uploadAudio(afFile);
                                                state.isReply == false
                                                    ? DatabaseFunctions()
                                                        .sendAttachmentMessage(
                                                            appCubit.state.user!
                                                                .phoneNumber!,
                                                            path,
                                                            detail['type'],
                                                            state.room!)
                                                    : DatabaseFunctions()
                                                        .sendAttachmentMessage(
                                                            appCubit.state.user!
                                                                .phoneNumber!,
                                                            path,
                                                            detail['type'],
                                                            state.room!,
                                                            replyID: state
                                                                .replyMessage!
                                                                .messageID);
                                              }
                                              if (detail['type'] == 'File') {
                                                afFile = await showPicker();
                                                result =
                                                    await uploadFile(afFile);
                                                state.isReply == false
                                                    ? DatabaseFunctions()
                                                        .sendAttachmentMessage(
                                                            appCubit.state.user!
                                                                .phoneNumber!,
                                                            result['path'],
                                                            detail['type'],
                                                            state.room!,
                                                            attachName:
                                                                result['name'])
                                                    : DatabaseFunctions()
                                                        .sendAttachmentMessage(
                                                            appCubit.state.user!
                                                                .phoneNumber!,
                                                            result['path'],
                                                            detail['type'],
                                                            state.room!,
                                                            attachName:
                                                                result['name'],
                                                            replyID: state
                                                                .replyMessage!
                                                                .messageID);
                                              }
                                              cubit.changeisReply(
                                                  isReply: false);
                                              cubit.changeReplyMessage(
                                                  replyMessage: null);
                                            },
                                            icon: const Icon(Icons.add)),
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 12, top: 10, bottom: 10),
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 6, 8, 6),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: const Color.fromRGBO(
                                                    237, 237, 237, 1)),
                                            child: TextField(
                                              focusNode: focusNode,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              onChanged: (value) {
                                                value.trim().isEmpty
                                                    ? setState(() {
                                                        isDisable = true;
                                                      })
                                                    : setState(() {
                                                        isDisable = false;
                                                      });
                                              },
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14),
                                              textInputAction:
                                                  TextInputAction.newline,
                                              controller: controller,
                                              maxLines: 6,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                            margin:
                                                const EdgeInsets.only(left: 12),
                                            child: IconButton(
                                              icon: SvgPicture.asset(
                                                'assets/images/Send.svg',
                                                color: isDisable
                                                    ? disableTextColor
                                                    : const Color.fromRGBO(
                                                        0, 45, 227, 1),
                                              ),
                                              onPressed: isDisable == true
                                                  ? null
                                                  : () {
                                                      state.isReply == false
                                                          ? DatabaseFunctions()
                                                              .sendTextMessage(
                                                                  appCubit
                                                                      .state
                                                                      .user!
                                                                      .phoneNumber!,
                                                                  controller
                                                                      .text,
                                                                  state.room!)
                                                          : DatabaseFunctions()
                                                              .sendTextMessage(
                                                                  appCubit
                                                                      .state
                                                                      .user!
                                                                      .phoneNumber!,
                                                                  controller
                                                                      .text,
                                                                  state.room!,
                                                                  replyID: state
                                                                      .replyMessage!
                                                                      .messageID);
                                                      cubit.changeisReply(
                                                          isReply: false);
                                                      cubit.changeReplyMessage(
                                                          replyMessage: null);
                                                      setState(() {
                                                        controller.clear();
                                                        isDisable = true;
                                                      });
                                                    },
                                            ))
                                      ]);
                                })
                              ],
                            ))
                      ])));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
