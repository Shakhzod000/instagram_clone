import 'package:flutter/cupertino.dart';

class SearchProvider with ChangeNotifier{
  final TextEditingController searchController = TextEditingController();
  int? currentIndex =0;

  void updateStateSearch() => notifyListeners();
}