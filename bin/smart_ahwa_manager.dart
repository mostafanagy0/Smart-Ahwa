// Self-contained console app: models, repository, services, and main in one file

// ===== Domain =====
abstract class Drink {
  String get name;
}

class Shai extends Drink {
  @override
  String get name => 'Shai';
}

class TurkishCoffee extends Drink {
  @override
  String get name => 'Turkish Coffee';
}

class HibiscusTea extends Drink {
  @override
  String get name => 'Hibiscus Tea';
}

class CustomerName {
  final String value;
  CustomerName(String raw) : value = raw.trim() {
    if (value.isEmpty) {
      throw ArgumentError('Customer name cannot be empty');
    }
  }
  @override
  String toString() => value;
}

enum OrderStatus { pending, completed }

class Order {
  final String id;
  final CustomerName customer;
  final Drink drink;
  final String? specialInstructions;
  final DateTime createdAt;
  final OrderStatus status;

  Order({
    required this.id,
    required this.customer,
    required this.drink,
    this.specialInstructions,
    required this.createdAt,
    this.status = OrderStatus.pending,
  });

  Order markCompleted() => Order(
    id: id,
    customer: customer,
    drink: drink,
    specialInstructions: specialInstructions,
    createdAt: createdAt,
    status: OrderStatus.completed,
  );
}

class Report {
  final int totalOrders;
  final Map<String, int> topByDrink;
  Report({required this.totalOrders, required this.topByDrink});
}

// ===== Repository =====
abstract class OrderRepository {
  Future<Order> add(Order order);
  Future<void> update(Order order);
  Future<Order?> getById(String id);
  Future<List<Order>> all();
}

class InMemoryOrderRepository implements OrderRepository {
  final Map<String, Order> _orders = {};

  @override
  Future<Order> add(Order order) async {
    _orders[order.id] = order;
    return order;
  }

  @override
  Future<void> update(Order order) async {
    _orders[order.id] = order;
  }

  @override
  Future<Order?> getById(String id) async => _orders[id];

  @override
  Future<List<Order>> all() async =>
      _orders.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}

// ===== Services =====
class OrderService {
  final OrderRepository _repository;
  OrderService(this._repository);

  Future<Order> createOrder({
    required CustomerName customer,
    required Drink drink,
    String? specialInstructions,
  }) async {
    final order = Order(
      id: 'o_${DateTime.now().millisecondsSinceEpoch}_${_repository.hashCode}',
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

void main() async {
  print('=== Smart Ahwa Manager (Console) ===');

  final repo = InMemoryOrderRepository();
  final orderService = OrderService(repo);
  final reportService = ReportService(repo);

  // Add sample orders
  final o1 = await orderService.createOrder(
    customer: CustomerName('Ahmed'),
    drink: Shai(),
    specialInstructions: 'extra mint, ya rais',
  );
  final o2 = await orderService.createOrder(
    customer: CustomerName('Mona'),
    drink: TurkishCoffee(),
    specialInstructions: 'no sugar',
  );
  final o3 = await orderService.createOrder(
    customer: CustomerName('Youssef'),
    drink: HibiscusTea(),
    specialInstructions: null,
  );

  print('\nAdded Orders:');
  for (final o in await orderService.getAll()) {
    _printOrder(o);
  }

  // Mark one as completed
  await orderService.markCompleted(o2.id);
  print('\nMarked completed: ${o2.id}');

  // Show pending orders
  final pending = (await orderService.getAll())
      .where((o) => o.status == OrderStatus.pending)
      .toList();
  print('\nPending Orders:');
  if (pending.isEmpty) {
    print('  No pending orders.');
  } else {
    for (final o in pending) {
      _printOrder(o);
    }
  }

  // Generate simple report
  final report = await reportService.generateDailyReport(DateTime.now());
  print('\n=== Daily Report ===');
  print('Total orders: ${report.totalOrders}');
  if (report.topByDrink.isEmpty) {
    print('No sales yet for today');
  } else {
    print('Top-selling drinks:');
    final entries = report.topByDrink.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    for (final e in entries) {
      print('  ${e.key}: ${e.value}');
    }
  }
}

void _printOrder(Order o) {
  final status = o.status == OrderStatus.pending ? 'PENDING' : 'DONE';
  final note = (o.specialInstructions == null || o.specialInstructions!.isEmpty)
      ? ''
      : ' | Notes: ${o.specialInstructions}';
  print('  [$status] ${o.id} | ${o.customer} -> ${o.drink.name}$note');
}
