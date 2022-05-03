import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../models/consumption_chart_data.dart';
import '../models/consumption_item.dart';
import '../models/http_exception.dart';
import '../models/shared_data.dart' show Urls;

class Consumptions with ChangeNotifier {
  List<ConsumptionItem> _items = [];
  List<ConsumptionItem> _filteredItems = [];
  int month = DateTime.now().month;
  int year = DateTime.now().year;

  String? authToken;
  String? userId;

  Consumptions(this._items, {this.authToken, this.userId});

  List<ConsumptionItem> get items {
    return [..._items];
  }

  List<ConsumptionItem> get filteredItems {
    return [..._filteredItems];
  }

  void filterItmes(int month, int year) {
    month = month;
    year = year;
    _filteredItems = _items
        .where((element) =>
            DateFormat.yMMMd().parse(element.date).month == month &&
            DateFormat.yMMMd().parse(element.date).year == year)
        .toList();
    notifyListeners();
  }

  Map<String, dynamic> getCostsPerMonth() {
    double totalAmount = 0;
    double totalLiters = 0;
    double avgPrice = 0;

    for (var element in _filteredItems) {
      totalAmount = totalAmount + element.amount;
      totalLiters = totalLiters + element.total;
      avgPrice = double.parse((totalAmount / totalLiters).toStringAsFixed(2));
    }

    var result = {
      'totalAmount': totalAmount.toStringAsFixed(2),
      'totalLiters': totalLiters.toStringAsFixed(2),
      'avgPrice': avgPrice
    };
    return result;
  }

  Future<void> fetchConsumption() async {
    var url = Uri.parse(
        '${Urls.consumptions}.json?auth=$authToken&orderBy="userId"&equalTo="$userId"');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;

      if (extractedData == null) {
        return;
      }

      List<ConsumptionItem> loadedItems = [];

      extractedData.forEach((id, data) {
        var temp = data as Map<String, dynamic>;
        temp.addAll({'id': id});

        loadedItems.add(ConsumptionItem.fromMap(temp));
      });
      _items = loadedItems;
      filterItmes(month, year);
      // notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addConsumptionItem(ConsumptionItem item) async {
    var url = Uri.parse('${Urls.consumptions}.json?auth=$authToken');
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
  }

  ConsumptionItem? getConsumptionById(String id) {
    var index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      return _items.firstWhere((element) => element.id == id);
    }
    return null;
  }

  Future<void> deleteConsumption(String id) async {
    var url = Uri.parse('${Urls.consumptions}/$id.json?auth=$authToken');

    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex == -1) {
      return;
    }

    ConsumptionItem? item = _items[productIndex];
    _items.removeAt(productIndex);
    filterItmes(month, year);
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(productIndex, item);
      filterItmes(month, year);
      throw HttpException('Could not delete consumption.');
    }
    item = null;
  }

  List<ConsmumptionChartData> prepareChartData(int year) {
    var months = List.generate(12, (index) => index + 1);

    List<ConsmumptionChartData> result = [];
    for (var month in months) {
      double monthExpense = 0;
      double liters = 0;
      var monthConsumptions = _items
          .where((element) =>
              DateFormat.yMMMd().parse(element.date).month == month &&
              DateFormat.yMMMd().parse(element.date).year == year)
          .toList();
      for (var element in monthConsumptions) {
        monthExpense += element.amount;
        liters += element.total;
      }
      result.add(ConsmumptionChartData(
          month:
              DateFormat.MMM().format(DateFormat('M').parse(month.toString())),
          expense: monthExpense,
          liters: liters));
    }
    return result;
  }
}
