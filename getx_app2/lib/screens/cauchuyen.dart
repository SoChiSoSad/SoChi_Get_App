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

  // DateTime? _lastUpdate; lưu trữ 1 ngày

  @override
  void initState() {
    super.initState();
    _loadRandomPhotos();
  }

  Future<void> _loadRandomPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    // final lastUpdateStr = prefs.getString('last_update');
    final now = DateTime.now();


// điều kiện lưu trữ ảnh 1 ngày
    // if (lastUpdateStr != null) {
    //   _lastUpdate = DateTime.parse(lastUpdateStr);
    //   if (now.difference(_lastUpdate!).inDays < 1) {
    //     return;
    //   }
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
                image: DecorationImage(
                  image: NetworkImage(photo.thumbnailUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
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
                  // child: Text(
                  //   photo.title,
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 14,
                  //   ),
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  //   textAlign: TextAlign.center,
                  // ),

                  child: Text(
                    'ảnh ${photos.indexOf(photo) + 1}',
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

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
                // Section: Đề xuất ảnh hay
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Đề xuất ảnh hay',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                if (state is PhotoLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state is PhotoError)
                  Center(child: Text('Lỗi: ${state.message}'))
                else if (state is PhotoLoaded && _randomPhotos.isNotEmpty)
                  _buildCarousel(_randomPhotos)
                else
                  const Center(child: Text('Không có ảnh để hiển thị')),

                // Section: Đề xuất ảnh trong tuần
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Đề xuất ảnh trong tuần',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                if (state is PhotoLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state is PhotoError)
                  Center(child: Text('Lỗi: ${state.message}'))
                else if (state is PhotoLoaded && _randomPhotosTuan.isNotEmpty)
                  _buildCarousel(_randomPhotosTuan)
                else
                  const Center(child: Text('Không có ảnh để hiển thị')),

                // Section: Đề xuất ảnh đặc biệt
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Đề xuất ảnh đặc biệt',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                if (state is PhotoLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state is PhotoError)
                  Center(child: Text('Lỗi: ${state.message}'))
                else if (state is PhotoLoaded && _randomPhotosDacBiet.isNotEmpty)
                  _buildCarousel(_randomPhotosDacBiet)
                else
                  const Center(child: Text('Không có ảnh để hiển thị')),
              ],
            ),
          );
        },
      ),
    );
  }
}