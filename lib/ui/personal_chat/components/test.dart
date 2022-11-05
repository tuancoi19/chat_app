import 'package:chat_app/models/entities/messages.dart';
import 'package:chat_app/ui/personal_chat/components/audio_content.dart';
import 'package:chat_app/ui/view/image_view.dart';
import 'package:chat_app/ui/view/video_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../commons/app_commons.dart';

Widget itemMessage(
    Message message, String me, String guestName, BuildContext context) {
  return Container(
      margin: message.author != me
          ? const EdgeInsets.only(left: 16, right: 22, bottom: 12)
          : const EdgeInsets.only(right: 16, left: 22, bottom: 12),
      alignment:
          message.author != me ? Alignment.bottomLeft : Alignment.bottomRight,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: message.author != me
              ? const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16))
              : const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16)),
          color: message.author != me
              ? Colors.white
              : const Color.fromRGBO(0, 45, 227, 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            message.replyID!.isEmpty
                ? const SizedBox()
                : replyForm(message, me, guestName),
            content(message, me, context),
            Container(
                margin: const EdgeInsets.only(top: 4),
                child: message.author != me
                    ? Text(
                        DateFormat('hh.mm').format(
                            DateTime.fromMicrosecondsSinceEpoch(
                                message.createdTime.microsecondsSinceEpoch)),
                        style: GoogleFonts.lato(
                            fontSize: 10, fontWeight: FontWeight.w400))
                    : Text(
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

content(Message message, String me, BuildContext context) {
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
      return AudioConTents(
        message: message,
        me: me,
      );
  }
}

replyForm(Message message, String me, String guestName) {
  return Expanded(
      child: Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: message.author != me
                  ? const Border(
                      left: BorderSide(
                          width: 4, color: Color.fromRGBO(0, 45, 227, 1)))
                  : const Border(
                      left: BorderSide(
                          width: 4, color: Color.fromRGBO(0, 45, 227, 1)))),
          child: Column(
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
