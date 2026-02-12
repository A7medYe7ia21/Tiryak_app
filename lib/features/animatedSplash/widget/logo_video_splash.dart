import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../core/widgets/loading_indicator.dart';

class LogoVideoSplash extends StatefulWidget {
  final String videoPath;
  const LogoVideoSplash({super.key, required this.videoPath});

  @override
  State<LogoVideoSplash> createState() => _LogoVideoSplashState();
}

class _LogoVideoSplashState extends State<LogoVideoSplash> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(child: LoadingIndicator());
  }
}
