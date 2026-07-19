import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/sales_module/model/current_stock_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentStockProvider extends ChangeNotifier{

static bool isLoading = false;
  List<CurrentStockModel> getCurrentStocklist = [];
  getCurrentStock(BuildContext context, String stockType) async {
    getCurrentStocklist = await ApiService.fetchCurrentStock(context, stockType);
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(Duration(seconds: 1),() {
      print('offff');
      isLoading = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isLoading = true;
    notifyListeners();
  }

  List<CurrentStockModel> dataModels = [];

  Future<List<CurrentStockModel>> getDataFromLocal() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonData = prefs.getString('data');
  print('asdfkhasdkjf $jsonData');
  if (jsonData != null) {
    final dataList = json.decode(jsonData) as List<dynamic>;
    dataModels = dataList.map((data) => CurrentStockModel.fromJson(data)).toList().where((element) => element.currentQuantity !='0.000' && !element.currentQuantity.startsWith("-")).toList();
    print('asdfkhasdkjf ${dataModels.length}');
    return dataModels;
  }
  return dataModels;
}


}