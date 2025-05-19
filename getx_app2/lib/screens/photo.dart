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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotoBloc(PhotoRepository())..add(FetchPhotos()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tất cả ảnh của tôi'),
          automaticallyImplyLeading: false,
          centerTitle: true,
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
                          '📁 Album $albumId',
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
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.85,
                          ),
                          itemBuilder: (context, idx) {
                            final photo = albumPhotos[idx];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        photo.thumbnailUrl,
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      photo.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
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
