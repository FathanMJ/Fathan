import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/order.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final List<Order> _orders = [
    Order(orderId: 'MUARA-001', date: DateTime.now().subtract(const Duration(days: 1)), status: OrderStatus.completed, total: 250000, itemCount: 2),
    Order(orderId: 'MUARA-002', date: DateTime.now().subtract(const Duration(days: 5)), status: OrderStatus.shipped, total: 179000, itemCount: 1),
    Order(orderId: 'MUARA-003', date: DateTime.now().subtract(const Duration(days: 10)), status: OrderStatus.processing, total: 520000, itemCount: 3),
    Order(orderId: 'MUARA-004', date: DateTime.now().subtract(const Duration(days: 12)), status: OrderStatus.pending, total: 89000, itemCount: 1),
  ];

  OrderStatus? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _orders.where((order) {
      if (_selectedFilter == null) return true;
      return order.status == _selectedFilter;
    }).toList();

    return Column(
      children: [
        _buildFilterChips(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: ListTile(
                  title: Text('Order #${order.orderId}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${order.itemCount} produk - ${DateFormat('d MMM yyyy').format(order.date)}'),
                  trailing: Text(NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(order.total)),
                  onTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0,
        children: [
          FilterChip(label: const Text('Semua'), selected: _selectedFilter == null, onSelected: (selected) => setState(() => _selectedFilter = null)),
          FilterChip(label: const Text('Pending'), selected: _selectedFilter == OrderStatus.pending, onSelected: (selected) => setState(() => _selectedFilter = OrderStatus.pending)),
          FilterChip(label: const Text('Diproses'), selected: _selectedFilter == OrderStatus.processing, onSelected: (selected) => setState(() => _selectedFilter = OrderStatus.processing)),
          FilterChip(label: const Text('Dikirim'), selected: _selectedFilter == OrderStatus.shipped, onSelected: (selected) => setState(() => _selectedFilter = OrderStatus.shipped)),
          FilterChip(label: const Text('Selesai'), selected: _selectedFilter == OrderStatus.completed, onSelected: (selected) => setState(() => _selectedFilter = OrderStatus.completed)),
        ],
      ),
    );
  }
}
