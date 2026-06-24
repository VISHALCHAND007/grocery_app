import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item.dart';
import 'package:shopping_list/widgets/not_found.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.push<GroceryItem>(
      context,
      MaterialPageRoute(builder: (ctx) => const NewItem()),
    );
    if (newItem == null) return;

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Groceries')),
      body: _groceryItems.isEmpty ? const NotFound() : Padding(
        padding: const .symmetric(horizontal: 10, vertical: 16),
        child: Column(
          children: [
            for (final grocery in _groceryItems)
              Dismissible(
                key: ValueKey(grocery.id),
                background: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer.withAlpha(120),
                    borderRadius: BorderRadius.circular(12)
                  ),
                ),
                onDismissed: (direction) {
                  setState(() {
                    _groceryItems.remove(grocery);
                  });
                },
                child: ListTile(
                  contentPadding: const .symmetric(vertical: 2, horizontal: 10),
                  leading: Container(
                    height: 20,
                    width: 20,
                    color: grocery.category.color,
                  ),
                  title: Text(grocery.name),
                  trailing: Text(
                    grocery.quantity.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
