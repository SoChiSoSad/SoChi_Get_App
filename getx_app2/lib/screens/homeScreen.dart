import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getx_app2/bloc/photo/photo_bloc.dart';
import 'package:getx_app2/models/userModel.dart';
import 'package:getx_app2/screens/album.dart';
import 'package:getx_app2/screens/menu.dart';
import 'package:getx_app2/screens/cauchuyen.dart';
import 'package:getx_app2/screens/photo.dart';
import 'package:getx_app2/services/photo_repository.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      PhotoInPage(user: widget.user),
      AlbumInPage(user: widget.user),
      CauchuyenInPage(user: widget.user),
      MenuInPage(user: widget.user),
    ];

    return BlocProvider(
      create: (context) => PhotoBloc(PhotoRepository()),
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff6200ee),
          unselectedItemColor: const Color(0xff757575),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: _navBarItems,
        ),
      ),
    );
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.image),
    title: const Text("Ảnh"),
    selectedColor: const Color.fromARGB(255, 2, 195, 220),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.photo_library),
    title: const Text("Album"),
    selectedColor: const Color.fromARGB(255, 255, 230, 0),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.history_edu),
    title: const Text("câu chuyện"),
    selectedColor: const Color.fromARGB(255, 235, 141, 0),
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.format_list_bulleted_outlined),
    title: const Text("Menu"),
    selectedColor: const Color.fromARGB(255, 17, 255, 0),
  ),
];