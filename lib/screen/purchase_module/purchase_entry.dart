import 'dart:convert';

//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/model/purchase_api_model.dart';
import 'package:kbtradlink/provider/branch_provider.dart';
import 'package:kbtradlink/provider/category_provider.dart';
import 'package:kbtradlink/provider/category_wise_product_provider.dart';
import 'package:kbtradlink/provider/supplier_provider.dart';
import 'package:kbtradlink/utils/const_page.dart';
import 'package:kbtradlink/screen/sales_module/model/branch_model.dart';
import 'package:kbtradlink/screen/sales_module/model/category_model.dart';
import 'package:kbtradlink/screen/administation_module/model/product_model.dart';
import 'package:kbtradlink/screen/administation_module/model/supplier_model.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseEntryPage extends StatefulWidget {
  const PurchaseEntryPage({super.key});
  @override
  State<PurchaseEntryPage> createState() => _PurchaseEntryPageState();
}

class _PurchaseEntryPageState extends State<PurchaseEntryPage> {
  final _nameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _salesRateController = TextEditingController();
  final _Selling_PriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _VatController = TextEditingController();
  final _discountController = TextEditingController();
  final _paidController = TextEditingController();

  double TotalVat = 0;

  final _transportController = TextEditingController();
  final _ownTransportController = TextEditingController();



  String? categoryId;
  String? _selectedSupplier;
  String? _selectedProduct;
  String level = "Retails";
  String availableStock = "41 reem";

  double h1TextSize = 16.0;
  double h2TextSize = 12.0;
  double TotalAmount = 0;

  String? branchId;
  final branchController = TextEditingController();

  bool isVisible = false;
  bool isEnabled = false;

  final supplyerController = TextEditingController();
  final categoryController = TextEditingController();
  final productController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Provider.of<SupplierProvider>(context, listen: false).getSupplierList();
    Provider.of<BranchProvider>(context, listen: false).getBranchData();
    Provider.of<CategoryProvider>(context, listen: false).getCategoryData();
    Provider.of<CategoryWiseProductProvider>(context, listen: false)
        .getCategoryWiseProduct(isService: "", categoryId: '', branchId: '');

    _quantityController.text = "1";
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
  }

  Response? result;
  void dueReport(String? supplierId) async {
    print("Call Api $supplierId");
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    result = await Dio().post("${baseUrl}api/v1/getSupplierDue",
        data: {"supplierId": "$supplierId"},
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }));
    var data = jsonDecode(result?.data);

    if (data != null) {
      print("responses result========> ${data[0]['due']}");
      setState(() {
        Previousdue = double.parse("${data[0]['due']}");
      });
    }
  }

  Widget build(BuildContext context) {
    final allSupplier = Provider.of<SupplierProvider>(context).supplierList;
    final allCategory = Provider.of<CategoryProvider>(context).categoryList;
    final productList = Provider.of<CategoryWiseProductProvider>(context)
        .categoryWiseProductList;
    final allBranch = Provider.of<BranchProvider>(context).branchList;

    return Scaffold(
      appBar: const CustomAppBar(title: "Purchase Entry"),
      body: ModalProgressHUD(
        blur: 2,
        inAsyncCall: CategoryWiseProductProvider.isCustomerTypeChange,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    color: Colors.green[500],
                    child: const Center(
                      child: Text(
                        'Supplier & Product Information',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(left: 4.0, right: 4.0,top:4.0),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                        color: const Color.fromARGB(255, 7, 125, 180),
                        width: 1.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Date to :",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 126, 125, 125)),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onTap: () {
                                      _selectedDate();
                                    },
                                    child: Container(
                                      // margin:
                                      // const EdgeInsets.only(top: 5, bottom: 5),
                                      height: 30,
                                      width: double.infinity,
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5, left: 5, right: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 7, 125, 180),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            firstPickedDate == null
                                                ? Utils.formatFrontEndDate(
                                                    DateTime.now())
                                                : firstPickedDate!,
                                            style:
                                                const TextStyle(fontSize: 13.0),
                                          ),
                                          const Icon(
                                            Icons.calendar_month,
                                            size: 18,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                        color: const Color.fromARGB(255, 7, 125, 180),
                        width: 1.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(
                            0, 3), // changes the position of the shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Supplier     :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin:const EdgeInsets.only(bottom: 5, right:0),
                              height: 30,
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 7, 125, 180),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: TypeAheadFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                    onChanged: (value) {
                                      if (value == '') {
                                        _selectedSupplier = '';
                                      }
                                    },
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                    controller: supplyerController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(bottom: 12),
                                      hintText: 'Select Supplier',
                                      suffix: _selectedSupplier == ''
                                          ? null
                                          : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  supplyerController.text = '';
                                                });
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                    )),
                                suggestionsCallback: (pattern) {
                                  return allSupplier
                                      .where((element) => element.displayName
                                          .toString()
                                          .toLowerCase()
                                          .contains(
                                              pattern.toString().toLowerCase()))
                                      .take(allSupplier.length)
                                      .toList();
                                  // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                                },
                                itemBuilder: (context, suggestion) {
                                  return SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: Text(
                                        "${suggestion.displayName}",
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                },
                                transitionBuilder:
                                    (context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected:
                                    (SupplierModel suggestion) {
                                  supplyerController.text =
                                      suggestion.displayName!;
                                  setState(() {
                                    _selectedSupplier =
                                        suggestion.supplierSlNo.toString();
                                    if (_selectedSupplier == 'null') {
                                      print("No has not $_selectedSupplier");

                                      isVisible = true;
                                      isEnabled = true;
                                      _nameController.text = '';
                                      _mobileNumberController.text = '';
                                      _addressController.text = '';
                                    } else {
                                      print("Yes has $_selectedSupplier");

                                      isEnabled = false;
                                      isVisible = false;

                                      print(suggestion.supplierSlNo);
                                      print(isVisible);
                                      supplierId = suggestion.supplierSlNo;
                                      final results = [
                                        allSupplier
                                            .where((m) => m.supplierSlNo
                                                .toString()
                                                .contains(
                                                    '${suggestion.supplierSlNo}')) // or Testing 123
                                            .toList(),
                                      ];
                                      results.forEach((element) async {
                                        element.add(element.first);
                                        print(
                                            "supplierSlNo  ${element[0].supplierSlNo}");
                                        print(
                                            "supplierMobile  ${element[0].supplierMobile}");
                                        print(
                                            "supplierName  ${element[0].supplierName}");
                                        print(
                                            "supplierAddress  ${element[0].supplierAddress}");
                                        // print("previousDue  ${element[0].previousDue}");

                                        // Previousdue =double.parse("${element[0].previousDue}");
                                        _nameController.text =
                                            "${element[0].supplierName}";
                                        _mobileNumberController.text =
                                            "${element[0].supplierMobile}";
                                        _addressController.text =
                                            "${element[0].supplierAddress}";
                                        dueReport(supplierId);
                                      });
                                    }
                                  });
                                },
                                onSaved: (value) {},
                              ),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: isVisible,
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Text(
                                "Name         :",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 126, 125, 125)),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 30.0,
                                margin: const EdgeInsets.only(bottom: 5),
                                child: TextFormField(
                                  controller: _nameController,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value != null || value != '') {
                                      _nameController.text = value.toString();
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 7, 125, 180),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 7, 125, 180),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), // drop down
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Mobile No :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 30.0,
                              margin: const EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                style: const TextStyle(fontSize: 13),
                                controller: _mobileNumberController,
                                enabled: isEnabled,
                                validator: (value) {
                                  if (value != null || value != '') {
                                    _mobileNumberController.text =
                                        value.toString();
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      bottom: 18, left: 5),
                                  // filled: true,
                                  // fillColor: isEnabled == true ? Colors.white : Colors.grey[200],
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ), // mobile

                      Row(
                        children: [
                          const Text(
                            "Address    :",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                //minLines: 2,
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                                // maxLines: 2,
                                controller: _addressController,
                                validator: (value) {
                                  if (value != null || value != '') {
                                    _addressController.text = value.toString();
                                  }
                                  return null;
                                },
                                enabled: isEnabled,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      bottom: 18, left: 5),
                                  // filled: true,
                                  // fillColor: isEnabled == true
                                  //     ? Colors.white
                                  //     : Colors.grey[200],

                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      //address
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10.0),
                  padding:const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                        color: const Color.fromARGB(255, 7, 125, 180),
                        width: 1.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(
                            0, 3), // changes the position of the shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Warehouse :",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 30,
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              margin: const EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 7, 125, 180),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: TypeAheadFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                    onChanged: (value) {
                                      if (value == '') {
                                        branchId = '';
                                      }
                                    },
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color.fromARGB(255, 126, 125, 125),
                                    ),
                                    controller: branchController,
                                    decoration: InputDecoration(
                                      hintText: 'Select Warehouse',
                                      isDense: true,
                                      hintStyle: const TextStyle(fontSize: 13),
                                      suffix: branchId == ''
                                          ? null
                                          : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  branchController.text = '';
                                                });
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                    )),
                                suggestionsCallback: (pattern) {
                                  return allBranch
                                      .where((element) => element.brunchName
                                          .toString()
                                          .toLowerCase()
                                          .contains(
                                              pattern.toString().toLowerCase()))
                                      .take(allBranch.length)
                                      .toList();
                                  // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                                },
                                itemBuilder: (context, suggestion) {
                                  return SizedBox(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: Text(
                                      "${suggestion.brunchName}",
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ));
                                },
                                transitionBuilder:
                                    (context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected: (BranchModel suggestion) {
                                  branchController.text = "${suggestion.brunchName}";
                                  setState(() {
                                    branchId = suggestion.brunchId;
                                  });
                                },
                                onSaved: (value) {},
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Category   :",
                              style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 30,
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              margin: const EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 7, 125, 180),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: TypeAheadFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                    onChanged: (value) {
                                      if (value == '') {
                                        categoryId = '';
                                      }
                                    },
                                    style: const TextStyle(fontSize: 13),
                                    controller: categoryController,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(bottom: 12),
                                      hintText: 'Select Category',
                                      suffix: categoryId == '' ? null
                                          : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  categoryController.text = '';
                                                });
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 3),
                                                child: Icon(Icons.close,size: 14),
                                              ),
                                            ),
                                    )),
                                suggestionsCallback: (pattern) {
                                  return allCategory
                                      .where((element) => element
                                          .productCategoryName
                                          .toLowerCase()
                                          .contains(
                                              pattern.toString().toLowerCase()))
                                      .take(allCategory.length)
                                      .toList();
                                  // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                                },
                                itemBuilder: (context, suggestion) {
                                  return SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: Text(
                                        "${suggestion.productCategoryName}",
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                },
                                transitionBuilder:
                                    (context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected:
                                    (CategoryModel suggestion) {
                                  categoryController.text =
                                      suggestion.productCategoryName;
                                  setState(() {
                                    categoryId = suggestion.productCategorySlNo;
                                    print("dfhsghdfkhgkh $categoryId");
                                    CategoryWiseProductProvider().on();

                                    final results = [
                                      allCategory
                                          .where((m) => m.productCategorySlNo
                                              .contains(
                                                  '${suggestion.productCategorySlNo}')) // or Testing 123
                                          .toList(),
                                    ];
                                    results.forEach((element) async {
                                      element.add(element.first);
                                      productCategoryName =
                                          "${element[0].productCategoryName}";
                                    });
                                    print(productCategoryName);

                                    Provider.of<CategoryWiseProductProvider>(
                                            context,
                                            listen: false)
                                        .getCategoryWiseProduct(
                                            isService: "",
                                            categoryId: categoryId,
                                            branchId: branchId);
                                  });
                                },
                                onSaved: (value) {},
                              ),
                            ),
                          ),
                        ],
                      ), // category
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Product     :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 30,
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              margin: const EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 7, 125, 180),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: TypeAheadFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                    onChanged: (value) {
                                      if (value == '') {
                                        _selectedProduct = '';
                                      }
                                    },
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                    controller: productController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(bottom: 12),
                                      hintText: 'Select Product',
                                      suffix: _selectedProduct == ''
                                          ? null
                                          : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  productController.text = '';
                                                });
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                    )),
                                suggestionsCallback: (pattern) {
                                  return productList
                                      .where((element) => element.displayText
                                          .toLowerCase()
                                          .contains(
                                              pattern.toString().toLowerCase()))
                                      .take(productList.length)
                                      .toList();
                                  // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                                },
                                itemBuilder: (context, suggestion) {
                                  return SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: Text(
                                        suggestion.displayText,
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                },
                                transitionBuilder:
                                    (context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected:
                                    (ProductModel suggestion) {
                                  productController.text =
                                      suggestion.displayText;
                                  setState(() {
                                    _selectedProduct =
                                        suggestion.productSlNo.toString();

                                    print("dfhsghdfkhgkh $_selectedProduct");
                                    final results = [
                                      productList
                                          .where((m) => m.productSlNo.contains(
                                              '${suggestion.productSlNo}')) // or Testing 123
                                          .toList(),
                                    ];
                                    results.forEach((element) async {
                                      element.add(element.first);
                                      print("dfhsghdfkhgkh");
                                      productId = "${element[0].productSlNo}";
                                      print(
                                          "productSlNo===> ${element[0].productSlNo}");
                                      print(
                                          "productCategoryName===> ${element[0].productCategoryName}");
                                      productname = "${element[0].productName}";
                                      print(
                                          "productName===> ${element[0].productName}");
                                      _Selling_PriceController.text =
                                          "${element[0].productSellingPrice}";
                                      print(
                                          "productSellingPrice===> ${element[0].productSellingPrice}");
                                      print("vat===> ${element[0].vat}");
                                      print(
                                          "_quantityController ===> ${_quantityController.text}");
                                      print(
                                          "productPurchaseRate===> ${element[0].productPurchaseRate}");
                                      _salesRateController.text =
                                          "${element[0].productPurchaseRate}";
                                      Amount = double.parse(
                                          _salesRateController.text);
                                      print(Amount);
                                    });
                                  });
                                },
                                onSaved: (value) {},
                              ),
                            ),
                          ),
                        ],
                      ), // product
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text(
                              "Pur. Rate   :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 30.0,
                              margin: const EdgeInsets.only(left: 5, right: 5),
                              child: TextField(
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                                controller: _salesRateController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      bottom: 15, left: 5),
                                  filled: true,
                                  hintText: "0",
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Qty",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 30.0,
                              // margin: const EdgeInsets.only(right: 5),
                              child: TextField(
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    if (_quantityController.text == "0") {
                                      _quantityController.text = "1";
                                      Amount = double.parse(
                                              _salesRateController.text) *
                                          double.parse(
                                              _quantityController.text);
                                    } else {
                                      Amount = double.parse(
                                              _salesRateController.text) *
                                          double.parse(
                                              _quantityController.text);
                                    }
                                  });
                                },
                                controller: _quantityController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      bottom: 15, left: 5),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ), // quantity
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Amount     :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125),
                                  fontSize: 14),
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Container(
                                margin: const EdgeInsets.only(
                                  bottom: 5,
                                ),
                                height: 30,
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 7, 125, 180),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  "$Amount",
                                  style: const TextStyle(fontSize: 13),
                                ),
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Selling Price :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: SizedBox(
                              height: 30.0,
                              //margin: const EdgeInsets.only(bottom: 5),
                              child: TextField(
                                style: const TextStyle(fontSize: 13),
                                controller: _Selling_PriceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      bottom: 15, left: 5),
                                  filled: true,
                                  hintText: "0",
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[500],
                              //const Color.fromARGB(255, 6, 118, 170),
                            ),
                            onPressed: () {
                              if (categoryController.text != '' ||
                                  categoryController.text.isNotEmpty) {
                                if (productController.text != '' ||
                                    productController.text.isNotEmpty) {
                                  // if (_quantityController.text
                                  //         .toString()
                                  //         .isNotEmpty ||
                                  //     _quantityController.text != '') {
                                  setState(() {
                                    PurchaseCartList.add(PurchaseApiModelClass(
                                      productId: "$productId",
                                      quantity: _quantityController.text,
                                      categoryId: "$categoryId",
                                      categoryName: "$productCategoryName",
                                      name: "$productname",
                                      purchaseRate:
                                          _Selling_PriceController.text,
                                      salesRate: _salesRateController.text,
                                      total: "$Amount",
                                    ));
                                    CartTotal += Amount;
                                    _VatController.text = "0";
                                    afterVatTotal = CartTotal;
                                    discountTotal = afterVatTotal;

                                    Paid = discountTotal;
                                    // AfteraddVatTotal=CartTotal;
                                    // DiccountTotal=AfteraddVatTotal;
                                    // TransportTotal=DiccountTotal;
                                    // print("CartTotal ----------------- ${CartTotal}");
                                    categoryController.text = '';
                                    productController.text = '';
                                    _salesRateController.text = '';
                                    _Selling_PriceController.text = "";
                                    branchController.text = "";
                                    setState(() {
                                      Amount = 0;
                                    });
                                  });
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content: Center(
                                    child: Text(
                                      "Please Select Product",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    ),
                                  )));
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Center(
                                  child: Text(
                                    "Please Select Category",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.red),
                                  ),
                                )));
                              }
                            },
                            child: const Text(
                              "Add to cart",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const Divider(thickness: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                "SL.",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: h2TextSize),
                              ),
                            )),
                        Expanded(
                            flex: 3,
                            child: Center(
                              child: Text(
                                "Category",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: h2TextSize,
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 5,
                            child: Center(
                              child: Text(
                                "Product Name",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: h2TextSize,
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                "Qty",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: h2TextSize,
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                "P.Rate",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: h2TextSize,
                                ),
                              ),
                            )),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Text(
                              "Amount",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: h2TextSize,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 2),
                    ...List.generate(PurchaseCartList.length, (index) {
                      return Column(
                        children: [
                          Container(
                            color: Colors.blue[50],
                            height: 25,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 10,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            "${index + 1}.",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                              fontSize: h2TextSize,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            "${PurchaseCartList[index].categoryName}",
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                              fontSize: h2TextSize,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Center(
                                          child: Text(
                                            "${PurchaseCartList[index].name}",
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                              fontSize: h2TextSize,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            "${PurchaseCartList[index].quantity}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                              fontSize: h2TextSize,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            "${PurchaseCartList[index].salesRate}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                              fontSize: h2TextSize,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            "${PurchaseCartList[index].total}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                              fontSize: h2TextSize,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                    SizedBox(height: PurchaseCartList.isNotEmpty ? 10 : 30),
                  ],
                ),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: Card(
                    margin: EdgeInsets.only(bottom: 10),
                    color: Colors.green[400],
                    //color: Color.fromARGB(255, 7, 125, 180),
                    child: const Center(
                      child: Text(
                        'Amount Details',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10, top: 5),
                  padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    //color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                        color: const Color.fromARGB(255, 7, 125, 180),
                        width: 1.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(
                            0, 3), // changes the position of the shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Sub Total   :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                height: 30,
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 7, 125, 180),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  "$CartTotal",
                                ),
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Vat             :   ",
                            style: TextStyle(color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 30.0,
                              margin: const EdgeInsets.only(bottom: 5),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    TotalVat = CartTotal * (double.parse(_VatController.text) / 100);
                                    afterVatTotal = CartTotal + TotalVat;
                                    discountTotal = afterVatTotal;
                                    Transport = discountTotal;
                                    Paid = Transport;
                                    TotalAmount = Paid;
                                  });
                                },
                                controller: _VatController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  hintText: "0",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            "%",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                height: 30,
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 7, 125, 180),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  "$TotalVat",
                                ),
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Discount   :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 30.0,
                              margin: const EdgeInsets.only(
                                bottom: 5,
                              ),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    discountTotal = afterVatTotal -
                                        double.parse(_discountController.text);
                                    Transport = discountTotal;
                                    Paid = Transport;
                                    TotalAmount = Paid;
                                  });
                                },
                                controller: _discountController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  hintText: "0",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Transport  :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 30.0,
                              margin: const EdgeInsets.only(bottom: 5),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    Transport = discountTotal +
                                        double.parse(_transportController.text);
                                    Paid = Transport;
                                    TotalAmount = Paid;
                                  });
                                },
                                controller: _transportController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  hintText: "0",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Own Transport :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 30.0,
                              margin: const EdgeInsets.only(bottom: 5),
                              child: TextField(
                                controller: _ownTransportController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  hintText: "0",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Total          :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                height: 30,
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 7, 125, 180),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  "$Paid",
                                ),
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Paid           :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 30.0,
                              margin: const EdgeInsets.only(bottom: 5),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    TotalAmount = Paid -
                                        double.parse(_paidController.text);
                                    print("Paid amout $TotalAmount");
                                  });
                                },
                                controller: _paidController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  hintText: "0",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 7, 125, 180),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Expanded(
                            flex: 3,
                            child: Text(
                              "Due            :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                          ),
                          Expanded(
                              flex: 4,
                              child: Container(
                                // margin: const EdgeInsets.only(bottom: 5),
                                height: 30,
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 7, 125, 180),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  "${TotalAmount == 0.0 ? CartTotal : TotalAmount}",
                                ),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "P.Due",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 126, 125, 125)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              flex: 3,
                              child: Container(
                                //margin: const EdgeInsets.only(bottom: 5),
                                height: 30,
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 7, 125, 180),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  "$Previousdue",
                                  style: const TextStyle(color: Colors.red),
                                ),
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue.shade700,
                            ),
                            onPressed: () {
                              // final connectivityResult =
                              //     await (Connectivity().checkConnectivity());

                              setState(() {
                                isPurchaseBtnClk = true;
                              });
                              if (CartTotal == 0) {
                                setState(() {
                                  isPurchaseBtnClk = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Please Add to Cart")));
                              } else {
                                // if (connectivityResult ==
                                //         ConnectivityResult.mobile ||
                                //     connectivityResult ==
                                //         ConnectivityResult.wifi) {
                                  addPurchase();
                                // } else {
                                //   Utils.errorSnackBar(
                                //       context, "Please connect with internet");
                                // }
                              }
                            },
                            child: Center(
                                child: isPurchaseBtnClk
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ))
                                    : const Text(
                                        "Purchase",
                                        style: TextStyle(
                                            letterSpacing: 1.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      )),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                              ),
                              onPressed: () {},
                              child: const Text(
                                "New Purchase",
                                style: TextStyle(
                                  letterSpacing: 1.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)
                               )
                            ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? firstPickedDate;
  var backEndFirstDate;
  void _selectedDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2050));
    if (selectedDate != null) {
      setState(() {
        firstPickedDate = Utils.formatFrontEndDate(selectedDate);
        backEndFirstDate = Utils.formatBackEndDate(selectedDate);
        print("Firstdateee $firstPickedDate");
      });
    }
  }
  //
  // String? firstPickedDate;
  // String? backEndFirstDate;
  // var toDay = DateTime.now();
  //
  // void _firstSelectedDate() async {
  //   final selectedDate = await showDatePicker(
  //       context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime(2050));
  //   if (selectedDate != null) {
  //     setState(() {
  //       firstPickedDate = Utils.formatFrontEndDate(selectedDate);
  //       backEndFirstDate = Utils.formatBackEndDate(selectedDate);
  //       print("Firstdateee $firstPickedDate");
  //     });
  //   }else{
  //     setState(() {
  //       firstPickedDate = Utils.formatFrontEndDate(toDay);
  //       backEndFirstDate = Utils.formatBackEndDate(toDay);
  //       print("Firstdateee $firstPickedDate");
  //     });
  //   }
  // }

  double Total = 0;
  double afterVatTotal = 0;
  double Amount = 0;
  double Transport = 0;
  double CartTotal = 0;
  double discountTotal = 0;
  double pTotal = 0;
  String? productId;
  String? productCategoryName;
  String? productname;
  String? purchaseRate;
  String? supplierId;

  double Previousdue = 0;
  double Paid = 0;
  List<PurchaseApiModelClass> PurchaseCartList = [];

  addPurchase() async {
    String link = "${baseUrl}api/v1/addPurchase";
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      var studentsmap = PurchaseCartList.map((e) {
        return {
          "productId": e.productId,
          "name": e.name,
          "categoryId": e.categoryId,
          "categoryName": e.categoryName,
          "purchaseRate": e.purchaseRate,
          "salesRate": e.salesRate,
          "quantity": e.quantity,
          "total": e.total,
          "branchId": "1",
          "branchName": "KB AGRO FOOD",
          "unit": "?????"
        };
      }).toList();
      Response response = await Dio().post(
        link,
        data: {
          "purchase": {
            "purchaseId": 0,
            "invoice": "2023000070",
            "purchaseFor": "1",
            "purchaseDate": "$backEndFirstDate",
            "supplierId": "$supplierId",
            "subTotal": CartTotal,
            "vat": "${TotalVat}",
            "discount": _discountController.text.toString().isNotEmpty
                ? "${double.parse(_discountController.text)}"
                : 0.0,
            "freight": _transportController.text.toString().isNotEmpty
                ? "${double.parse(_transportController.text)}"
                : 0.0,
            "ownFreight": _ownTransportController.text.toString().isNotEmpty
                ? "${double.parse(_ownTransportController.text)}"
                : 0.0,
            "total": "${Paid == 0.0 ? CartTotal : Paid}",
            "paid": _paidController.text.toString().isNotEmpty
                ? "${double.parse(_paidController.text)}"
                : 0.0,
            "due": "${TotalAmount == 0.0 ? CartTotal : TotalAmount}",
            "previousDue": "$Previousdue",
            "note": ""
          },
          "cartProducts": studentsmap,
          "supplier": {
            "Supplier_Address": _addressController.text.trim(),
            "Supplier_Code": "",
            "Supplier_Mobile": _mobileNumberController.text.trim(),
            "Supplier_Name": _nameController.text.trim(),
            "Supplier_SlNo": "",
            "Supplier_Type": "G",
            "display_name": "General Supplier"
          }
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }),
      );
      print(response.data);
      var item = jsonDecode(response.data);
      if (item["success"] == true) {
        PurchaseCartList.clear();
        Paid = 0;
        Previousdue = 0;
        setState(() {
          isPurchaseBtnClk = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.black,
            content: Text(
              "${item["message"]}",
              style: const TextStyle(color: Colors.white),
            )));
        Navigator.pop(context);
      } else {
        setState(() {
          isPurchaseBtnClk = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.black,
            content: Text(
              "${item["message"]}",
              style: const TextStyle(color: Colors.red),
            )));
      }
    } catch (e) {
      print(e);

      setState(() {
        isPurchaseBtnClk = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.black,
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.red),
          )));
    }
  }

  bool isPurchaseBtnClk = false;
}
