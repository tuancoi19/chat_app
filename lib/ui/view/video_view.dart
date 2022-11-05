import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final String videoURL;
  const VideoView({super.key, required this.videoURL});

  @override
  State<StatefulWidget> createState() => _VideoView();
}

class _VideoView extends State<VideoView> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoURL)
      ..initialize().then((_) {
        _controller.play();
        _controller.addListener(() {
          setState(() {
            if (!_controller.value.isPlaying &&
                _controller.value.isInitialized &&
                (_controller.value.duration == _controller.value.position)) {
              setState(() {});
            }
          });
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? Stack(children: [
              Center(
                child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller)),
              ),
              Visibility(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: Center(
                      child: CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Center(
                              child: Icon(_controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow)))),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                      backgroundColor: Colors.grey, playedColor: Colors.white),
                ),
              )
            ])
          : const CircularProgressIndicator(),
    );
  }
}
