import 'package:flutter/material.dart';

import '../../../core/orders/application/services.dart';
import '../../../core/orders/domain/models.dart';
import '../../../core/shared/service_registry.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final registry = ServiceRegistry.of(context);
    final OrderService orderService = registry.orderService;
    final ReportService reportService = registry.reportService;

    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('Smart Ahwa Manager'))),
      body: StreamBuilder<List<Order>>(
        stream: orderService.watchOrders(),
        builder: (context, snapshot) {
          final orders = snapshot.data ?? const <Order>[];
          final pending = orders
              .where((o) => o.status == OrderStatus.pending)
              .toList();
          if (pending.isEmpty) {
            return const Center(child: Text('No pending orders.'));
          }
          return ListView.separated(
            itemCount: pending.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final order = pending[index];
              return ListTile(
                title: Text('${order.customer} - ${order.drink.name}'),
                subtitle: order.specialInstructions == null
                    ? null
                    : Text(order.specialInstructions!),
                trailing: IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () => orderService.markCompleted(order.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'report',
            onPressed: () async {
              final report = await reportService.generateDailyReport(
                DateTime.now(),
              );
              // Show simple dialog
              // ignore: use_build_context_synchronously
              showDialog(
                context: context,
                builder: (_) {
                  final entries = report.topByDrink.entries.toList()
                    ..sort((a, b) => b.value.compareTo(a.value));
                  return AlertDialog(
                    title: const Text('Daily Report'),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total orders: ${report.totalOrders}'),
                          const SizedBox(height: 8),
                          const Text('Top-selling drinks:'),
                          const SizedBox(height: 8),
                          if (entries.isEmpty)
                            const Text('No sales yet')
                          else
                            ...entries.map((e) => Text('${e.key}: ${e.value}')),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.bar_chart),
            label: const Text('Report'),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'add',
            onPressed: () async {
              await _showAddOrderDialog(context, orderService);
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Order'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddOrderDialog(
    BuildContext context,
    OrderService orderService,
  ) async {
    final nameCtrl = TextEditingController();
    final instCtrl = TextEditingController();
    Drink selected = kShai;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Customer Name'),
            ),
            const SizedBox(height: 8),
            DropdownButton<Drink>(
              value: selected,
              items: kAvailableDrinks
                  .map((d) => DropdownMenuItem(value: d, child: Text(d.name)))
                  .toList(),
              onChanged: (d) => selected = d ?? kShai,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: instCtrl,
              decoration: const InputDecoration(
                labelText: 'Special Instructions',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await orderService.createOrder(
                  customer: CustomerName(nameCtrl.text),
                  drink: selected,
                  specialInstructions: instCtrl.text,
                );
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              } catch (e) {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
