// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPhotosPage extends StatefulWidget {
  const SearchPhotosPage({super.key});

  @override
  _SearchPhotosPageState createState() => _SearchPhotosPageState();
}

class _SearchPhotosPageState extends State<SearchPhotosPage> {
  String _searchQuery = '';
  List<dynamic> _photos = [];
  int _page = 1;
  bool _isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();
  late SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMorePhotos();
      }
    });
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    final savedQuery = _preferences.getString('searchQuery');
    if (savedQuery != null) {
      setState(() {
        _searchQuery = savedQuery;
      });
      _searchPhotos(savedQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final crossAxisCount = isMobile ? 2 : 4;
    final aspectRatio = isMobile ? 1.0 : 1.5;

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[500],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _searchQuery.isNotEmpty ? 1.0 : 0.0,
                  child: ElevatedButton(
                    onPressed: () {
                      _saveSearchQuery();
                      _searchPhotos(_searchQuery);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              controller: _scrollController,
              itemCount: _photos.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: aspectRatio,
              ),
              itemBuilder: (context, index) {
                final photo = _photos[index];
                final photographer = photo['photographer'];
                final imageUrl = photo['src']['medium'];
                final photoUrl = photo['src']['large2x'];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImagePage(
                          imageUrl: photoUrl,
                          photographer: photographer,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Photo by $photographer',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoadingMore)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Future<void> _searchPhotos(String query) async {
    const apiKey = 'ZOvHKEtK2USaAJJoIHoRF5W0eH8up26MHz0UUfFUdxopXitCuNui1qpV';
    const perPage = 40;
    final url = Uri.parse(
      'https://api.pexels.com/v1/search?query=$query&per_page=$perPage',
    );
    final response = await http.get(
      url,
      headers: {'Authorization': apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _photos = data['photos'];
      });
    } else {
      print('Failed to search photos');
    }
  }

  Future<void> _loadMorePhotos() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    const apiKey = 'ZOvHKEtK2USaAJJoIHoRF5W0eH8up26MHz0UUfFUdxopXitCuNui1qpV';
    const perPage = 40;
    final url = Uri.parse(
      'https://api.pexels.com/v1/search?query=$_searchQuery&per_page=$perPage&page=${_page + 1}',
    );
    final response = await http.get(
      url,
      headers: {'Authorization': apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _photos.addAll(data['photos']);
        _page++;
        _isLoadingMore = false;
      });
    } else {
      print('Failed to load more photos');
    }
  }

  Future<void> _saveSearchQuery() async {
    await _preferences.setString('searchQuery', _searchQuery);
  }
}

class FullScreenImagePage extends StatefulWidget {
  final String imageUrl;
  final String photographer;

  const FullScreenImagePage({
    required this.imageUrl,
    required this.photographer,
  });

  @override
  _FullScreenImagePageState createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  double _opacity = 0.0;
  double _scale = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      _opacity = 1.0;
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: _opacity,
            child: InteractiveViewer(
              maxScale: 5.0, // Maximum scale factor for zooming
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16.0,
            right: 16.0,
            child: Transform.scale(
              scale: _scale,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Photo by ${widget.photographer}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
