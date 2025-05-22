import 'package:flutter/material.dart';
import 'package:getx_app2/models/userModel.dart';
import 'package:getx_app2/pages/setting.dart';
import 'package:getx_app2/pages/taikhoan.dart';
import 'package:getx_app2/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuInPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final UserModel user;

  MenuInPage({required this.user});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          titleSpacing: 0,
          leading:
              isLargeScreen
                  ? null
                  : IconButton(
                    color: Colors.black,
                    icon: const Icon(Icons.menu),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Menu",
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isLargeScreen) Expanded(child: _navBarItems(context)),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: _ProfileIcon(user: user)),
            ),
          ],
        ),
        drawer: isLargeScreen ? null : _drawer(context),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffe8f5e9), Color(0xffffffff)],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _UserHeader(user: user),
              const SizedBox(height: 20),
              _QuickActions(user: user),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Đăng xuất'),
            content: const Text('Bạn có chắc muốn đăng xuất?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.pop(dialogContext);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                },
                child: const Text('Đăng xuất'),
              ),
            ],
          ),
    );
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: ListView(
          children:
              _menuItems
                  .map(
                    (item) => ListTile(
                      title: Text(item),
                      textColor: Colors.black,
                      onTap: () {
                        Navigator.pop(context);
                        switch (item) {
                          case 'Account':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TaiKhoanPage(user: user),
                              ),
                            );
                            break;
                          case 'Settings':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SettingsPage2(),
                              ),
                            );
                            break;
                          case 'Sign Out':
                            _showLogoutDialog(context);
                            break;
                        }
                      },
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  Widget _navBarItems(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.center,
    children:
        _menuItems
            .map(
              (item) => InkWell(
                onTap: () {
                  switch (item) {
                    case 'Account':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaiKhoanPage(user: user),
                        ),
                      );
                      break;
                    case 'Settings':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SettingsPage2()),
                      );
                      break;
                    case 'Sign Out':
                      _showLogoutDialog(context);
                      break;
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 16,
                  ),
                  child: Text(item, style: const TextStyle(fontSize: 18)),
                ),
              ),
            )
            .toList(),
  );
}

final List<String> _menuItems = <String>[
  'Account',
  'About',
  'Contact',
  'Settings',
  'Sign Out',
];

enum Menu { itemOne, itemTwo, itemThree }

class _ProfileIcon extends StatelessWidget {
  final UserModel user;

  const _ProfileIcon({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
      icon: const Icon(Icons.person),
      offset: const Offset(0, 40),
      onSelected: (Menu item) {
        if (item == Menu.itemOne) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TaiKhoanPage(user: user)),
          );
        } else if (item == Menu.itemThree) {
          MenuInPage(user: user)._showLogoutDialog(context);
        }
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<Menu>>[
            const PopupMenuItem<Menu>(
              value: Menu.itemOne,
              child: Text('Tài khoản'),
            ),
            const PopupMenuItem<Menu>(
              value: Menu.itemTwo,
              child: Text('Cài đặt'),
            ),
            const PopupMenuItem<Menu>(
              value: Menu.itemThree,
              child: Text('Đăng xuất'),
            ),
          ],
    );
  }
}

class _UserHeader extends StatelessWidget {
  final UserModel user;

  const _UserHeader({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 183, 183, 183),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(255, 227, 227, 227),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                foregroundColor: Colors.white,
                radius: 40,
                child: Text("ảnh", style: TextStyle(color: Colors.black)),
                backgroundColor: const Color.fromARGB(255, 205, 205, 205),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(221, 0, 0, 0),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${user.username}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color.fromARGB(255, 40, 40, 40),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[800]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final UserModel user;

  const _QuickActions({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ActionButton(
                icon: Icons.person,
                label: 'Hồ sơ',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TaiKhoanPage(user: user)),
                  );
                },
              ),
              _ActionButton(
                icon: Icons.settings,
                label: 'Cài đặt',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SettingsPage2()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ActionButton(
            icon: Icons.logout,
            label: 'Đăng xuất',
            onTap: () {
              MenuInPage(user: user)._showLogoutDialog(context);
            },
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isFullWidth;

  const _ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isFullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlue[700],
        padding:
            isFullWidth
                ? const EdgeInsets.symmetric(horizontal: 20, vertical: 15)
                : const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize:
            isFullWidth ? const Size(double.infinity, 50) : const Size(120, 50),
      ),
    );
  }
}
