import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getx_app2/screens/homeScreen.dart';
import 'package:getx_app2/screens/signup.dart';
import '../bloc/users/user_bloc.dart';
import '../bloc/users/user_event.dart';
import '../bloc/users/user_state.dart';
import '../services/user_service.dart';
import '../models/userModel.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _fadeIn = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserBloc(UserService())..add(FetchUsers()),
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Dark overlay
            Container(
              color: Colors.black.withOpacity(0.2),
            ),
            // Form content
            Center(
              child: FadeTransition(
                opacity: _fadeIn,
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return CircularProgressIndicator();
                    } else if (state is UserLoaded) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.9),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 1,
                                offset: Offset(0, 1),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Đăng nhập",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Tên người dùng',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                  onPressed: () {
                                    final inputUsername = _usernameController.text.trim().toLowerCase();
                                    final matchedUser = state.users.firstWhere(
                                      (user) => user.username.toLowerCase() == inputUsername,
                                      orElse: () => UserModel(
                                        id: -1,
                                        name: '',
                                        username: '',
                                        email: '',
                                        phone: '',
                                        website: '',
                                        address: Address(
                                          street: '',
                                          suite: '',
                                          city: '',
                                          zipcode: '',
                                          geo: Geo(lat: '', lng: ''),
                                        ),
                                        company: Company(
                                          name: '',
                                          catchPhrase: '',
                                          bs: '',
                                        ),
                                      ),
                                    );

                                    if (matchedUser.id != -1) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => HomeScreen(user: matchedUser),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Tên người dùng không hợp lệ')),
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Đăng nhập',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => RegisterScreen()),
                                  );
                                },
                                child: Text(
                                  "Bạn chưa có tài khoản? Đăng ký",
                                  style: TextStyle(color: Colors.black87),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    } else if (state is UserError) {
                      return Text("Lỗi: ${state.message}");
                    }
                    return Text('Đang khởi tạo...');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
