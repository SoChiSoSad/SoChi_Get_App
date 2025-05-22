import 'package:flutter/material.dart';
import 'package:getx_app2/screens/login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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

  void _register() {
    if (_formKey.currentState!.validate()) {
      int id = int.parse(_idController.text);
      String name = _nameController.text;
      String username = _usernameController.text;
      String email = _emailController.text;
      String phone = _phoneController.text;

      print('Đăng ký thành công:');
      print('ID: $id');
      print('Name: $name');
      print('Username: $username');
      print('Email: $email');
      print('Phone: $phone');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tài khoản đã được đăng ký (demo)')),
      );

      _formKey.currentState!.reset();
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.2),
          ),
          // Form
          Center(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Đăng ký tài khoản",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          _idController,
                          'ID',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập ID';
                            }
                            if (int.tryParse(value) == null) {
                              return 'ID phải là số';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(_nameController, 'Tên'),
                        _buildTextField(_usernameController, 'Tên đăng nhập'),
                        _buildTextField(
                          _emailController,
                          'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập email';
                            }
                            if (!value.contains('@')) {
                              return 'Email không hợp lệ';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          _phoneController,
                          'Số điện thoại',
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _register,
                            child: Text(
                              'Đăng ký',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => LoginScreen()),
                            );
                          },
                          child: Text(
                            "Bạn đã có tài khoản? Đăng nhập ngay",
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập $label';
              }
              return null;
            },
      ),
    );
  }
}
