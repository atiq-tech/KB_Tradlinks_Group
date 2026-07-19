import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/sales_module/model/customer_due_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CustomerDueListProvider extends ChangeNotifier {

  static bool isLoading = false;

  List<CustomerDueModel> getCustomerDuelist = [];
  getCustomerDue(String? customerId, String? customerType) async {
    getCustomerDuelist = await ApiService.fetchCustomerDue(customerId, customerType);
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

  List<CustomerDueModel> dataModels = [];

  Future<List<CustomerDueModel>> getDueDataFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString('dueData');
    print('asdfkhasdkjf $jsonData');
    if (jsonData != null) {
      final dataList = json.decode(jsonData) as List<dynamic>;
      dataModels = dataList.map((data) => CustomerDueModel.fromJson(data)).toList().where((element) => element.dueAmount !='0.00').toList()..sort((a, b) {
        return a.customerName.toLowerCase().compareTo(b.customerName.toLowerCase());
      });
      print('asdfkhasdkjf ${dataModels.length}');
      return dataModels;
    }
    return dataModels;
  }

}