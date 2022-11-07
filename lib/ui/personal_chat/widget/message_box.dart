import 'package:chat_app/functions/database_functions.dart';
import 'package:chat_app/functions/show_toast.dart';
import 'package:chat_app/models/entities/messages.dart';
import 'package:chat_app/ui/personal_chat/personal_chat_cubit.dart';
import 'package:chat_app/ui/personal_chat/widget/view/audio_player.dart';
import 'package:chat_app/ui/personal_chat/widget/view/image_view.dart';
import 'package:chat_app/ui/personal_chat/widget/view/video_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
    PersonalChatCubit cubit,
    Room room) {
  if (message.author != me) {
    return SwipeTo(
        onRightSwipe: () {
          cubit.changeReplyMessage(replyMessage: message);
          cubit.changeisReply(isReply: true);
          focusNode.requestFocus();
        },
        iconColor: text_color,
        child: guestMessage(message, me, guestName, context, room));
  } else {
    return SwipeTo(
        onLeftSwipe: () {
          cubit.changeReplyMessage(replyMessage: message);
          cubit.changeisReply(isReply: true);
          focusNode.requestFocus();
        },
        iconColor: text_color,
        child: youMessage(message, me, guestName, context, room));
  }
}

Widget youMessage(Message message, String me, String guestName,
    BuildContext context, Room room) {
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
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              message.replyID!.isEmpty
                  ? const SizedBox()
                  : Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(237, 237, 237, 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: replyForm(
                          message.replyID!, me, guestName, room, true)!),
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
        ),
      ));
}

Widget guestMessage(Message message, String me, String guestName,
    BuildContext context, Room room) {
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
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              message.replyID!.isEmpty
                  ? const SizedBox()
                  : Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: const Color.fromRGBO(237, 237, 237, 1)),
                      child: replyForm(
                          message.replyID!, me, guestName, room, false)!),
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
                        color: text_color),
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

Widget? replyForm(
    String replyID, String me, String guestName, Room room, bool youSide) {
  return FutureBuilder(
      future: DatabaseFunctions().getMessageByID(replyID, room),
      builder: (context, AsyncSnapshot<Message?> snapshot) {
        if (snapshot.hasData) {
          return Container(
            decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                        width: 4,
                        color: youSide == false
                            ? const Color.fromRGBO(0, 45, 227, 1)
                            : Colors.white),
                    right: const BorderSide(
                        width: 4, color: Color.fromRGBO(237, 237, 237, 1)))),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.data!.author != me ? guestName : 'You',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        color: Color.fromRGBO(0, 45, 227, 1))),
                Container(
                    margin: const EdgeInsets.only(top: 4),
                    child: snapshot.data!.attachType == ''
                        ? Text(
                            snapshot.data?.content ?? "",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: text_color),
                          )
                        : RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                    child: Icon(Icons.attach_file,
                                        color: text_color, size: 14)),
                                TextSpan(
                                    text: ' Reply an attachment',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: text_color))
                              ],
                            ),
                          ))
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      });
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
                              color: text_color),
                        )
                      : RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                  child: Icon(Icons.attach_file,
                                      color: text_color)),
                              TextSpan(
                                  text: ' Reply an attachment',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: text_color))
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
            content: Text('Are you sure to download ${message.attachName}?'),
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
