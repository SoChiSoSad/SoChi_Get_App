import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getx_app2/bloc/photo/photo_bloc.dart';
import 'package:getx_app2/bloc/photo/photo_event.dart';
import 'package:getx_app2/bloc/photo/photo_state.dart';
import 'package:getx_app2/models/photoModel.dart';
import 'package:getx_app2/models/userModel.dart';
import 'package:getx_app2/services/photo_repository.dart';

class AlbumInPage extends StatelessWidget {
  final UserModel user;
  AlbumInPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhotoBloc(PhotoRepository())..add(FetchPhotos()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Albums'),
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

                  return ExpansionTile(
                    title: Row(
                      children: [
                        const Icon(Icons.photo_album_outlined,
                            color: Color.fromARGB(255, 7, 222, 255)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            albumPhotos.first.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: albumPhotos.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemBuilder: (context, idx) {
                          final photo = albumPhotos[idx];
                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  photo.thumbnailUrl,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 40,
                                        color: Colors.grey[700],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text("Ảnh ${idx + 1}"),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            } else if (state is PhotoError) {
              return Center(child: Text('Lỗi: ${state.message}'));
            } else {
              return const Center(child: Text('Không có dữ liệu'));
            }
          },
        ),
      ),
    );
  }
}
