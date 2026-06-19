import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  static const String _apiUrl = 'https://your-backend-url.com';
  
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;
  
  String _selectedLevel = 'all';
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      String url = '$_apiUrl/orders?';
      
      if (_selectedLevel != 'all') {
        url += 'level=$_selectedLevel&';
      }
      if (_selectedCategory != 'all') {
        url += 'category=$_selectedCategory&';
      }
      
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _orders = List<Map<String, dynamic>>.from(jsonDecode(response.body));
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading orders: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заказы'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Фильтры
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _selectedLevel,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Уровень: Все')),
                    DropdownMenuItem(value: 'beginner', child: Text('Новичок')),
                    DropdownMenuItem(value: 'intermediate', child: Text('Опытный')),
                    DropdownMenuItem(value: 'expert', child: Text('Эксперт')),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedLevel = value ?? 'all');
                    _loadOrders();
                  },
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Категория: Все')),
                    DropdownMenuItem(value: 'design', child: Text('Дизайн')),
                    DropdownMenuItem(value: 'programming', child: Text('Программирование')),
                    DropdownMenuItem(value: 'copywriting', child: Text('Копирайтинг')),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedCategory = value ?? 'all');
                    _loadOrders();
                  },
                ),
              ],
            ),
          ),
          // Список заказов
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _orders.isEmpty
                    ? const Center(child: Text('Нет заказов'))
                    : ListView.builder(
                        itemCount: _orders.length,
                        itemBuilder: (context, index) {
                          final order = _orders[index];
                          return OrderCard(order: order);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        title: Text(order['title'] ?? 'Заголовок'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(order['description'] ?? ''),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${order['budget']} ₽', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(order['required_level'] ?? ''),
              ],
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OrderDetailScreen(orderId: order['id']),
            ),
          );
        },
      ),
    );
  }
}

class OrderDetailScreen extends StatelessWidget {
  final int orderId;

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Детали заказа')),
      body: Center(
        child: Text('Order ID: $orderId'),
      ),
    );
  }
}
