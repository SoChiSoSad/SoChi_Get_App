import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:getx_app2/bloc/photo/photo_bloc.dart';
import 'package:getx_app2/bloc/photo/photo_event.dart';
import 'package:getx_app2/bloc/photo/photo_state.dart';
import 'package:getx_app2/models/photoModel.dart';
import 'package:getx_app2/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CauchuyenInPage extends StatefulWidget {
  final UserModel user;
  CauchuyenInPage({required this.user});

  @override
  State<CauchuyenInPage> createState() => _CauchuyenInPageState();
}

class _CauchuyenInPageState extends State<CauchuyenInPage> {
  List<PhotoModel> _randomPhotos = [];
  List<PhotoModel> _randomPhotosTuan = [];
  List<PhotoModel> _randomPhotosDacBiet = [];

  @override
  void initState() {
    super.initState();
    _loadRandomPhotos();
  }

  Future<void> _loadRandomPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    // Bạn có thể bật phần này nếu muốn giới hạn cập nhật mỗi ngày
    // final lastUpdateStr = prefs.getString('last_update');
    // if (lastUpdateStr != null) {
    //   final lastUpdate = DateTime.parse(lastUpdateStr);
    //   if (now.difference(lastUpdate).inDays < 1) return;
    // }

    context.read<PhotoBloc>().add(FetchPhotos());
    await prefs.setString('last_update', now.toIso8601String());
  }

  List<PhotoModel> _getRandomPhotos(List<PhotoModel> photos, int count) {
    final random = Random();
    final shuffled = photos.toList()..shuffle(random);
    return shuffled.take(count).toList();
  }

  Widget _buildCarousel(List<PhotoModel> photos) {
    return carousel.CarouselSlider(
      options: carousel.CarouselOptions(
        height: 200.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
      items: photos.map((photo) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      photo.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.broken_image,
                              size: 60, color: Colors.grey[700]),
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        'Ảnh ${photos.indexOf(photo) + 1}',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Câu Chuyện'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: BlocConsumer<PhotoBloc, PhotoState>(
        listener: (context, state) {
          if (state is PhotoLoaded) {
            setState(() {
              _randomPhotos = _getRandomPhotos(state.photos, 10);
              _randomPhotosTuan = _getRandomPhotos(state.photos, 10);
              _randomPhotosDacBiet = _getRandomPhotos(state.photos, 10);
            });
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection('Đề xuất ảnh hay', state, _randomPhotos),
                _buildSection('Đề xuất ảnh trong tuần', state, _randomPhotosTuan),
                _buildSection('Đề xuất ảnh đặc biệt', state, _randomPhotosDacBiet),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, PhotoState state, List<PhotoModel> photos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        if (state is PhotoLoading)
          const Center(child: CircularProgressIndicator())
        else if (state is PhotoError)
          Center(child: Text('Lỗi: ${state.message}'))
        else if (state is PhotoLoaded && photos.isNotEmpty)
          _buildCarousel(photos)
        else
          const Center(child: Text('Không có ảnh để hiển thị')),
      ],
    );
  }
}
