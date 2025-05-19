import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/users/user_bloc.dart';
import '../bloc/users/user_event.dart';
import '../bloc/users/user_state.dart';
import '../models/userModel.dart';
import '../services/user_service.dart';

class TaiKhoanPage extends StatelessWidget {
  final UserModel user;

  const TaiKhoanPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserBloc(UserService())..add(FetchUsers()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tài Khoản'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              final currentUser = state.users.firstWhere(
                (u) => u.id == user.id,
                orElse: () => user,
              );
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 200, // Fixed height for _TopPortion
                      child: _TopPortion(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            currentUser.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '@${currentUser.username}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 16),
                          _ProfileInfoCard(user: currentUser),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is UserError) {
              return Center(child: Text('Lỗi: ${state.message}'));
            }
            return const Center(child: Text('Đang khởi tạo...'));
          },
        ),
      ),
    );
  }
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 9, 178, 234),
                Color.fromARGB(255, 12, 139, 189),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(255, 227, 227, 227),
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Text(
                      'ảnh',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final UserModel user;

  const _ProfileInfoCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _InfoItem(
              icon: Icons.perm_identity,
              label: 'ID',
              value: user.id.toString(),
            ),
            const Divider(),
            _InfoItem(icon: Icons.email, label: 'Email', value: user.email),
            const Divider(),
            _InfoItem(
              icon: Icons.phone,
              label: 'Số điện thoại',
              value: user.phone,
            ),
            const Divider(),
            _InfoItem(
              icon: Icons.location_on,
              label: 'Địa chỉ',
              value:
                  '${user.address.street}, ${user.address.suite}, ${user.address.city}, ${user.address.zipcode}',
            ),
            const Divider(),
            _InfoItem(
              icon: Icons.map,
              label: 'Tọa độ',
              value:
                  'Lat: ${user.address.geo.lat}, Lng: ${user.address.geo.lng}',
            ),
            const Divider(),
            _InfoItem(
              icon: Icons.business,
              label: 'Công ty',
              value: user.company.name,
            ),
            const Divider(),
            _InfoItem(
              icon: Icons.description,
              label: 'Sứ mệnh công ty',
              value: user.company.catchPhrase,
            ),
            const Divider(),
            _InfoItem(
              icon: Icons.work,
              label: 'Lĩnh vực',
              value: user.company.bs,
            ),
            const Divider(),
            _InfoItem(icon: Icons.web, label: 'Website', value: user.website),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}