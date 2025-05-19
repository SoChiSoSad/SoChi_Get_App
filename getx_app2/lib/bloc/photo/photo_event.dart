import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getx_app2/bloc/photo/photo_bloc.dart';
import 'package:getx_app2/services/photo_repository.dart';
import 'photo_state.dart';


class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final PhotoRepository repository;

  PhotoBloc(this.repository) : super(PhotoInitial()) {
    on<FetchPhotos>((event, emit) async {
      emit(PhotoLoading());
      try {
        final photos = await repository.fetchPhotos();
        emit(PhotoLoaded(photos));
      } catch (e) {
        emit(PhotoError(e.toString()));
      }
    });
  }
}
