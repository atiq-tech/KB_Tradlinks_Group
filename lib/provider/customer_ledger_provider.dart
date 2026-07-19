import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/report_module/model/customer_ledger_model.dart';

class CustomerPaymentReportProvider extends ChangeNotifier {
  List<CustomerLedgerModel> customerPaymentReportList = [];
  static bool isLoading = false;

  getCustomerLedgerList(BuildContext context,
      {String? customerId, String? dateFrom, String? dateTo,}) async {
    customerPaymentReportList = await ApiService.fetchCustomerLedger(context, customerId,dateFrom,dateTo);
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
}
