import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/sales_module/model/branch_model.dart';

class BranchProvider extends ChangeNotifier {
  List<BranchModel> branchList = [];
  getBranchData() async {
    branchList = await ApiService.fetchAllBranch();
    // return provideCategoryWiseStockList;
    notifyListeners();
  }
}
