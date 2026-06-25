import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category_model.dart';

class GroceryItem {
  final String id;
  final String name;
  final int quantity;
  final CategoryModel category;

  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });

  factory GroceryItem.fromJson({required Map<String, dynamic> json, required String id}) {
    final category = categories.entries
        .firstWhere((catItem) => catItem.value.name == json['category'])
        .value;
    return GroceryItem(
      id: id,
      name: json['name'] ?? 'Unknown',
      quantity: json['quantity'] ?? -1,
      category: category,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'category': category.name,
  };
}
