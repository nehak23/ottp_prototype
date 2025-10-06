import 'package:better_player_enhanced/better_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoPlayerScreen extends StatefulWidget {
  final List<dynamic> videos;
  final int initialIndex;

  const VideoPlayerScreen({
    super.key,
    required this.videos,
    this.initialIndex = 0,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late PageController _pageController;
  int currentIndex = 0;
  late List<BetterPlayerController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = widget.videos.map((video) {
      return BetterPlayerController(
        BetterPlayerConfiguration(
          autoPlay: true,
          fit: BoxFit.cover,
          controlsConfiguration: const BetterPlayerControlsConfiguration(
            enablePlayPause: true,
            enableMute: true,
            enableFullscreen: false,
            enableProgressText: true,
            showControlsOnInitialize: false,
            enableOverflowMenu: false,
            enableSkips: false,
            enableSubtitles: false,
          ),
        ),
        betterPlayerDataSource: BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          video['videoUrl'],
        ),
      );
    }).toList();
    _pageController = PageController(initialPage: widget.initialIndex);
    currentIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.pause();
      controller.setVolume(0.0);
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemCount: widget.videos.length,
        itemBuilder: (context, index) {
          final video = widget.videos[index];
          return Stack(
            children: [
              BetterPlayer(
                key: ValueKey(index),
                controller: controllers[index],
              ),
              if (index == currentIndex)
                Positioned(
                  bottom: 100,
                  left: 20,
                  right: 20,
                  child: Text(
                    video['title'],
                    style: GoogleFonts.bebasNeue(
                      fontSize: 32,
                      color: Colors.white,
                      shadows: [
                        const Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 20,
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    for (var controller in controllers) {
                      controller.pause();
                      controller.setVolume(0.0);
                      controller.dispose();
                    }
                    _pageController.dispose();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
