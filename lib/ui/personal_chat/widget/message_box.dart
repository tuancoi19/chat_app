import 'package:chat_app/functions/show_toast.dart';
import 'package:chat_app/models/entities/messages.dart';
import 'package:chat_app/ui/personal_chat/personal_chat_cubit.dart';
import 'package:chat_app/ui/personal_chat/widget/view/audio_player.dart';
import 'package:chat_app/ui/personal_chat/widget/view/image_view.dart';
import 'package:chat_app/ui/personal_chat/widget/view/video_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../commons/app_commons.dart';
import '../../../models/entities/rooms.dart';

Widget itemMessage(
    Message message,
    String me,
    String guestName,
    BuildContext context,
    FocusNode focusNode,
    Room room,
    String phoneNumber,
    int index,
    List<Message>? messages) {
  PersonalChatCubit cubit = BlocProvider.of<PersonalChatCubit>(context);
  if (message.author != me) {
    return SwipeTo(
        onRightSwipe: () {
          cubit.changeisReply(isReply: true);
          cubit.changeReplyMessage(replyMessage: message);
          focusNode.requestFocus();
        },
        iconColor: textColor,
        child: guestMessage(
            message, me, guestName, context, room, cubit, phoneNumber));
  } else {
    return SwipeTo(
        onLeftSwipe: () {
          cubit.changeisReply(isReply: true);
          cubit.changeReplyMessage(replyMessage: message);
          focusNode.requestFocus();
        },
        iconColor: textColor,
        child: youMessage(
            message, me, guestName, context, room, cubit, phoneNumber));
  }
}

Widget youMessage(
    Message message,
    String me,
    String guestName,
    BuildContext context,
    Room room,
    PersonalChatCubit cubit,
    String phoneNumber) {
  return Container(
      margin: const EdgeInsets.only(right: 16, left: 22, bottom: 12),
      alignment: Alignment.bottomRight,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16)),
          color: Color.fromRGBO(0, 45, 227, 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            message.replyID!.isEmpty
                ? const SizedBox()
                : Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: ClipPath(
                        clipper: const ShapeBorderClipper(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)))),
                        child: Container(
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(237, 237, 237, 1),
                                border: Border(
                                    left: BorderSide(
                                        color: Colors.white, width: 4))),
                            child: replyForm(message.replyID!, me, guestName,
                                room, true, cubit, phoneNumber)!)),
                  ),
            content(message, me, context),
            Container(
                margin: const EdgeInsets.only(top: 4),
                child: Text(
                  '${DateFormat('hh.mm').format(DateTime.fromMicrosecondsSinceEpoch(message.createdTime.microsecondsSinceEpoch))} · ${message.status}',
                  style: GoogleFonts.lato(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ))
          ],
        ),
      ));
}

Widget guestMessage(
    Message message,
    String me,
    String guestName,
    BuildContext context,
    Room room,
    PersonalChatCubit cubit,
    String phoneNumber) {
  return Container(
      margin: const EdgeInsets.only(left: 16, right: 22, bottom: 12),
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16)),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            message.replyID!.isEmpty
                ? const SizedBox()
                : Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: ClipPath(
                        clipper: const ShapeBorderClipper(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)))),
                        child: Container(
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(237, 237, 237, 1),
                                border: Border(
                                    left: BorderSide(
                                        color: Color.fromRGBO(0, 45, 227, 1),
                                        width: 4))),
                            child: replyForm(message.replyID!, me, guestName,
                                room, false, cubit, phoneNumber)!)),
                  ),
            content(message, me, context),
            Container(
                margin: const EdgeInsets.only(top: 4),
                child: Text(
                    DateFormat('hh.mm').format(
                        DateTime.fromMicrosecondsSinceEpoch(
                            message.createdTime.microsecondsSinceEpoch)),
                    style: GoogleFonts.lato(
                        fontSize: 10, fontWeight: FontWeight.w400)))
          ],
        ),
      ));
}

Widget content(Message message, String me, BuildContext context) {
  switch (message.attachType) {
    case '':
      return message.author != me
          ? Text(message.content!,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              maxLines: null)
          : Text(message.content!,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.white),
              maxLines: null);
    case 'Image':
      return GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ImageView(imageURL: message.attachURL!))),
        child: SizedBox(
          height: 150,
          width: 246,
          child: Image.network(message.attachURL!, fit: BoxFit.cover),
        ),
      );
    case 'Video':
      return GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VideoView(videoURL: message.attachURL!))),
        child: SizedBox(
            height: 150,
            width: 246,
            child: Stack(fit: StackFit.expand, children: [
              Image.network(message.thumbnailURL!, fit: BoxFit.fill),
              const Center(
                child: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Center(child: Icon(Icons.play_arrow))),
              ),
            ])),
      );
    case 'Audio':
      return AudioConTents(message: message);
    case 'File':
      return message.author != me
          ? RichText(
              text: TextSpan(children: [
                const WidgetSpan(child: Icon(Icons.download)),
                const TextSpan(
                    text: ' ',
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                TextSpan(
                    text: '${message.attachName}',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: textColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => launchUrl(Uri.parse(message.attachURL!)))
              ]),
            )
          : RichText(
              text: TextSpan(children: [
              const WidgetSpan(child: Icon(Icons.download, size: 14)),
              const TextSpan(
                  text: ' ',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
              TextSpan(
                  text: '${message.attachName}',
                  style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                  recognizer: TapGestureRecognizer()
                    ..onTap =
                        () async => await downloadDialog(context, message))
            ]));
  }
  return const SizedBox();
}

Widget? replyForm(String replyID, String me, String guestName, Room room,
    bool youSide, PersonalChatCubit cubit, String phoneNumber) {
  Message result = cubit.state.messages!
      .where((element) => element.messageID.contains(replyID))
      .single;
  return Container(
    padding: const EdgeInsets.all(8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(result.author != me ? guestName : 'You',
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 10,
                color: Color.fromRGBO(0, 45, 227, 1))),
        Container(
            margin: const EdgeInsets.only(top: 4),
            child: result.attachType == ''
                ? Text(
                    result.content ?? "",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: textColor),
                  )
                : RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                            child: Icon(Icons.attach_file,
                                color: textColor, size: 14)),
                        TextSpan(
                            text: ' Reply an attachment',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: textColor))
                      ],
                    ),
                  ))
      ],
    ),
  );
}

Widget replyChatForm(Message message, String me, String guestName) {
  return Expanded(
      child: Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              border: Border(
                  left: BorderSide(
                      width: 4, color: Color.fromRGBO(0, 45, 227, 1)))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message.author != me ? guestName : 'You',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: Color.fromRGBO(0, 45, 227, 1))),
              Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: message.attachType == ''
                      ? Text(
                          message.content!,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: textColor),
                        )
                      : RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                  child: Icon(Icons.attach_file,
                                      color: textColor)),
                              TextSpan(
                                  text: ' Reply an attachment',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: textColor))
                            ],
                          ),
                        ))
            ],
          )));
}

Future downloadDialog(BuildContext context, Message message) async {
  return await showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text('Downloading'),
            content: Text('Do you want to download ${message.attachName}?'),
            actions: [
              TextButton(
                  onPressed: () async {
                    await launchUrl(Uri.parse(message.attachURL!),
                        mode: LaunchMode.externalApplication);
                    showStatusToast('Downloading...');
                  },
                  child: const Text('Yes')),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('No'),
              )
            ],
          )));
}
