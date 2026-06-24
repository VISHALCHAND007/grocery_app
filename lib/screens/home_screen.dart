import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Groceries')),
      body: Column(
        children: [
          for (final grocery in groceryItems)
            ListTile(
              leading: Container(
                height: 20,
                width: 20,
                color: grocery.category.color,
              ),
              title: Text(grocery.name),
              trailing: Text(grocery.quantity.toString(), style: const TextStyle(fontSize: 16),),
            ),
        ],
      ),
    );
  }
}
