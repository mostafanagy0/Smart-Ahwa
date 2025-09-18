# Smart Ahwa Manager

A smart coffee shop management app built with Flutter that helps cafe owners manage orders, track popular items, and generate daily sales reports. The project features clean architecture with domain, data, application, and presentation layers, plus a standalone console app for testing business logic without UI.

## Features
- Add orders (customer name, drink type, special instructions)
- Mark orders as completed
- View pending orders with real-time updates
- Generate daily reports: total orders and top-selling drinks

## Project Structure
- `lib/core/orders/domain/models.dart`: Domain models with encapsulation, inheritance, and polymorphism (`CustomerName` value object, `Order` entity, `Drink` types)
- `lib/core/orders/data/order_repository.dart`: In-memory repository with `Stream` for real-time order tracking
- `lib/core/orders/application/services.dart`: Use case services (`OrderService`, `ReportService`) for business scenarios
- `lib/core/shared/service_registry.dart`: Simple dependency injection using `InheritedWidget`
- `lib/features/orders/presentation/dashboard_screen.dart`: Order dashboard with add, complete, and report functionality
- `bin/smart_ahwa_manager.dart`: Standalone console app for testing logic without UI


dart run bin/smart_ahwa_manager.dart
```

## Applied OOP & SOLID Principles
- **Encapsulation**: `CustomerName` class enforces name validation; `Order.markCompleted()` controls state transitions
- **Inheritance/Polymorphism**: `Drink` abstraction with subtypes (`Shai`, `TurkishCoffee`, `HibiscusTea`) used polymorphically in UI and services
- **Single Responsibility**: Each layer has clear responsibilities (models, repository, services, presentation)
- **Dependency Inversion**: Services depend on `OrderRepository` interface, wired at runtime via `ServiceRegistry`
- **Open/Closed**: Add new drink types or storage implementations without modifying existing logic

## Notes
- Uses singleton drink instances to avoid Dropdown identity equality issues
- Can replace in-memory repository with persistent storage (SQLite/Hive) by implementing new `OrderRepository` without changing services or UI