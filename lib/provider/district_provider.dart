import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/sales_module/model/distric_model.dart';

class AllDistrictProvider extends ChangeNotifier{

  List<DistrictModel> allDistrictList = [];
  getDistrict() async {
    allDistrictList =
    await ApiService.fetchAllDistrict();
    notifyListeners();
  }

}