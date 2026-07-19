import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/administation_module/model/customer_model.dart';

class CustomerListProvider extends ChangeNotifier {
  List<CustomerModel> customerList = [];
  static bool isCustomerTypeChange = false;

  getCustomerList(BuildContext context,
      {String? customerType}) async {
    customerList = await ApiService.fetchCustomerList(context, customerType);
    customerList.insert(0, CustomerModel(displayName: "General Customer"));
    off();
    notifyListeners();
  }
  off(){
    Future.delayed(Duration(seconds: 1),() {
      print('offff');
      isCustomerTypeChange = false;
      notifyListeners();
    },);
  }
  on(){
    print('onnn');
    isCustomerTypeChange = true;
    notifyListeners();
  }

}
