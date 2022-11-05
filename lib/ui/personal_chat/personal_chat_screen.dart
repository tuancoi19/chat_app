import 'dart:io';

import 'package:chat_app/app_cubit.dart';
import 'package:chat_app/functions/upload.dart';
import 'package:chat_app/models/entities/users.dart';
import 'package:chat_app/ui/personal_chat/personal_chat_cubit.dart';
import 'package:chat_app/ui/personal_chat/personal_chat_state.dart';
import 'package:chat_app/ui/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../commons/app_commons.dart';
import '../../functions/database_functions.dart';
import '../../functions/show_picker.dart';
import '../../models/entities/rooms.dart';

class PersonalChatScreen extends StatefulWidget {
  final UserChat guest;
  const PersonalChatScreen({super.key, required this.guest});

  @override
  State<StatefulWidget> createState() => _PersonalChatScreen();
}

class _PersonalChatScreen extends State<PersonalChatScreen> {
  TextEditingController controller = TextEditingController();
  late bool isDisable;
  late PersonalChatCubit cubit;
  late AppCubit appCubit;
  late Room data;

  @override
  void initState() {
    super.initState();
    isDisable = true;
    appCubit = BlocProvider.of<AppCubit>(context);
    cubit = BlocProvider.of<PersonalChatCubit>(context);
    cubit.changeName(
        name: '${widget.guest.name.firstName} ${widget.guest.name.lastName}');
    getRoom(widget.guest.phoneNumber, appCubit.state.userNumber!);
    cubit.getMessages(cubit.state.room!);
  }

  void getRoom(String guest, String me) async {
    Room data = await DatabaseFunctions().checkRoom(guest, me);
    cubit.changeRoom(room: data);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalChatCubit, PersonalChatState>(
        bloc: cubit,
        builder: (context, state) {
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
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.navigate_before)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(state.name!,
                                style: TextStyle(
                                    color: text_color,
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
                              itemBuilder: (context, index) {
                                return itemMessage(
                                    state.messages![index],
                                    appCubit.state.userNumber!,
                                    '${widget.guest.name.firstName} ${widget.guest.name.lastName}',
                                    context);
                              },
                              itemCount: state.messages!.length,
                              reverse: true,
                            )
                          : null,
                    )),
                    Container(
                        margin: const EdgeInsets.only(left: 12, right: 12),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    XFile ivfile;
                                    File afFile;
                                    String path = '';
                                    Map<String, dynamic> detail =
                                        await chooseAttachment(context);
                                    if (detail['type'] == 'Image') {
                                      ivfile = await showImagePicker(
                                          detail['source']);
                                      path = await uploadImage(ivfile);
                                      DatabaseFunctions().sendAttachmentMessage(
                                          appCubit.state.userNumber!,
                                          path,
                                          detail['type'],
                                          state.room!);
                                    }
                                    if (detail['type'] == 'Video') {
                                      Map result;
                                      ivfile = await showVideoPicker(
                                          detail['source']);
                                      result = await uploadVideo(ivfile);
                                      DatabaseFunctions().sendAttachmentMessage(
                                          appCubit.state.userNumber!,
                                          result['videoURL'],
                                          detail['type'],
                                          state.room!,
                                          thumbnailURL: result['thumbnailURL']);
                                    }
                                    if (detail['type'] == 'Audio') {
                                      afFile = await showPicker();
                                      path = await uploadAudio(afFile);
                                      DatabaseFunctions().sendAttachmentMessage(
                                          appCubit.state.userNumber!,
                                          path,
                                          detail['type'],
                                          state.room!);
                                    }
                                    if (detail['type'] == 'File') {
                                      afFile = await showPicker();
                                      path = await uploadAudio(afFile);
                                      DatabaseFunctions().sendAttachmentMessage(
                                          appCubit.state.userNumber!,
                                          path,
                                          detail['type'],
                                          state.room!);
                                    }
                                  },
                                  icon: const Icon(Icons.add)),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 12, top: 10, bottom: 10),
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 6, 8, 6),
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(237, 237, 237, 1)),
                                  child: TextField(
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
                                    textInputAction: TextInputAction.newline,
                                    controller: controller,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(left: 12),
                                  child: IconButton(
                                    icon: SvgPicture.asset(
                                      'assets/images/Send.svg',
                                      color: isDisable
                                          ? disable_text_color
                                          : const Color.fromRGBO(0, 45, 227, 1),
                                    ),
                                    onPressed: isDisable == true
                                        ? null
                                        : () {
                                            DatabaseFunctions().sendTextMessage(
                                                appCubit.state.userNumber!,
                                                controller.text,
                                                state.room!);
                                            setState(() {
                                              controller.clear();
                                            });
                                          },
                                  ))
                            ]))
                  ])));
        });
  }
}
