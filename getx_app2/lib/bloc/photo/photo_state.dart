import 'package:getx_app2/models/photoModel.dart';

abstract class PhotoState {}

class PhotoInitial extends PhotoState {}

class PhotoLoading extends PhotoState {}

class PhotoLoaded extends PhotoState {
  final List<PhotoModel> photos;

  PhotoLoaded(this.photos);
}

class PhotoError extends PhotoState {
  final String message;

  PhotoError(this.message);
}
