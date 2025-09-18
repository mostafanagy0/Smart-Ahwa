import 'dart:math';

import '../data/order_repository.dart';
import '../domain/models.dart';

class OrderService {
  final OrderRepository _repository;
  OrderService(this._repository);

  Future<Order> createOrder({
    required CustomerName customer,
    required Drink drink,
    String? specialInstructions,
  }) async {
    final id = 'o_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1 << 32)}';
    final order = Order(
      id: id,
      customer: customer,
      drink: drink,
      specialInstructions: (specialInstructions?.trim().isEmpty ?? true)
          ? null
          : specialInstructions!.trim(),
      createdAt: DateTime.now(),
    );
    return _repository.add(order);
  }

  Future<void> markCompleted(String id) async {
    final current = await _repository.getById(id);
    if (current == null) return;
    await _repository.update(current.markCompleted());
  }

  Stream<List<Order>> watchOrders() => _repository.watchAll();
  Future<List<Order>> getAll() => _repository.all();
}

class ReportService {
  final OrderRepository _repository;
  ReportService(this._repository);

  Future<Report> generateDailyReport(DateTime day) async {
    final all = await _repository.all();
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final todays = all.where(
      (o) => o.createdAt.isAfter(start) && o.createdAt.isBefore(end),
    );
    final counts = <String, int>{};
    for (final o in todays) {
      counts[o.drink.name] = (counts[o.drink.name] ?? 0) + 1;
    }
    return Report(totalOrders: todays.length, topByDrink: counts);
  }
}


