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

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserBloc(UserService())..add(FetchUsers()),
      child: Scaffold(
        appBar: AppBar(title: Text('Login'),automaticallyImplyLeading: false, centerTitle: true,),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'username'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final inputUsername =
                            _usernameController.text.trim().toLowerCase();
                        final matchedUser = state.users.firstWhere(
                          (user) =>
                              user.username.toLowerCase() == inputUsername,
                          orElse:
                              () => UserModel(
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
                            SnackBar(content: Text('Invalid username')),
                          );
                        }
                      },
                      child: Text('Login'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => RegisterScreen()),
                        );
                      },
                      child: Text("Bạn chưa có tài khoản? Đăng ký"),
                    ),
                  ],
                ),
              );
            } else if (state is UserError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return Center(child: Text('Initializing...'));
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
