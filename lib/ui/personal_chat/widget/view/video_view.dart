import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoView extends StatefulWidget {
  final String videoURL;
  const VideoView({super.key, required this.videoURL});

  @override
  State<StatefulWidget> createState() => _VideoView();
}

class _VideoView extends State<VideoView> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.videoURL),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && mounted) {
          flickManager.flickControlManager?.autoPause();
        } else if (visibility.visibleFraction == 1) {
          flickManager.flickControlManager?.autoResume();
        }
      },
      child: FlickVideoPlayer(
        flickManager: flickManager,
        flickVideoWithControls: const FlickVideoWithControls(
          videoFit: BoxFit.fitWidth,
          controls: FlickPortraitControls(),
        ),
        flickVideoWithControlsFullscreen: const FlickVideoWithControls(
          controls: FlickLandscapeControls(),
        ),
      ),
    );
  }
}
