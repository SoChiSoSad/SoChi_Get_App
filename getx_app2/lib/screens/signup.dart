import 'package:flutter/material.dart';
import 'package:getx_app2/screens/login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng ký tài khoản'), automaticallyImplyLeading: false, centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
              ElevatedButton(onPressed: _register, child: Text('Đăng ký')),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                },
                child: Text("Bạn đã có tài khoản? Đăng nhập ngay"),
              ),
            ],
          ),
        ),
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
          border: OutlineInputBorder(),
        ),
        validator:
            validator ??
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
