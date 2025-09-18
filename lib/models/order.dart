// 1. Single Responsibility Principle
class Order {
  final String customerName;
  final String drinkType;
  final String specialInstructions;
  bool isCompleted;

  Order({
    required this.customerName,
    required this.drinkType,
    this.isCompleted = false,
    required this.specialInstructions,
  });
}
