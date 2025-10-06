import 'package:better_player_enhanced/better_player.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const OTTApp());
}

class OTTApp extends StatelessWidget {
  const OTTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTT Prototype',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFFE50914),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme)
            .copyWith(
              headlineMedium: GoogleFonts.bebasNeue(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              titleLarge: GoogleFonts.bebasNeue(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              bodyLarge: GoogleFonts.openSans(color: Colors.white),
            ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> seriesDataFuture;

  @override
  void initState() {
    super.initState();
    seriesDataFuture = loadSeriesData();
  }

  Future<List<Map<String, dynamic>>> loadSeriesData() async {
    final String response = await rootBundle.loadString(
      'assets/mock_ott_data.json',
    );
    final List<dynamic> data = await json.decode(response);
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'OTT Prototype',
          style: GoogleFonts.bebasNeue(
            fontSize: 28,
            color: const Color(0xFFE50914),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: seriesDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final seriesData = snapshot.data!;
          return ListView.builder(
            itemCount: seriesData.length,
            itemBuilder: (context, index) {
              final category = seriesData[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      category['category'],
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: category['items'].length,
                      itemBuilder: (context, itemIndex) {
                        final item = category['items'][itemIndex];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerScreen(
                                  videos: category['items'],
                                  initialIndex: itemIndex,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 140,
                            margin: const EdgeInsets.only(right: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Image.network(
                                      item['thumbnail'],
                                      height: 200,
                                      width: 140,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                height: 200,
                                                width: 140,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[800],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        8.0,
                                                      ),
                                                ),
                                                child: const Icon(
                                                  Icons.movie,
                                                  color: Colors.white,
                                                  size: 50,
                                                ),
                                              ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      child: Text(
                                        item['title'],
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

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
          if (index > 0 && index < controllers.length) {
            controllers[currentIndex].pause();
            controllers[currentIndex].setVolume(0.0);
          }
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
              // Add title overlay for current video
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
              // Back button
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
