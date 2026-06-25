import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shopping_list/helpers/url.dart';
import 'package:shopping_list/models/grocery_item.dart';

class NetworkRequests {
  NetworkRequests._();

  static Future<List<GroceryItem>> getItems() async {
    try {
      final response = await http.get(Url.shoppingList);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data.entries
            .map((item) => GroceryItem.fromJson(json: item.value, id: item.key))
            .toList();
      }
      if(response.statusCode >= 400) {
        throw Exception('Failed to get grocery items, please try again latter!');
      }
      return List<GroceryItem>.of([]);
    } catch (e) {
      throw Exception('Error:: $e');
    }
  }

  static Future<String> addItem(GroceryItem groceryItem) async {
    try {
      final response = await http.post(
        Url.shoppingList,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(groceryItem.toJson()),
      );
      return jsonDecode(response.body)['name'];
    } catch (e) {
      throw Exception('Error:: $e');
    }
  }

  static Future<void> deleteItem(String id) async {
    try {
      final response = await http.delete(Url.getDeleteUrl(id));
      if(response.statusCode >= 400) {
        throw Exception('Error:: ${response.statusCode}');
      }
    } catch(e) {
      throw Exception('Error:: $e');
    }
  }
}
