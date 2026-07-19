import 'package:flutter/material.dart';
import 'package:kbtradlink/api_service/api_service.dart';
import 'package:kbtradlink/model/home_topdata_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTopDataProvider extends ChangeNotifier {

  HomeTopDataModel? homeTopDataModel;
  SharedPreferences? sharedPreferences;

  Future<HomeTopDataModel?>getHomeTopDataProvider(context) async {
    homeTopDataModel = await ApiService.fetchHomeTopData(context);
    // notifyListeners();
    return homeTopDataModel;
  }
}
