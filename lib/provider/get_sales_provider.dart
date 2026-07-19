import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/sales_module/model/get_sales_model.dart';

class GetSalesProvider extends ChangeNotifier {

  static bool isSearchTypeChange = false;

  List<GetSalesModel> getSaleslist = [];
  getGatSales(
      BuildContext context,
      String? customerId,
      String? dateFrom,
      String? dateTo,
      String? employeeId,
      String? userFullName,
      ) async {
    getSaleslist = await ApiService.fetchGetSales(context,customerId,dateFrom,dateTo,employeeId,userFullName);
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
