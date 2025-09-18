import 'package:meta/meta.dart';

abstract class Drink {
  const Drink();
  String get name;
}

class Shai extends Drink {
  const Shai() : super();
  @override
  String get name => 'Shai';
}

class TurkishCoffee extends Drink {
  const TurkishCoffee() : super();
  @override
  String get name => 'Turkish Coffee';
}

class HibiscusTea extends Drink {
  const HibiscusTea() : super();
  @override
  String get name => 'Hibiscus Tea';
}

// Singleton instances to ensure identity equality works in dropdowns
const Shai kShai = Shai();
const TurkishCoffee kTurkishCoffee = TurkishCoffee();
const HibiscusTea kHibiscusTea = HibiscusTea();

const List<Drink> kAvailableDrinks = <Drink>[
  kShai,
  kTurkishCoffee,
  kHibiscusTea,
];

@immutable
class CustomerName {
  final String value;
  const CustomerName._(this.value);
  factory CustomerName(String raw) {
    final v = raw.trim();
    if (v.isEmpty) throw ArgumentError('Customer name cannot be empty');
    return CustomerName._(v);
  }
  @override
  String toString() => value;
}

enum OrderStatus { pending, completed }

@immutable
class Order {
  final String id;
  final CustomerName customer;
  final Drink drink;
  final String? specialInstructions;
  final DateTime createdAt;
  final OrderStatus status;

  const Order({
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

@immutable
class Report {
  final int totalOrders;
  final Map<String, int> topByDrink;
  const Report({required this.totalOrders, required this.topByDrink});
}


