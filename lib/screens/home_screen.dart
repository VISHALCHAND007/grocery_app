import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/helpers/network_requests.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item.dart';
import 'package:shopping_list/widgets/not_found.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = false;
  late final theme = Theme.of(context);
  late final scaffoldMessenger = ScaffoldMessenger.of(context);


  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await NetworkRequests.getItems();
      setState(() {
        _groceryItems = response;
      });
    } catch (e) {
      if (kDebugMode) print("Error occurred while fetching items:: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addItem() async {
    final groceryItem = await Navigator.push<GroceryItem>(
      context,
      MaterialPageRoute(builder: (ctx) => const NewItem()),
    );
    if (groceryItem == null) return;

    setState(() {
      _groceryItems.add(groceryItem);
    });
  }

  void _removeItem(GroceryItem groceryItem) async {
    final itemInd = _groceryItems.indexOf(groceryItem);

    try {
      setState(() {
        _groceryItems.remove(groceryItem);
      });
      await NetworkRequests.deleteItem(groceryItem.id);
    } catch (e) {
      if (kDebugMode) print('Error while deleting:: $e');

      //removing the older messages
      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            'Error while deleting, please try again later',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
          showCloseIcon: true,
          closeIconColor: Colors.white,
          backgroundColor: theme.colorScheme.errorContainer,
        ),
      );
      setState(() {
        _groceryItems.insert(itemInd, groceryItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _groceryItems.isEmpty
        ? const NotFound()
        : Padding(
            padding: const .symmetric(horizontal: 10, vertical: 16),
            child: ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (ctx, ind) => Dismissible(
                key: ValueKey(_groceryItems[ind].id),
                background: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.errorContainer.withAlpha(120),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onDismissed: (direction) => _removeItem(_groceryItems[ind]),
                child: ListTile(
                  contentPadding: const .symmetric(vertical: 2, horizontal: 10),
                  leading: Container(
                    height: 20,
                    width: 20,
                    color: _groceryItems[ind].category.color,
                  ),
                  title: Text(_groceryItems[ind].name),
                  trailing: Text(
                    _groceryItems[ind].quantity.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          );

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Groceries')),
      body: content,
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
