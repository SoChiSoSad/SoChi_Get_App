import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getx_app2/bloc/photo/photo_event.dart';
import 'package:getx_app2/models/photoModel.dart';
import 'package:getx_app2/services/photo_repository.dart';
import 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final PhotoRepository repository;
  List<PhotoModel> _allPhotos = [];
  int _currentPage = 1;
  final int _perPage = 20;
  bool _hasReachedMax = false;

  PhotoBloc(this.repository) : super(PhotoInitial()) {
    on<FetchPhotos>((event, emit) async {
      emit(PhotoLoading());
      try {
        _currentPage = 1;
        _allPhotos = await repository.fetchPhotos();
        final initialPhotos = _allPhotos.take(_perPage).toList();
        _hasReachedMax = initialPhotos.length >= _allPhotos.length;
        emit(PhotoLoaded(photos: initialPhotos, hasReachedMax: _hasReachedMax));
      } catch (e) {
        emit(PhotoError(e.toString()));
      }
    });

    on<FetchMorePhotos>((event, emit) {
      if (_hasReachedMax || state is! PhotoLoaded) return;

      final currentState = state as PhotoLoaded;
      final nextPage = _currentPage + 1;
      final nextPhotos = _allPhotos.skip(_perPage * (nextPage - 1)).take(_perPage).toList();

      if (nextPhotos.isEmpty) {
        _hasReachedMax = true;
        emit(PhotoLoaded(photos: currentState.photos, hasReachedMax: true));
      } else {
        _currentPage = nextPage;
        final updatedPhotos = List<PhotoModel>.from(currentState.photos)..addAll(nextPhotos);
        emit(PhotoLoaded(photos: updatedPhotos, hasReachedMax: updatedPhotos.length >= _allPhotos.length));
      }
    });
  }
}

