// 2. Open/Closed Principle

import 'package:smart_ahwa/models/order.dart';

abstract class OrderStorage {
  void addOrder(Order order);
  List<Order> getAllOrders();
}

class OrderManager implements OrderStorage {
  static final List<Order> _orders = [];

  @override
  void addOrder(Order order) {
    _orders.add(order);
  }

  @override
  List<Order> getAllOrders() {
    return _orders;
  }

  List<Order> getPendingOrders() {
    return _orders.where((order) => !order.isCompleted).toList();
  }
}
