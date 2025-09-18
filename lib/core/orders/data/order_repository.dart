import 'dart:async';

import '../domain/models.dart';

abstract class OrderRepository {
  Future<Order> add(Order order);
  Future<void> update(Order order);
  Future<Order?> getById(String id);
  Future<List<Order>> all();
  Stream<List<Order>> watchAll();
}

class InMemoryOrderRepository implements OrderRepository {
  final Map<String, Order> _orders = {};
  final StreamController<List<Order>> _controller = StreamController.broadcast();

  void _emit() {
    final list = _orders.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _controller.add(list);
  }

  @override
  Future<Order> add(Order order) async {
    _orders[order.id] = order;
    _emit();
    return order;
  }

  @override
  Future<void> update(Order order) async {
    _orders[order.id] = order;
    _emit();
  }

  @override
  Future<Order?> getById(String id) async => _orders[id];

  @override
  Future<List<Order>> all() async => _orders.values.toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  @override
  Stream<List<Order>> watchAll() => _controller.stream;

  void dispose() {
    _controller.close();
  }
}


