import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/sales_module/model/employee_model.dart';

class AllEmployeeProvider extends ChangeNotifier{

  List<EmployeeModel> allEmployeeList = [];
  fetchEmployee(
      BuildContext context,
      {String? dateFrom,
        String? dateTo,
        String? customerId,
        String? employeeId,
        productId,
        String? userFullName}) async {
    allEmployeeList =
    await ApiService.fetchAllEmployee(
        dateFrom, dateTo, customerId, employeeId, productId, userFullName);
    // return By_all_employee_ModelClass_List;
    notifyListeners();
  }

}