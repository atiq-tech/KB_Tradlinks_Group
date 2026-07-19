import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/screen/administation_module/model/unit_model.dart';

class UnitProvider extends ChangeNotifier {

  List<UnitModel> unitList = [];
  Future<List<UnitModel>>getUnit() async {
    return unitList = await ApiService.fetchUnit();
  }
}
