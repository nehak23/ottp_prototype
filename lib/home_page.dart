import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ottp_prototype/utils/text_constants.dart';
import 'package:ottp_prototype/video_player_screen.dart';

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
          TextConstants.ottPrototypeText,
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
            return Center(
              child: Text('${TextConstants.errorText} ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text(TextConstants.noDataAvailable));
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
