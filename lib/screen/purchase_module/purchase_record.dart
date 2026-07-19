//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/all_product_provider.dart';
import 'package:kbtradlink/provider/category_provider.dart';
import 'package:kbtradlink/provider/purchase_details_provider.dart';
import 'package:kbtradlink/provider/purchase_record_provider.dart';
import 'package:kbtradlink/provider/purchases_provider.dart';
import 'package:kbtradlink/provider/supplier_provider.dart';
import 'package:kbtradlink/screen/administation_module/model/product_model.dart';
import 'package:kbtradlink/screen/administation_module/model/supplier_model.dart';
import 'package:kbtradlink/screen/purchase_module/purchase_invoice_page.dart';
import 'package:kbtradlink/screen/sales_module/model/category_model.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:provider/provider.dart';

class PurchaseRecord extends StatefulWidget {
  const PurchaseRecord({super.key});

  @override
  State<PurchaseRecord> createState() => _PurchaseRecordState();
}

class _PurchaseRecordState extends State<PurchaseRecord> {
  //main dropdowns logic
  bool isAllTypeClicked = true;
  bool isCategoryWiseClicked = false;
  bool isQuantityWiseClicked = false;
  bool isUserWiseClicked = false;

  //sub dropdowns logic
  bool isWithoutDetailsClicked = true;
  bool isWithDetailsClicked = false;

  // dropdown value
  String? userFullName;
  String? _selectedSearchTypes = "All";
  String? _selectedRecordTypes = "Without Details";
  String? _selectedCategoryTypes;
  String? _selectedQuantityProductTypes;
  String? _selectedQuantitySupplierTypes;
  String? _selectedUserTypes;
  var items = [
    'Admin',
  ];
//my work value
  String? isService;
  String? categoryId;
  //
  String data = 'showAllWithoutDetails';

  //all the dropdown lists
  final List<String> _searchTypes = [
    'All',
    'By Category',
    'By Quantity',
    'By User',
  ];
  final List<String> _recordType = [
    'Without Details',
    'With Details',
  ];

  String? firstPickedDate;
  var backEndFirstDate;
  var backEndSecondDate;
  var toDay = DateTime.now();

  void _firstSelectedDate() async {
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
    } else {
      setState(() {
        firstPickedDate = Utils.formatFrontEndDate(toDay);
        backEndFirstDate = Utils.formatBackEndDate(toDay);
        print("Firstdateee $firstPickedDate");
      });
    }
  }

  var categoryController = TextEditingController();
  var supplyerController = TextEditingController();
  var productAllController = TextEditingController();

  String? secondPickedDate;
  void _secondSelectedDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2050));
    if (selectedDate != null) {
      setState(() {
        secondPickedDate = Utils.formatFrontEndDate(selectedDate);
        backEndSecondDate = Utils.formatBackEndDate(selectedDate);
        print("Firstdateee $secondPickedDate");
      });
    } else {
      setState(() {
        secondPickedDate = Utils.formatFrontEndDate(toDay);
        backEndSecondDate = Utils.formatBackEndDate(toDay);
        print("Firstdateee $secondPickedDate");
      });
    }
  }

  ///Sub total
  double? subTotal;
  double? discountTotal;
  double? transferCost;
  double? ownTransportCost;
  double? totalAmount;
  double? paidTotal;
  double? dueTotal;
  double? totalQuantity;

  bool isLoading = false;
  @override
  void initState() {
    Provider.of<AllProductProvider>(context, listen: false).getAllProduct();
    Provider.of<CategoryProvider>(context, listen: false).getCategoryData();
    Provider.of<SupplierProvider>(context, listen: false).getSupplierList();
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    backEndSecondDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    getGetPurchasessData("$backEndFirstDate", "$backEndSecondDate", "");

    // TODO: implement initState
    super.initState();
  }

  getGetPurchasessData(backEndFirstDate, backEndSecondDate, userFullName) {
    Provider.of<GetPurchasesProvider>(context, listen: false).getGetPurchases(
        context, "$backEndFirstDate", "$backEndSecondDate", "");
  }

  @override
  Widget build(BuildContext context) {
    //get Purchases
    final allGetPurchasesData =
        Provider.of<GetPurchasesProvider>(context).getPurchaseslist;

    ///Sub total
    subTotal = allGetPurchasesData
        .map((e) => e.purchaseMasterSubTotalAmount)
        .fold(0.0, (p, element) => p! + double.parse(element));
    discountTotal = allGetPurchasesData
        .map((e) => e.purchaseMasterDiscountAmount)
        .fold(0.0, (p, element) => p! + double.parse(element));
    transferCost = allGetPurchasesData
        .map((e) => e.purchaseMasterFreight)
        .fold(0.0, (p, element) => p! + double.parse(element));
    ownTransportCost = allGetPurchasesData
        .map((e) => e.ownFreight)
        .fold(0.0, (p, element) => p! + double.parse(element));
    totalAmount = allGetPurchasesData
        .map((e) => e.purchaseMasterTotalAmount)
        .fold(0.0, (p, element) => p! + double.parse(element));
    paidTotal = allGetPurchasesData
        .map((e) => e.purchaseMasterPaidAmount)
        .fold(0.0, (p, element) => p! + double.parse(element));
    dueTotal = allGetPurchasesData
        .map((e) => e.purchaseMasterDueAmount)
        .fold(0.0, (p, element) => p! + double.parse(element));

    final allCategoriesData =
        Provider.of<CategoryProvider>(context, listen: false).categoryList;
    final allSuppliersData =
        Provider.of<SupplierProvider>(context, listen: false)
            .supplierList
            .where((element) => element.supplierName != null)
            .toList();
    final allProductsData =
        Provider.of<AllProductProvider>(context, listen: false).productList;
    //get PurchaseRecord
    final allPurchaseRecordData =
        Provider.of<PurchaseRecordProvider>(context).getPurchaseRecordlist;
    //get PurchaseDetails
    final allPurchaseDetailsData =
        Provider.of<PurchaseDetailsProvider>(context).getPurchaseDetailslist;
    totalQuantity = allPurchaseDetailsData
        .map((e) => e.purchaseDetailsTotalQuantity)
        .fold(0.0, (p, element) => p! + double.parse(element));

    return Scaffold(
      appBar: CustomAppBar(title: "Purchase Record"),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 5.0, bottom: 5),
            child: Container(
              //height: 190,
              height: isAllTypeClicked == true
                  ? 155.0
                  : isCategoryWiseClicked == true
                      ? 155.0
                      : isQuantityWiseClicked == true
                          ? 190.0
                          : 190.0,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 5, top: 5),
              padding: const EdgeInsets.only(left: 6.0, right: 6.0),
              decoration: BoxDecoration(
                color: Colors.green[100],
                //color: Colors.blue[100],
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: const Color.fromARGB(255, 7, 125, 180), width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes the position of the shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "Search Type :",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
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
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  hint: const Text(
                                    'All',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ), // Not necessary for Option 1
                                  value: _selectedSearchTypes,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedSearchTypes = newValue!;
                                      // _selectedSearchTypes == "All"
                                      //     ? data = "showAllWithoutDetails"
                                      //     : "";
                                      _selectedSearchTypes == "All"
                                          ? isAllTypeClicked = true
                                          : isAllTypeClicked = false;

                                      _selectedSearchTypes == "By Category"
                                          ? isCategoryWiseClicked = true
                                          : isCategoryWiseClicked = false;

                                      _selectedSearchTypes == "By Quantity"
                                          ? isQuantityWiseClicked = true
                                          : isQuantityWiseClicked = false;

                                      _selectedSearchTypes == "By User"
                                          ? isUserWiseClicked = true
                                          : isUserWiseClicked = false;
                                    });
                                  },
                                  items: _searchTypes.map((location) {
                                    return DropdownMenuItem(
                                      value: location,
                                      child: Text(
                                        location,
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  isAllTypeClicked == true
                      ? Row(
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Text(
                                "Record Type:",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  height: 30,
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 7, 125, 180),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      hint: const Text(
                                        'Please select a record type',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ), // Not necessary for Option 1
                                      value: _selectedRecordTypes,
                                      onChanged: (newValue) {
                                        print(
                                            'Seletcted value $_selectedRecordTypes');
                                        setState(() {
                                          _selectedRecordTypes = newValue!;
                                          _selectedRecordTypes ==
                                                  "Without Details"
                                              ? isWithoutDetailsClicked = true
                                              : isWithoutDetailsClicked = false;
                                          _selectedRecordTypes == "With Details"
                                              ? isWithDetailsClicked = true
                                              : isWithDetailsClicked = false;
                                        });
                                      },
                                      items: _recordType.map((location) {
                                        return DropdownMenuItem(
                                          value: location,
                                          child: Text(
                                            location,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  )),
                            ),
                          ],
                        )
                      : Container(),
                  isCategoryWiseClicked == true
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Category      :",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 0, bottom: 3),
                                    height: 30,
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 7, 125, 180),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: TypeAheadFormField(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                              onChanged: (value) {
                                                if (value == '') {
                                                  categoryId = '';
                                                }
                                              },
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                              controller: categoryController,
                                              decoration: InputDecoration(
                                                contentPadding:const EdgeInsets.only(bottom: 11),
                                                hintText: 'Select Category',
                                                suffix: categoryId == ''
                                                    ? null
                                                    : GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            categoryController
                                                                .text = '';
                                                          });
                                                        },
                                                        child: const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      3),
                                                          child: Icon(
                                                            Icons.close,
                                                            size: 14,
                                                          ),
                                                        ),
                                                      ),
                                              )),
                                      suggestionsCallback: (pattern) {
                                        return allCategoriesData
                                            .where((element) => element
                                                .productCategoryName
                                                .toLowerCase()
                                                .contains(pattern
                                                    .toString()
                                                    .toLowerCase()))
                                            .take(allCategoriesData.length)
                                            .toList();
                                        // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            child: Text(
                                              suggestion.productCategoryName,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        );
                                        //   ListTile(
                                        //   title: SizedBox(child: Text("${suggestion.productCategoryName}",style: const TextStyle(fontSize: 12), maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                        // );
                                      },
                                      transitionBuilder: (context,
                                          suggestionsBox, controller) {
                                        return suggestionsBox;
                                      },
                                      onSuggestionSelected:
                                          (CategoryModel suggestion) {
                                        categoryController.text =
                                            suggestion.productCategoryName;
                                        setState(() {
                                          _selectedCategoryTypes = suggestion
                                              .productCategorySlNo
                                              .toString();
                                          print(
                                              'Category id is $_selectedCategoryTypes');
                                        });
                                      },
                                      onSaved: (value) {},
                                    ),
                                  ),
                                )
                              ],
                            ), // Employee
                          ],
                        )
                      : Container(),
                  isQuantityWiseClicked == true
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Supplier        :",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    height: 30,
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 7, 125, 180),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: TypeAheadFormField(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                              onChanged: (value) {
                                                if (value == '') {
                                                  _selectedQuantitySupplierTypes =
                                                      '';
                                                }
                                              },
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                              controller: supplyerController,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        bottom: 12),
                                                hintText: 'Select Supplier',
                                                suffix:
                                                    _selectedQuantitySupplierTypes ==
                                                            ''
                                                        ? null
                                                        : GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                supplyerController
                                                                    .text = '';
                                                              });
                                                            },
                                                            child:
                                                                const Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          3),
                                                              child: Icon(
                                                                Icons.close,
                                                                size: 14,
                                                              ),
                                                            ),
                                                          ),
                                              )),
                                      suggestionsCallback: (pattern) {
                                        return allSuppliersData
                                            .where((element) => element
                                                .supplierName
                                                .toString()
                                                .toLowerCase()
                                                .contains(pattern
                                                    .toString()
                                                    .toLowerCase()))
                                            .take(allSuppliersData.length)
                                            .toList();
                                        // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            child: Text(
                                              "${suggestion.supplierCode} - ${suggestion.supplierName}",
                                              style:
                                                  const TextStyle(fontSize: 12),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        );
                                      },
                                      transitionBuilder: (context,
                                          suggestionsBox, controller) {
                                        return suggestionsBox;
                                      },
                                      onSuggestionSelected:
                                          (SupplierModel suggestion) {
                                        supplyerController.text =
                                            suggestion.supplierName!;
                                        setState(() {
                                          _selectedQuantitySupplierTypes =
                                              "${suggestion.supplierSlNo}";
                                          print(
                                              "Customer Wise Category ID ========== > ${suggestion.supplierSlNo} ");
                                        });
                                      },
                                      onSaved: (value) {},
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Product        :",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    height: 30,
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 7, 125, 180),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: TypeAheadFormField(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                              onChanged: (value) {
                                                if (value == '') {
                                                  _selectedQuantityProductTypes =
                                                      '';
                                                }
                                              },
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                              controller: productAllController,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        bottom: 12),
                                                hintText: 'Select Product',
                                                suffix:
                                                    _selectedQuantityProductTypes ==
                                                            ''
                                                        ? null
                                                        : GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                productAllController
                                                                    .text = '';
                                                              });
                                                            },
                                                            child:
                                                                const Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          3),
                                                              child: Icon(
                                                                Icons.close,
                                                                size: 14,
                                                              ),
                                                            ),
                                                          ),
                                              )),
                                      suggestionsCallback: (pattern) {
                                        return allProductsData
                                            .where((element) => element
                                                .productName
                                                .toString()
                                                .toLowerCase()
                                                .contains(pattern
                                                    .toString()
                                                    .toLowerCase()))
                                            .take(allProductsData.length)
                                            .toList();
                                        // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            child: Text(
                                              "${suggestion.productName} - ${suggestion.productCode}",
                                              style:
                                                  const TextStyle(fontSize: 12),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        );
                                      },
                                      transitionBuilder: (context,
                                          suggestionsBox, controller) {
                                        return suggestionsBox;
                                      },
                                      onSuggestionSelected:
                                          (ProductModel suggestion) {
                                        productAllController.text =
                                            suggestion.productName;
                                        setState(() {
                                          _selectedQuantityProductTypes =
                                              "${suggestion.productCode}";
                                          print(
                                              "productCode ID ========== > ${suggestion.productCode} ");
                                        });
                                      },
                                      onSaved: (value) {},
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      : Container(),
                  isUserWiseClicked == true
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "User              :",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    height: 30,
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 7, 125, 180),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        //itemHeight: 45.0,
                                        // menuMaxHeight: 50.0,
                                        isExpanded: true,
                                        hint: const Text(
                                          'Select a User',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ), // Not necessary for Option 1
                                        value: _selectedUserTypes,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedUserTypes =
                                                newValue.toString();
                                          });
                                        },
                                        items: items.map((location) {
                                          return DropdownMenuItem(
                                            value: location,
                                            child: Text(
                                              "${location}",
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Record Type:",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      height: 30,
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
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
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          hint: const Text(
                                            'Please select a record type',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ), // Not necessary for Option 1
                                          value: _selectedRecordTypes,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _selectedRecordTypes = newValue!;
                                              _selectedRecordTypes ==
                                                      "Without Details"
                                                  ? isWithoutDetailsClicked =
                                                      true
                                                  : isWithoutDetailsClicked =
                                                      false;
                                              _selectedRecordTypes ==
                                                      "With Details"
                                                  ? isWithDetailsClicked = true
                                                  : isWithDetailsClicked =
                                                      false;
                                            });
                                          },
                                          items: _recordType.map((location) {
                                            return DropdownMenuItem(
                                              value: location,
                                              child: Text(
                                                location,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  Container(
                    height: 36,
                    width: double.infinity,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5, bottom: 5),
                            height: 30,
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 5, left: 5, right: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color.fromARGB(255, 7, 125, 180),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: GestureDetector(
                              onTap: (() {
                                _firstSelectedDate();
                              }),
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(top: 10),
                                  filled: true,
                                  // fillColor: Colors.blue[50],
                                  suffixIcon: const Padding(
                                    padding: EdgeInsets.only(left: 25),
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: Color.fromARGB(221, 22, 51, 95),
                                      size: 16,
                                    ),
                                  ),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  hintText: firstPickedDate,
                                  hintStyle: const TextStyle(
                                      fontSize: 13, color: Colors.black87),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return null;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text("To"),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5, bottom: 5),
                            height: 30,
                            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color.fromARGB(255, 7, 125, 180),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: GestureDetector(
                              onTap: (() {
                                _secondSelectedDate();
                              }),
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(top: 10),
                                  filled: true,
                                  suffixIcon: const Padding(
                                    padding: EdgeInsets.only(left: 25),
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: Color.fromARGB(221, 22, 51, 95),
                                      size: 16,
                                    ),
                                  ),
                                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                                  hintText: secondPickedDate,
                                  hintStyle: const TextStyle(fontSize: 13, color: Colors.black87),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return null;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.all(1.0),
                      child: InkWell(
                        onTap: () {
                          // final connectivityResult =
                          //     await (Connectivity().checkConnectivity());

                          // if (connectivityResult == ConnectivityResult.mobile ||
                          //     connectivityResult == ConnectivityResult.wifi) {
                            setState(() {
                              isLoading = true;
                            });

                            setState(() {
                              // AllType
                              print(
                                  " dsafasfasfasdfasdf$isAllTypeClicked && $isWithoutDetailsClicked");

                              if (isAllTypeClicked && isWithoutDetailsClicked) {
                                print(
                                    " dsafasfasfasdfasdf$isAllTypeClicked && $isWithoutDetailsClicked");
                                data = 'showAllWithoutDetails';
                                print("date 1st $backEndFirstDate");
                                getGetPurchasessData(
                                    backEndFirstDate, backEndSecondDate, "");
                                // Provider.of<CounterProvider>(context,listen: false)
                                //     .getPurchasess(
                                //     context,
                                //    "$backEndFirstDate",
                                //     "$backEndSecondDate",
                                //     "");
                              } else if (isAllTypeClicked &&
                                  isWithDetailsClicked) {
                                data = 'showAllWithDetails';
                                Provider.of<PurchaseRecordProvider>(context,
                                        listen: false)
                                    .getPurchaseRecord(
                                  context,
                                  "$backEndFirstDate",
                                  "$backEndSecondDate",
                                  "",
                                );
                              }

                              // By Category
                              else if (isCategoryWiseClicked) {
                                data = 'showByCategoryDetails';
                                Provider.of<PurchaseDetailsProvider>(context,
                                        listen: false)
                                    .getPurchaseDetails(
                                        context,
                                        "$_selectedCategoryTypes",
                                        "$backEndFirstDate",
                                        "$backEndSecondDate",
                                        "",
                                        "");
                              }
                              // By Quantity
                              else if (isQuantityWiseClicked) {
                                data = 'showByQuantityDetails';
                                Provider.of<PurchaseDetailsProvider>(context,
                                        listen: false)
                                    .getPurchaseDetails(
                                        context,
                                        "",
                                        "$backEndFirstDate",
                                        "$backEndSecondDate",
                                        "$_selectedQuantityProductTypes",
                                        "$_selectedQuantitySupplierTypes");
                              }

                              // By User
                              else if (isUserWiseClicked &&
                                  isWithoutDetailsClicked) {
                                data = 'showByUserWithoutDetails';
                                Provider.of<GetPurchasesProvider>(context,
                                        listen: false)
                                    .getGetPurchases(context, backEndFirstDate,
                                        backEndSecondDate, _selectedUserTypes);
                              } else if (isUserWiseClicked &&
                                  isWithDetailsClicked) {
                                data = 'showByUserWithDetails';
                                Provider.of<PurchaseRecordProvider>(context,
                                        listen: false)
                                    .getPurchaseRecord(
                                  context,
                                  "$backEndFirstDate",
                                  "$backEndSecondDate",
                                  "$_selectedUserTypes",
                                );
                              }
                            });
                            Future.delayed(const Duration(seconds: 3), () {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          // } else {
                          //   Utils.errorSnackBar(
                          //       context, "Please connect with internet");
                          // }
                        },
                        child: Container(
                          height: 30.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                            color: Colors.green[500],
                            // color: const Color.fromARGB(255, 4, 113, 185),
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(
                                    0, 3), // changes the position of the shadow
                              ),
                            ],
                          ),
                          child: const Center(
                              child: Text(
                            "Show Report",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // const Divider(
          //   color: Color.fromARGB(255, 92, 90, 90),
          // ),

          data == 'showAllWithoutDetails'
              ? Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : allGetPurchasesData.isNotEmpty
                          ? Container(
                              width: double.infinity,
                              height: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        // color: Colors.red,
                                        // padding:EdgeInsets.only(bottom: 16.0),
                                        child: DataTable(
                                          headingRowHeight: 20.0,
                                          dataRowHeight: 20.0,
                                          showCheckboxColumn: true,
                                          border: TableBorder.all(
                                              color: Colors.black54, width: 1),
                                          columns: const [
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child:
                                                          Text('Invoice No'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text('Date'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text(
                                                          'Supplier Name'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child:
                                                          Text('Sub Total'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text('Discount'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text(
                                                          'Transport Cost'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text(
                                                          'Own Transport Cost'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text('Total'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text('Paid'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text('Due'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text('Invoice'))),
                                            ),
                                          ],
                                          rows: List.generate(
                                            allGetPurchasesData.length,
                                            (int index) => DataRow(
                                              cells: <DataCell>[
                                                DataCell(
                                                  Center(
                                                      child: Text(
                                                          '${allGetPurchasesData[index].purchaseMasterInvoiceNo}')),
                                                ),
                                                DataCell(
                                                  Center(
                                                      child: Text(
                                                          '${allGetPurchasesData[index].purchaseMasterOrderDate}')),
                                                ),
                                                DataCell(
                                                  Center(
                                                      child: Text(
                                                          '${allGetPurchasesData[index].supplierName}')),
                                                ),
                                                DataCell(
                                                  Center(
                                                      child: Text(
                                                          '${allGetPurchasesData[index].purchaseMasterSubTotalAmount}')),
                                                ),
                                                DataCell(
                                                  Center(
                                                      child: Text(
                                                          '${allGetPurchasesData[index].purchaseMasterDiscountAmount}')),
                                                ),
                                                DataCell(
                                                  Center(
                                                      child: Text(
                                                          '${allGetPurchasesData[index].purchaseMasterFreight}')),
                                                ),
                                                DataCell(
                                                  Center(
                                                      child: Text(
                                                          '${allGetPurchasesData[index].ownFreight}')),
                                                ),
                                                DataCell(
                                                  Center(
                                                      child: Text(
                                                          '${allGetPurchasesData[index].purchaseMasterTotalAmount}')),
                                                ),
                                                DataCell(
                                                  Center(
                                                      child: Text(
                                                          '${allGetPurchasesData[index].purchaseMasterPaidAmount}')),
                                                ),
                                                DataCell(
                                                  Center(
                                                      child: Text(
                                                          '${allGetPurchasesData[index].purchaseMasterDueAmount}')),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child:GestureDetector(
                                                      child: const Icon(Icons.collections_bookmark,size: 18,),
                                                      onTap: () {
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseInvoicePage(
                                                          purchaseId: allGetPurchasesData[index].purchaseMasterSlNo,
                                                        ),
                                                        )
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Total Sub Total       :    ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("$subTotal"),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Total Discount        :    ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("$discountTotal"),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Total Trans.Cost    :    ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("$transferCost"),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Total Own Tr.Cost  :    ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("$ownTransportCost"),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Total Amount         :    ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("$totalAmount"),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Total paid               :    ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("$paidTotal"),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Total Due                :    ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("$dueTotal"),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const Align(
                              alignment: Alignment.center,
                              child: Center(
                                child: Text(
                                  "No Data Found",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.red),
                                ),
                              )),
                )
              : data == 'showAllWithDetails'
                  ? Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : allPurchaseRecordData.isNotEmpty
                              ? Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                        // color: Colors.red,
                                        // padding:EdgeInsets.only(bottom: 16.0),
                                        child: DataTable(
                                          headingRowHeight: 25.0,
                                          dataRowMaxHeight: double.infinity,
                                          showCheckboxColumn: true,
                                          border: TableBorder.all(
                                              color: Colors.black54, width: 1),
                                          columns: const [
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child:
                                                          Text('Invoice No'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text('Date'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                child: Text('Supplier Name'),
                                              )),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text(
                                                          'Product Name'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text('Price'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text('Quantity'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text('Total'))),
                                            ),
                                            DataColumn(
                                              label: Center(child: Text('Invoice')),
                                            ),
                                          ],
                                          rows: List.generate(
                                            allPurchaseRecordData.length,
                                            (int index) => DataRow(
                                              cells: <DataCell>[
                                                DataCell(
                                                  Center(
                                                      child: Text(
                                                          '${allPurchaseRecordData[index].purchaseMasterInvoiceNo}')),
                                                ),
                                                DataCell(
                                                  Center(
                                                      child: Text(
                                                          '${allPurchaseRecordData[index].purchaseMasterOrderDate}')),
                                                ),
                                                DataCell(
                                                  Center(
                                                      child: Text(
                                                          '${allPurchaseRecordData[index].supplierName}')),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Column(
                                                        children: List.generate(
                                                            allPurchaseRecordData[
                                                                    index]
                                                                .purchaseDetails!
                                                                .length, (j) {
                                                      return Container(
                                                        child: Center(
                                                            child: Text(
                                                                allPurchaseRecordData[
                                                                        index]
                                                                    .purchaseDetails![
                                                                        j]
                                                                    .productName)),
                                                      );
                                                    })),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Column(
                                                        children: List.generate(
                                                            allPurchaseRecordData[
                                                                    index]
                                                                .purchaseDetails!
                                                                .length, (j) {
                                                      return Container(
                                                        child: Center(
                                                            child: Text(double.parse(
                                                                    allPurchaseRecordData[
                                                                            index]
                                                                        .purchaseDetails![
                                                                            j]
                                                                        .purchaseDetailsRate)
                                                                .toStringAsFixed(
                                                                    2))),
                                                      );
                                                    })),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Column(
                                                        children: List.generate(
                                                            allPurchaseRecordData[
                                                                    index]
                                                                .purchaseDetails!
                                                                .length, (j) {
                                                      return Container(
                                                        child: Center(
                                                            child: Text(double.parse(
                                                                    allPurchaseRecordData[
                                                                            index]
                                                                        .purchaseDetails![
                                                                            j]
                                                                        .purchaseDetailsTotalQuantity)
                                                                .toStringAsFixed(
                                                                    2))),
                                                      );
                                                    })),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Column(
                                                        children: List.generate(
                                                            allPurchaseRecordData[
                                                                    index]
                                                                .purchaseDetails
                                                                !.length, (j) {
                                                      return Container(
                                                        child: Center(
                                                            child: Text(double.parse(
                                                                    allPurchaseRecordData[
                                                                            index]
                                                                        .purchaseDetails![
                                                                            j]
                                                                        .purchaseDetailsTotalAmount)
                                                                .toStringAsFixed(
                                                                    2))),
                                                      );
                                                    })),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child:GestureDetector(
                                                      child: const Icon(Icons.collections_bookmark,size: 18,),
                                                      onTap: () {
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseInvoicePage(
                                                          purchaseId: allPurchaseRecordData[index].purchaseMasterSlNo,
                                                        ),
                                                        )
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const Align(
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: Text(
                                      "No Data Found",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    ),
                                  )),
                    )
                  : data == 'showByCategoryDetails'
                      ? Expanded(
                          child: isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : allPurchaseDetailsData.isNotEmpty
                                  ? Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: DataTable(
                                                  headingRowHeight: 20.0,
                                                  dataRowHeight: 20.0,
                                                  showCheckboxColumn: true,
                                                  border: TableBorder.all(
                                                      color: Colors.black54,
                                                      width: 1),
                                                  columns: const [
                                                    DataColumn(
                                                      label: Expanded(
                                                          child: Center(
                                                              child: Text(
                                                                  'Invoice No'))),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                          child: Center(
                                                              child: Text(
                                                                  'Date'))),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                          child: Center(
                                                              child: Text(
                                                                  'Supplier Name'))),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                          child: Center(
                                                              child: Text(
                                                                  'Product Name'))),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                          child: Center(
                                                              child: Text(
                                                                  'Purchases  Rate'))),
                                                    ),
                                                    DataColumn(
                                                      label: Expanded(
                                                          child: Center(
                                                              child: Text(
                                                                  'Quantity'))),
                                                    ),
                                                  ],
                                                  rows: List.generate(
                                                    allPurchaseDetailsData
                                                        .length,
                                                    (int index) => DataRow(
                                                      cells: <DataCell>[
                                                        DataCell(
                                                          Center(
                                                              child: Text(
                                                                  '${allPurchaseDetailsData[index].purchaseMasterInvoiceNo}')),
                                                        ),
                                                        DataCell(
                                                          Center(
                                                              child: Text(
                                                                  '${allPurchaseDetailsData[index].purchaseMasterOrderDate}')),
                                                        ),
                                                        DataCell(
                                                          Center(
                                                              child: Text(
                                                                  '${allPurchaseDetailsData[index].supplierName}')),
                                                        ),
                                                        DataCell(
                                                          Center(
                                                              child: Text(
                                                                  '${allPurchaseDetailsData[index].productName}')),
                                                        ),
                                                        DataCell(
                                                          Center(
                                                              child: Text(
                                                                  '${allPurchaseDetailsData[index].purchaseDetailsRate}')),
                                                        ),
                                                        DataCell(
                                                          Center(
                                                              child: Text(
                                                                  '${allPurchaseDetailsData[index].purchaseDetailsTotalQuantity}')),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Total Quantity      :    ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text("$totalQuantity"),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : const Align(
                                      alignment: Alignment.center,
                                      child: Center(
                                        child: Text(
                                          "No Data Found",
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.red),
                                        ),
                                      )),
                        )
                      : data == 'showByQuantityDetails'
                          ? Expanded(
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : allPurchaseDetailsData.isNotEmpty
                                      ? Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: DataTable(
                                                      headingRowHeight: 20.0,
                                                      dataRowHeight: 20.0,
                                                      showCheckboxColumn: true,
                                                      border: TableBorder.all(
                                                          color: Colors.black54,
                                                          width: 1),
                                                      columns: const [
                                                        DataColumn(
                                                          label: Expanded(
                                                              child: Center(
                                                                  child: Text(
                                                                      'Invoice No'))),
                                                        ),
                                                        DataColumn(
                                                          label: Expanded(
                                                              child: Center(
                                                                  child: Text(
                                                                      'Date'))),
                                                        ),
                                                        DataColumn(
                                                          label: Expanded(
                                                              child: Center(
                                                                  child: Text(
                                                                      'Supplier Name'))),
                                                        ),
                                                        DataColumn(
                                                          label: Expanded(
                                                              child: Center(
                                                                  child: Text(
                                                                      'Product Name'))),
                                                        ),
                                                        DataColumn(
                                                          label: Expanded(
                                                              child: Center(
                                                                  child: Text(
                                                                      'Purchases Rate'))),
                                                        ),
                                                        DataColumn(
                                                          label: Expanded(
                                                              child: Center(
                                                                  child: Text(
                                                                      'Quantity'))),
                                                        ),
                                                      ],
                                                      rows: List.generate(
                                                        allPurchaseDetailsData
                                                            .length,
                                                        (int index) => DataRow(
                                                          cells: <DataCell>[
                                                            DataCell(
                                                              Center(
                                                                  child: Text(
                                                                      '${allPurchaseDetailsData[index].purchaseMasterInvoiceNo}')),
                                                            ),
                                                            DataCell(
                                                              Center(
                                                                  child: Text(
                                                                      '${allPurchaseDetailsData[index].purchaseMasterOrderDate}')),
                                                            ),
                                                            DataCell(
                                                              Center(
                                                                  child: Text(
                                                                      '${allPurchaseDetailsData[index].supplierName}')),
                                                            ),
                                                            DataCell(
                                                              Center(
                                                                  child: Text(
                                                                      '${allPurchaseDetailsData[index].productName}')),
                                                            ),
                                                            DataCell(
                                                              Center(
                                                                  child: Text(
                                                                      '${allPurchaseDetailsData[index].purchaseDetailsRate}')),
                                                            ),
                                                            DataCell(
                                                              Center(
                                                                  child: Text(
                                                                      '${allPurchaseDetailsData[index].purchaseDetailsTotalQuantity}')),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0,
                                                            top: 10.0),
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                          "Total Quantity :  ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14),
                                                        ),
                                                        allPurchaseDetailsData
                                                                    .length ==
                                                                0
                                                            ? const Text(
                                                                "0",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14),
                                                              )
                                                            : Text(
                                                                "${GetStorage().read("totalQuantity")}",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            14),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : const Align(
                                          alignment: Alignment.center,
                                          child: Center(
                                            child: Text(
                                              "No Data Found",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.red),
                                            ),
                                          )),
                            )
                          : data == 'showByUserWithoutDetails'
                              ? Expanded(
                                  child: isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : allGetPurchasesData.isNotEmpty
                                          ? Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0),
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        DataTable(
                                                          headingRowHeight:
                                                              20.0,
                                                          dataRowHeight: 20.0,
                                                          showCheckboxColumn:
                                                              true,
                                                          border:
                                                              TableBorder.all(
                                                                  color: Colors
                                                                      .black54,
                                                                  width: 1),
                                                          columns: const [
                                                            DataColumn(
                                                              label: Expanded(
                                                                  child: Center(
                                                                child: Text(
                                                                    'Invoice No'),
                                                              )),
                                                            ),
                                                            DataColumn(
                                                              label: Expanded(
                                                                  child: Center(
                                                                      child: Text(
                                                                          'Date'))),
                                                            ),
                                                            DataColumn(
                                                              label: Expanded(
                                                                  child: Center(
                                                                child: Text(
                                                                    'Supplier Name'),
                                                              )),
                                                            ),
                                                            DataColumn(
                                                              label: Expanded(
                                                                  child: Center(
                                                                child: Text(
                                                                    'Sub Total'),
                                                              )),
                                                            ),
                                                            DataColumn(
                                                              label: Expanded(
                                                                  child: Center(
                                                                child: Text(
                                                                    'Discount'),
                                                              )),
                                                            ),
                                                            DataColumn(
                                                              label: Expanded(
                                                                  child: Center(
                                                                      child: Text(
                                                                          'Transport Cost'))),
                                                            ),
                                                            DataColumn(
                                                              label: Expanded(
                                                                  child: Center(
                                                                      child: Text(
                                                                          'Own Transport Cost'))),
                                                            ),
                                                            DataColumn(
                                                              label: Expanded(
                                                                  child: Center(
                                                                      child: Text(
                                                                          'Total'))),
                                                            ),
                                                            DataColumn(
                                                              label: Expanded(
                                                                  child: Center(
                                                                      child: Text(
                                                                          'Paid'))),
                                                            ),
                                                            DataColumn(
                                                              label: Expanded(
                                                                  child: Center(
                                                                      child: Text(
                                                                          'Due'))),
                                                            ),
                                                            DataColumn(
                                                              label: Expanded(
                                                                  child: Center(
                                                                      child: Text(
                                                                          'Invoice'))),
                                                            ),
                                                          ],
                                                          rows: List.generate(
                                                            allGetPurchasesData
                                                                .length,
                                                            (int index) =>
                                                                DataRow(
                                                              cells: <DataCell>[
                                                                DataCell(
                                                                  Center(
                                                                      child: Text(
                                                                          '${allGetPurchasesData[index].purchaseMasterInvoiceNo}')),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                      child: Text(
                                                                          '${allGetPurchasesData[index].purchaseMasterOrderDate}')),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                      child: Text(
                                                                          '${allGetPurchasesData[index].supplierName}')),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                      child: Text(
                                                                          '${allGetPurchasesData[index].purchaseMasterSubTotalAmount}')),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                      child: Text(
                                                                          '${allGetPurchasesData[index].purchaseMasterDiscountAmount}')),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                      child: Text(
                                                                          '${allGetPurchasesData[index].purchaseMasterFreight}')),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                      child: Text(
                                                                          '${allGetPurchasesData[index].ownFreight}')),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                      child: Text(
                                                                          '${allGetPurchasesData[index].purchaseMasterTotalAmount}')),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                      child: Text(
                                                                          '${allGetPurchasesData[index].purchaseMasterPaidAmount}')),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                      child: Text(
                                                                          '${allGetPurchasesData[index].purchaseMasterDueAmount}')),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                    child:GestureDetector(
                                                                      child: const Icon(Icons.collections_bookmark,size: 18,),
                                                                      onTap: () {
                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseInvoicePage(
                                                                          purchaseId: allGetPurchasesData[index].purchaseMasterSlNo,
                                                                        ),
                                                                        )
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              "Total Sub Total       :    ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text("$subTotal"),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              "Total Discount        :    ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                                "$discountTotal"),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              "Total Trans.Cost    :    ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                                "$transferCost"),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              "Total Own Tr.Cost  :    ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                                "$ownTransportCost"),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              "Total Amount         :    ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                                "$totalAmount"),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              "Total paid               :    ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text("$paidTotal"),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              "Total Due                :    ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(double.parse(
                                                                    "${dueTotal}")
                                                                .toStringAsFixed(
                                                                    2)),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const Align(
                                              alignment: Alignment.center,
                                              child: Center(
                                                child: Text(
                                                  "No Data Found",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.red),
                                                ),
                                              )),
                                )
                              : data == 'showByUserWithDetails'
                                  ? Expanded(
                                      child: isLoading
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : allPurchaseRecordData.isNotEmpty
                                              ? Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Container(
                                                        child: DataTable(
                                                          headingRowHeight:
                                                              25.0,
                                                          dataRowMaxHeight:
                                                              double.infinity,
                                                          showCheckboxColumn:
                                                              true,
                                                          border:
                                                              TableBorder.all(
                                                                  color: Colors
                                                                      .black54,
                                                                  width: 1),
                                                          columns: const [
                                                            DataColumn(
                                                              label: Expanded(
                                                                child: Center(
                                                                    child: Text(
                                                                        'Invoice No')),
                                                              ),
                                                            ),
                                                            DataColumn(
                                                              label: Expanded(
                                                                  child: Center(
                                                                      child: Text(
                                                                          'Date'))),
                                                            ),
                                                            DataColumn(
                                                              label: Expanded(
                                                                  child: Center(
                                                                child: Text(
                                                                    'Supplier Name'),
                                                              )),
                                                            ),
                                                            DataColumn(
                                                              label: Expanded(
                                                                  child: Center(
                                                                child: Text(
                                                                    'Product Name'),
                                                              )),
                                                            ),
                                                            DataColumn(
                                                              label: Expanded(
                                                                  child: Center(
                                                                      child: Text(
                                                                          'Price'))),
                                                            ),
                                                            DataColumn(
                                                              label: Expanded(
                                                                  child: Center(
                                                                      child: Text(
                                                                          'Quantity'))),
                                                            ),
                                                            DataColumn(
                                                              label: Expanded(
                                                                  child: Center(
                                                                      child: Text(
                                                                          'Total'))),
                                                            ),
                                                            DataColumn(
                                                              label: Expanded(
                                                                  child: Center(
                                                                      child: Text(
                                                                          'Invoice'))),
                                                            ),
                                                          ],
                                                          rows: List.generate(
                                                            allPurchaseRecordData
                                                                .length,
                                                            (int index) =>
                                                                DataRow(
                                                              cells: <DataCell>[
                                                                DataCell(
                                                                  Center(
                                                                      child: Text(
                                                                          '${allPurchaseRecordData[index].purchaseMasterInvoiceNo}')),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                      child: Text(
                                                                          '${allPurchaseRecordData[index].purchaseMasterOrderDate}')),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                      child: Text(
                                                                          '${allPurchaseRecordData[index].supplierName}')),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                    child: Column(
                                                                        children: List.generate(allPurchaseRecordData[index].purchaseDetails!.length, (j) {
                                                                      return Container(
                                                                        child: Center(
                                                                            child:
                                                                                Text(allPurchaseRecordData[index].purchaseDetails![j].productName)),
                                                                      );
                                                                    })),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                    child: Column(
                                                                        children: List.generate(allPurchaseRecordData[index].purchaseDetails!.length, (j) {
                                                                      return Container(
                                                                        child: Center(
                                                                            child:
                                                                                Text(double.parse(allPurchaseRecordData[index].purchaseDetails![j].purchaseDetailsRate).toStringAsFixed(2))),
                                                                      );
                                                                    })),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                    child: Column(
                                                                        children: List.generate(allPurchaseRecordData[index].purchaseDetails!.length, (j) {
                                                                      return Container(
                                                                        child: Center(
                                                                            child:
                                                                                Text(double.parse(allPurchaseRecordData[index].purchaseDetails![j].purchaseDetailsTotalQuantity).toStringAsFixed(2))),
                                                                      );
                                                                    })),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                    child: Column(
                                                                        children: List.generate(allPurchaseRecordData[index].purchaseDetails!.length, (j) {
                                                                      return Container(
                                                                        child: Center(
                                                                            child:
                                                                                Text(double.parse(allPurchaseRecordData[index].purchaseDetails![j].purchaseDetailsTotalAmount).toStringAsFixed(2))),
                                                                      );
                                                                    })),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Center(
                                                                    child:GestureDetector(
                                                                      child: const Icon(Icons.collections_bookmark,size: 18,),
                                                                      onTap: () {
                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseInvoicePage(
                                                                          purchaseId: allPurchaseRecordData[index].purchaseMasterSlNo,
                                                                        ),
                                                                        )
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const Align(
                                                  alignment: Alignment.center,
                                                  child: Center(
                                                    child: Text(
                                                      "No Data Found",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.red),
                                                    ),
                                                  )),
                                    )
                                  : Container()
        ],
      ),
    );
  }
}
