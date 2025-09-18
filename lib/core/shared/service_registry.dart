import 'package:flutter/widgets.dart';

import '../orders/application/services.dart';
import '../orders/data/order_repository.dart';

class ServiceRegistry extends InheritedWidget {
  final InMemoryOrderRepository orderRepository;
  final OrderService orderService;
  final ReportService reportService;

  ServiceRegistry({key, required Widget child})
    : this._(repo: InMemoryOrderRepository(), child: child);

  ServiceRegistry._({
    required InMemoryOrderRepository repo,
    required super.child,
  }) : orderRepository = repo,
       orderService = OrderService(repo),
       reportService = ReportService(repo);

  static ServiceRegistry of(BuildContext context) {
    final registry = context
        .dependOnInheritedWidgetOfExactType<ServiceRegistry>();
    assert(registry != null, 'ServiceRegistry not found in context');
    return registry!;
  }

  @override
  bool updateShouldNotify(covariant ServiceRegistry oldWidget) => false;
}
