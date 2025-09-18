import 'package:flutter/material.dart';
import 'package:smart_ahwa/models/OrderStorage.dart';


class PendingOrdersScreen extends StatefulWidget {
  @override
  _PendingOrdersScreenState createState() => _PendingOrdersScreenState();
}

class _PendingOrdersScreenState extends State<PendingOrdersScreen> {
  final OrderManager orderManager = OrderManager();

  @override
  Widget build(BuildContext context) {
    final pendingOrders = orderManager.getPendingOrders();

    return Scaffold(
      appBar: AppBar(title: Text('الطلبات المعلقة')),
      body: pendingOrders.isEmpty
          ? Center(
              child: Text('كل الطلبات اتخلصت!', style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              itemCount: pendingOrders.length,
              itemBuilder: (context, index) {
                final order = pendingOrders[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(order.customerName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('المشروب: ${order.drinkType}'),
                        if (order.specialInstructions.isNotEmpty)
                          Text('تعليمات: ${order.specialInstructions}'),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          order.isCompleted = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('تم تجهيز طلب ${order.customerName}'),
                          ),
                        );
                      },
                      child: Text('تم'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
