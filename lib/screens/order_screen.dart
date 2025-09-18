import 'package:flutter/material.dart';
import 'package:smart_ahwa/models/OrderStorage.dart';
import 'package:smart_ahwa/models/order.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _nameController = TextEditingController();
  final _instructionsController = TextEditingController();
  String _selectedDrink = 'شاي';
  final OrderStorage orderManager = OrderManager();

  final List<String> drinks = ['شاي', 'قهوة تركي', 'شاي كركديه', 'نعناع'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('طلب جديد')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'اسم الزبون',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: _selectedDrink,
              items: drinks
                  .map(
                    (drink) =>
                        DropdownMenuItem(value: drink, child: Text(drink)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedDrink = value!),
              decoration: InputDecoration(
                labelText: 'نوع المشروب',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),

            TextField(
              controller: _instructionsController,
              decoration: InputDecoration(
                labelText: 'تعليمات خاصة (مثال: نعناع زيادة يا رايس)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  orderManager.addOrder(
                    Order(
                      customerName: _nameController.text,
                      drinkType: _selectedDrink,
                      specialInstructions: _instructionsController.text,
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم إضافة الطلب يا ريس!')),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('إضافة الطلب'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
