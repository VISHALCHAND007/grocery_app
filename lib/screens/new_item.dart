import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shopping_list/helpers/enums/categories.dart';
import 'package:shopping_list/helpers/network_requests.dart';

import '../data/categories.dart';
import '../models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _selectedTitle = '';
  var _selectedQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;
  var _isLoading = false;

  void _addDataToFirebase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final id = await NetworkRequests.addItem(
        GroceryItem(
          id: DateTime.now().toString(),
          name: _selectedTitle,
          quantity: _selectedQuantity,
          category: _selectedCategory,
        ),
      );
      if (mounted) {
        Navigator.pop(
          context,
          GroceryItem(
            id: id,
            name: _selectedTitle,
            quantity: _selectedQuantity,
            category: _selectedCategory,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _validateForm() {
    final isValid = _formKey.currentState?.validate();

    if (isValid != null && isValid) {
      _formKey.currentState?.save();

      _addDataToFirebase();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: const .all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: .text,
              maxLength: 50,
              decoration: const InputDecoration(label: Text('Name')),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 50) {
                  return 'Value must be in between 1 to 50.';
                }
                return null;
              },
              onSaved: (value) {
                _selectedTitle = value!;
              },
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: .end,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(label: Text('Quantity')),
                    initialValue: _selectedQuantity.toString(),
                    keyboardType: .number,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null ||
                          int.tryParse(value)! <= 0) {
                        return 'Must be a valid, positive value';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _selectedQuantity = int.parse(value!);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField(
                    initialValue: _selectedCategory,
                    items: [
                      for (final category in categories.entries)
                        DropdownMenuItem(
                          value: category.value,
                          child: Row(
                            children: [
                              Container(
                                height: 24,
                                width: 24,
                                color: category.value.color,
                              ),
                              const SizedBox(width: 6),
                              Text(category.value.name),
                            ],
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Row(
              mainAxisAlignment: .end,
              children: [
                TextButton(
                  onPressed: () {
                    _formKey.currentState?.reset();
                  },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: _validateForm,
                  child: const Text('Add Item'),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Add a new item')),
      body: content,
    );
  }
}
