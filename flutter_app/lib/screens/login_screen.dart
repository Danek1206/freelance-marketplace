import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  String _userType = 'freelancer';
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    setState(() => _isLoading = true);

    bool success;
    if (_isLogin) {
      success = await auth.login(_emailController.text, _passwordController.text);
    } else {
      success = await auth.register(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _userType,
      );
    }

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Успешно!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Фриланс Маркетплейс',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (!_isLogin)
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Имя',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              if (!_isLogin) const SizedBox(height: 16),
              if (!_isLogin)
                DropdownButton<String>(
                  isExpanded: true,
                  value: _userType,
                  items: const [
                    DropdownMenuItem(value: 'freelancer', child: Text('Фрилансер')),
                    DropdownMenuItem(value: 'client', child: Text('Заказчик')),
                  ],
                  onChanged: (value) => setState(() => _userType = value ?? 'freelancer'),
                ),
              if (!_isLogin) const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: Text(_isLogin ? 'Вход' : 'Регистрация'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(_isLogin ? 'Создать аккаунт' : 'Уже есть аккаунт?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
