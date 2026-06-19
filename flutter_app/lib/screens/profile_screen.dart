import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final user = auth.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Аватар
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, size: 50),
                  ),
                ),
                const SizedBox(height: 24),
                // Имя
                Text(
                  user?['full_name'] ?? 'Неизвестный',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                // Email
                Text(
                  user?['email'] ?? 'нет email',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                // Карточки статистики
                _StatCard(label: 'Рейтинг', value: '4.8'),
                const SizedBox(height: 16),
                _StatCard(label: 'Завершено заказов', value: '15'),
                const SizedBox(height: 32),
                // Кнопки
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Редактировать профиль'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Мои заказы'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Купить премиум'),
                ),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: () async {
                    await auth.logout();
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                    }
                  },
                  child: const Text('Выход'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }
}
