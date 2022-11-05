import 'package:chat_app/app_cubit.dart';
import 'package:chat_app/functions/format_time.dart';
import 'package:chat_app/models/entities/messages.dart';
import 'package:chat_app/ui/personal_chat/personal_chat_cubit.dart';
import 'package:chat_app/ui/personal_chat/personal_chat_state.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class AudioConTents extends StatefulWidget {
  const AudioConTents({super.key, required this.message, required this.me});
  final Message message;
  final String me;

  @override
  State<AudioConTents> createState() => _AudioConTentsState();
}

class _AudioConTentsState extends State<AudioConTents> {
  late PersonalChatCubit cubit;
  late AppCubit appCubit;
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isInit = true;
  Duration? duration;
  Duration position1 = Duration.zero;

  @override
  void initState() {
    super.initState();
    appCubit = BlocProvider.of<AppCubit>(context);
    cubit = BlocProvider.of<PersonalChatCubit>(context);
    cubit.setDefaultDuration();
    cubit.setAudio(audioPlayer, widget.message.attachURL ?? '');

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isInit = false;
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      cubit.changeDuration(newDuration);
    });

    audioPlayer.onPlayerComplete.listen((event) {
      cubit.setAudio(audioPlayer, widget.message.attachURL ?? '');
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      cubit.changePosition(newPosition);
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalChatCubit, PersonalChatState>(
        bloc: cubit,
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color.fromRGBO(55, 95, 255, 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                      return;
                    }
                    await audioPlayer.resume();
                    return;
                  },
                  child: isPlaying
                      ? const Icon(Icons.pause, color: Colors.white)
                      : const Icon(Icons.play_arrow, color: Colors.white),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  formatTime(((isInit ? state.duration : state.position) ??
                      Duration.zero)),
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                const SizedBox(
                  width: 16,
                ),
                SvgPicture.asset('assets/images/sound.svg', color: Colors.white)
              ],
            ),
          );
        });
  }
}
