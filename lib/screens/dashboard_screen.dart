import 'package:flutter/material.dart';
import 'package:smart_ahwa/models/OrderStorage.dart';
import 'package:smart_ahwa/models/reportService.dart';
import 'package:smart_ahwa/screens/order_screen.dart';
import 'package:smart_ahwa/screens/pending_ordersScreen.dart';


class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final OrderStorage orderManager = OrderManager();
  late final ReportService reports;

  @override
  void initState() {
    super.initState();
    reports = ReportService(orderManager);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Coffee Shop')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Dashboard Stats
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'إجمالي الطلبات: ${reports.getTotalOrders()}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'معلقة: ${reports.getPendingOrders()}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'الأكثر مبيعاً: ${reports.getTopSellingDrink()}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            // Buttons
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => OrderScreen()),
                );
                setState(() {});
              },
              child: Text('طلب جديد'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 10),

            OutlinedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PendingOrdersScreen()),
                );
                setState(() {});
              },
              child: Text('الطلبات المعلقة'),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
