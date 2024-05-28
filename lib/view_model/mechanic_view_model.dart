// viewmodels/home_viewmodel.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/machenic_model.dart';


class HomeViewModel extends ChangeNotifier {
  List<Category>? data;
  Category? selectedCategory;
  Category? selectedSubCategory;
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;



  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://api.mechanicnow.in/api/show-service'));

    if (response.statusCode == 200) {
      data = (jsonDecode(response.body) as List)
          .map((i) => Category.fromJson(i))
          .toList();
      notifyListeners();
    } else {
      print("Failed to load data");
    }
  }

  void selectCategory(Category category) {
    selectedCategory = category;
    // selectedSubCategory = null;
    notifyListeners();
  }
  void selectSubCategory(Category subCategory) {
    selectedSubCategory = subCategory;
    notifyListeners();
  }

  void clearSelectedCategory() {
    selectedCategory = null;
    notifyListeners();
  }
}
