

import 'package:getx_app2/models/userModel.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserModel> users; // ✅ Sửa lại chữ hoa đúng class name

  UserLoaded(this.users);
}

class userModel {
  final String name;
  final String email;

  userModel({required this.name,required this.email});
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}
