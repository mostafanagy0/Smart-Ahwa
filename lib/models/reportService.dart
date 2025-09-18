// 3. Dependency Inversion Principle
import 'package:smart_ahwa/models/OrderStorage.dart';

class ReportService {
  final OrderStorage _storage;

  ReportService(this._storage);

  int getTotalOrders() => _storage.getAllOrders().length;

  int getPendingOrders() =>
      _storage.getAllOrders().where((order) => !order.isCompleted).length;
  String getTopSellingDrink() {
    final orders = _storage.getAllOrders();
    if (orders.isEmpty) return 'لا توجد مبيعات';

    final counts = <String, int>{};
    orders.forEach((o) => counts[o.drinkType] = (counts[o.drinkType] ?? 0) + 1);

    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}
