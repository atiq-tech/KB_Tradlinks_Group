import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/sales_module/model/sales_record_model.dart';

class SalesRecordProvider extends ChangeNotifier {

  static bool isSearchTypeChange = false;

  List<SalesRecordModel> getSalesRecordlist = [];
  getSalesRecord(
      BuildContext context,
      String? customerId,
      String? dateFrom,
      String? dateTo,
      String? employeeId,
      String? userFullName,
      ) async {
    getSalesRecordlist = await ApiService.fetchSalesRecord(context,customerId,dateFrom,dateTo,employeeId,userFullName);
    off();
    notifyListeners();
  }

  off(){
    Future.delayed(Duration(seconds: 1),() {
      print('offff');
      isSearchTypeChange = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isSearchTypeChange = true;
    notifyListeners();
  }
}