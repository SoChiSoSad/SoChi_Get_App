import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getx_app2/bloc/photo/photo_bloc.dart';
import 'package:getx_app2/bloc/photo/photo_event.dart';
import 'package:getx_app2/bloc/photo/photo_state.dart';
import 'package:getx_app2/models/photoModel.dart';
import 'package:getx_app2/models/userModel.dart';
import 'package:getx_app2/services/photo_repository.dart';

class PhotoInPage extends StatelessWidget {
  final UserModel user;

  PhotoInPage({required this.user});

  void _openGallery(
    BuildContext context,
    List<PhotoModel> photos,
    int initialIndex,
  ) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder:
            (_, __, ___) =>
                FullScreenGallery(photos: photos, initialIndex: initialIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotoBloc(PhotoRepository())..add(FetchPhotos()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tất cả ảnh của tôi'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<PhotoBloc, PhotoState>(
          builder: (context, state) {
            if (state is PhotoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PhotoLoaded) {
              final photos = state.photos;
              final albums = <int, List<PhotoModel>>{};

              for (var photo in photos) {
                albums.putIfAbsent(photo.albumId, () => []).add(photo);
              }

              return ListView.builder(
                itemCount: albums.keys.length,
                itemBuilder: (context, index) {
                  final albumId = albums.keys.elementAt(index);
                  final albumPhotos = albums[albumId]!;

                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Album $albumId',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: albumPhotos.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.85,
                              ),
                          itemBuilder: (context, idx) {
                            final photo = albumPhotos[idx];
                            return GestureDetector(
                              onTap:
                                  () => _openGallery(context, albumPhotos, idx),

                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    photo.thumbnailUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,

                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.broken_image,
                                                size: 40,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "${idx + 1}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is PhotoError) {
              return Center(child: Text('Lỗi: ${state.message}'));
            }
            return const Center(child: Text('Đang tải...'));
          },
        ),
      ),
    );
  }
}

/*
** //Todo : chọn ảnh để full màn hình điện thoại 
**/ 
class FullScreenGallery extends StatefulWidget {
  final List<PhotoModel> photos;
  final int initialIndex;

  const FullScreenGallery({
    Key? key,
    required this.photos,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
  }

  void _closeViewer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        // Vuốt xuống để đóng
        if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
          _closeViewer();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.95),
        body: Stack(
          alignment: Alignment.topRight,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.photos.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final photo = widget.photos[index];
                final currentImageIndex = index + 1;
                return InteractiveViewer(
                  child: Center(
                    child: Image.network(
                      photo.url,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.broken_image,
                                color: Colors.white,
                                size: 80,
                              ),
                              Text(
                                "$currentImageIndex",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            SafeArea(
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: _closeViewer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
