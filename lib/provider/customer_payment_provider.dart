import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/acount_module/model/customer_payment_model.dart';

class CustomerPaymentProvider extends ChangeNotifier {

  static bool isLoading = false;

  List<CustomerPaymentModel> customerPaymentList = [];
  getAllCustomerPayment(
      String? customerId,
      String? dateFrom,
      String? dateTo,
      String? paymentType,
      ) async {
    customerPaymentList = await ApiService.fetchAllCustomerPayment(customerId,dateFrom,dateTo,paymentType);
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
