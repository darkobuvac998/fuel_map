import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/consumption_item.dart';
import '../models/http_exception.dart';
import '../models/shared_data.dart' show Urls;

class Consumptions with ChangeNotifier {
  List<ConsumptionItem> _items = [];

  List<ConsumptionItem> get items {
    return [..._items];
  }

  Future<void> fetchConsumption() async {
    var url = Uri.parse(Urls.consumptions);
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      List<ConsumptionItem> loadedItems = [];

      extractedData.forEach((id, data) {
        var temp = data as Map<String, dynamic>;
        temp.addAll({'id': id});

        loadedItems.add(ConsumptionItem.fromMap(temp));
      });
      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addConsumptionItem(ConsumptionItem item) async {
    var url = Uri.parse(Urls.consumptions);
    try {
      var data = item.toMap()..remove('id');
      final response = await http.post(url, body: json.encode(data));

      if (response.statusCode >= 400) {
        throw HttpException('Something went wrong');
      }

      data.addAll({'id': json.decode(response.body)['name']});
      _items.add(ConsumptionItem.fromMap(data));

      notifyListeners();
    } catch (error) {
      rethrow;
    }

    _items.add(item);
    notifyListeners();
  }

  ConsumptionItem? getConsumptionById(String id) {
    var index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      return _items.firstWhere((element) => element.id == id);
    }
    return null;
  }

  void deleteConsumption(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
