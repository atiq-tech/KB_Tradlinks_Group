//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/all_product_provider.dart';
import 'package:kbtradlink/provider/category_provider.dart';
import 'package:kbtradlink/provider/customer_provider.dart';
import 'package:kbtradlink/provider/employee_provider.dart';
import 'package:kbtradlink/provider/get_sales_provider.dart';
import 'package:kbtradlink/provider/category_wise_product_provider.dart';
import 'package:kbtradlink/provider/sale_details_provider.dart';
import 'package:kbtradlink/provider/sales_record_provider.dart';
import 'package:kbtradlink/screen/sales_module/sales_invoice_page.dart';
import 'package:kbtradlink/screen/sales_module/model/category_model.dart';
import 'package:kbtradlink/screen/administation_module/model/customer_model.dart';
import 'package:kbtradlink/screen/sales_module/model/employee_model.dart';
import 'package:kbtradlink/screen/administation_module/model/product_model.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class SalesRecord extends StatefulWidget {
  const SalesRecord({super.key});
  @override
  State<SalesRecord> createState() => _SalesRecordState();
}

class _SalesRecordState extends State<SalesRecord> {
  final TextEditingController customerController = TextEditingController();
  final TextEditingController employeeController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController productController = TextEditingController();

  String? firstPickedDate;
  var backEndFirstDate;
  var backEndSecondtDate;

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
        print("First Selected date $firstPickedDate");
      });
    }
    else{
      setState(() {
        firstPickedDate = Utils.formatFrontEndDate(toDay);
        backEndFirstDate = Utils.formatBackEndDate(toDay);
        print("First Selected date $firstPickedDate");
      });
    }
  }

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
        backEndSecondtDate = Utils.formatBackEndDate(selectedDate);
        print("First Selected date $secondPickedDate");
      });
    }else{
      setState(() {
        secondPickedDate = Utils.formatFrontEndDate(toDay);
        backEndSecondtDate = Utils.formatBackEndDate(toDay);
        print("First Selected date $secondPickedDate");
      });
    }
  }

  //main dropdowns logic
  bool isAllTypeClicked = true;
  bool isCustomerWiseClicked = false;
  bool isEmployeeWiseClicked = false;
  bool isCategoryWiseClicked = false;
  bool isProductWiseClicked = false;
  bool isUserWiseClicked = false;

  //sub dropdowns logic
  bool isWithoutDetailsClicked = true;
  bool isWithDetailsClicked = false;
  bool isCategorySelect = false;

  // dropdown value
  String? _selectedRecordTypes = 'Without Details';
  String? _selectedUserTypes;
  ///new
  String? _selectedCustomer;
  String? _selectedEmployee;
  String? _selectedCategory;
  String? _selectedProduct;
  var items = [
    'Admin',
    'Link Up',
  ];
  String? _selectedSearchTypes = 'All';
  final List<String> _searchTypes = [
    'All',
    'By Customer',
    'By Employee',
    'By Category',
    'By Product',
    'By User',
  ];
  final List<String> _recordType = [
    'Without Details',
    'With Details',
  ];
  String data = '';///< table condition
  // by user
  String? byUserId;
  String? byUserFullname;
  final provideSalesdetailsRecordList = [];
  //List<SaleDetails> provideSalesdetailsRecordListt = [];
  // bool isLoading = false;

  ///Sub total
  double? subTotal;
  double? vatTotal;
  double? discountTotal;
  double? transferCost;
  double? totalAmount;
  double? paidTotal;
  double? dueTotal;
  double? soldQuantity;

  @override
  void initState() {
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndSecondtDate = Utils.formatBackEndDate(DateTime.now());
    Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,customerType: '');
    Provider.of<AllEmployeeProvider>(context, listen: false).fetchEmployee(context);
    Provider.of<CategoryProvider>(context, listen: false).getCategoryData();
    Provider.of<AllProductProvider>(context, listen: false).getAllProduct();
    Provider.of<CategoryProvider>(context, listen: false).getCategoryData();
    Provider.of<CategoryWiseProductProvider>(context, listen: false).getCategoryWiseProduct(isService: "yes",categoryId: '',branchId:'');
    //get Sales
    //Provider.of<GetSalesProvider>(context,listen: false).getGatSales(context, "", "", "", "", "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allCustomersData = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.displayName!="General Customer");
    final allEmployee = Provider.of<AllEmployeeProvider>(context).allEmployeeList;
    final allCategory = Provider.of<CategoryProvider>(context).categoryList;
    final productList = Provider.of<AllProductProvider>(context).productList;
    //get Sales
    final allGetSalesData = Provider.of<GetSalesProvider>(context).getSaleslist;
    print("Get Sales length=====> ${allGetSalesData.length} ");
    ///Sub total
    subTotal=allGetSalesData.map((e) => e.saleMasterSubTotalAmount).fold(0.0, (p, element) => p!+double.parse(element));
    vatTotal=allGetSalesData.map((e) => e.saleMasterTaxAmount).fold(0.0, (p, element) => p!+double.parse(element));
    discountTotal=allGetSalesData.map((e) => e.saleMasterTotalDiscountAmount).fold(0.0, (p, element) => p!+double.parse(element));
    transferCost=allGetSalesData.map((e) => e.saleMasterFreight).fold(0.0, (p, element) => p!+double.parse(element));
    totalAmount=allGetSalesData.map((e) => e.saleMasterTotalSaleAmount).fold(0.0, (p, element) => p!+double.parse(element));
    paidTotal=allGetSalesData.map((e) => e.saleMasterPaidAmount).fold(0.0, (p, element) => p!+double.parse(element));
    dueTotal=allGetSalesData.map((e) => e.saleMasterDueAmount).fold(0.0, (p, element) => p!+double.parse(element));
    //get Sales Record
    final allGetSalesRecordData =
        Provider.of<SalesRecordProvider>(context).getSalesRecordlist;
    print("Get Sales record length=====> ${allGetSalesRecordData.length} ");
    //get Sale_details
    final allGetSaleDetailsData =
        Provider.of<SaleDetailsProvider>(context).getSaleDetailsList;
    print("Get Sale_Details length=====> ${allGetSaleDetailsData.length} ");
    ///soldQuantity total
    soldQuantity=allGetSaleDetailsData.map((e) => e.saleDetailsTotalQuantity).fold(0.0, (p, element) => p!+double.parse(element));
    return Scaffold(
      appBar: CustomAppBar(title:"Sales Record"),
      body: Container(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0,bottom: 30),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              //margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.only(left: 4.0, right: 4.0,top: 4.0,bottom: 4.0),
              decoration: BoxDecoration(
                color: Color(0xffD2D2FF),
                //color: Colors.yellow.shade50,
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
                    offset: const Offset(0, 3), // changes the position of the shadow
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
                            //margin: const EdgeInsets.only(top: 5, bottom: 5),
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
                                  isExpanded: true,
                                  hint: const Text(
                                    'Please select a type',
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ), // Not necessary for Option 1
                                  value: _selectedSearchTypes,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedSearchTypes = newValue.toString();
                                      _selectedSearchTypes == "All"
                                          ? isAllTypeClicked = true
                                          : isAllTypeClicked = false;

                                      _selectedSearchTypes == "By Customer"
                                          ? isCustomerWiseClicked = true
                                          : isCustomerWiseClicked = false;

                                      _selectedSearchTypes == "By Employee"
                                          ? isEmployeeWiseClicked = true
                                          : isEmployeeWiseClicked = false;

                                      _selectedSearchTypes == "By Category"
                                          ? isCategoryWiseClicked = true
                                          : isCategoryWiseClicked = false;

                                      _selectedSearchTypes == "By Product"
                                          ? isProductWiseClicked = true
                                          : isProductWiseClicked = false;

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
                            margin: const EdgeInsets.only(top: 4.0, bottom: 0.0),
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
                                isExpanded: true,
                                hint: const Text(
                                  'Please select a record type',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ), // Not necessary for Option 1
                                value: _selectedRecordTypes,
                                onChanged: (newValue) {
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
                  SizedBox(height: 5.0,),
                  isCustomerWiseClicked == true
                      ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Customer     :",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child:   Container(
                              height: 30.0,
                              width: MediaQuery.of(context).size.width / 2,
                              padding: const EdgeInsets.only(left: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 5, 107, 155),
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: TypeAheadFormField(
                                textFieldConfiguration:
                                TextFieldConfiguration(
                                  onChanged: (value){
                                    if (value == '') {
                                      _selectedCustomer = '';
                                    }
                                  },
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                  controller: customerController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    contentPadding: const EdgeInsets.only(bottom: 12),
                                    suffixIconConstraints: const BoxConstraints(maxHeight: 30),
                                    hintText: 'Select Customer',
                                    suffixIcon: _selectedCustomer == '' ? null : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          customerController.text = '';
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 9),
                                        child: Icon(Icons.close,size: 16),
                                      ),
                                    ),
                                  ),
                                ),
                                suggestionsCallback: (pattern) {

                                  return allCustomersData
                                      .where((element) => element.displayName!
                                      .toLowerCase()
                                      .contains(pattern
                                      .toString()
                                      .toLowerCase()))
                                      .take(allCustomersData.length)
                                      .toList();
                                  // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                                },
                                itemBuilder: (context, suggestion) {
                                  return SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                      child: Text(
                                        "${suggestion.customerCode} - ${suggestion.customerName} - - ${suggestion.customerAddress}",
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 1,overflow: TextOverflow.ellipsis,),
                                    ),
                                  );
                                },
                                transitionBuilder:
                                    (context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected:
                                    (CustomerModel suggestion) {
                                  customerController.text = suggestion.displayName!;
                                  setState(() {
                                    _selectedCustomer = suggestion.customerSlNo.toString();
                                  });
                                },
                                onSaved: (value) {},
                              ),
                            ),
                          )
                        ],
                      ), //Customer
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
                                margin: const EdgeInsets.only(top: 4, bottom: 0),
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
                                    isExpanded: true, // Not necessary for Option 1
                                    value: _selectedRecordTypes,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedRecordTypes = newValue!;
                                        _selectedRecordTypes ==
                                            "Without Details"
                                            ? isWithoutDetailsClicked = true
                                            : isWithoutDetailsClicked =
                                        false;
                                        _selectedRecordTypes ==
                                            "With Details"
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
                      ), //Record Type
                    ],
                  )
                      : Container(),
                  isEmployeeWiseClicked == true
                      ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Employee     :",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child:  Container(
                              margin: const EdgeInsets.only(top: 0, bottom: 0),
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
                                textFieldConfiguration:
                                TextFieldConfiguration(
                                  onChanged: (value){
                                    if (value == '') {
                                      _selectedEmployee = '';
                                    }
                                  },
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  controller: employeeController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    suffixIconConstraints: const BoxConstraints(maxHeight: 30),
                                    isDense: true,
                                    hintText: 'Select Employee',
                                    hintStyle: const TextStyle(fontSize: 13.0),
                                    suffixIcon: _selectedEmployee == '' ? null : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          employeeController.text = '';
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 5),
                                        child: Icon(Icons.close,size: 16),
                                      ),
                                    ),
                                  ),
                                ),
                                suggestionsCallback: (pattern) {
                                  return allEmployee
                                      .where((element) => element.employeeName
                                      .toString()
                                      .toLowerCase()
                                      .contains(pattern
                                      .toString()
                                      .toLowerCase()))
                                      .take(allEmployee.length)
                                      .toList();
                                  // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                                },
                                itemBuilder: (context, suggestion) {
                                  return SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                      child: Text(
                                        "${suggestion.employeeName}",
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 1,overflow: TextOverflow.ellipsis,),
                                    ),
                                  );
                                },
                                transitionBuilder:
                                    (context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected:
                                    (EmployeeModel suggestion) {
                                      employeeController.text = suggestion.employeeName;
                                  setState(() {
                                    _selectedEmployee = suggestion.employeeSlNo.toString();
                                  });
                                },
                                onSaved: (value) {},
                              ),
                            ),
                          )
                        ],
                      ),
                      // Employee
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
                                margin: const EdgeInsets.only(top: 4, bottom: 2),
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
                                    isExpanded: true,
                                    // hint: const Text(
                                    //   'Please select a record type',
                                    //   style: TextStyle(
                                    //     fontSize: 14,
                                    //   ),
                                    // ), // Not necessary for Option 1
                                    value: _selectedRecordTypes,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedRecordTypes = newValue!;
                                        _selectedRecordTypes ==
                                            "Without Details"
                                            ? isWithoutDetailsClicked = true
                                            : isWithoutDetailsClicked =
                                        false;
                                        _selectedRecordTypes ==
                                            "With Details"
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
                      ), // Record Type
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
                              "Category     :",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
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
                                textFieldConfiguration:
                                TextFieldConfiguration(
                                    onChanged: (value){
                                      if (value == '') {
                                        _selectedCategory = '';
                                      }
                                    },
                                    style: const TextStyle(
                                      fontSize: 13, color: Color.fromARGB(255, 126, 125, 125),
                                    ),
                                    controller: categoryController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      suffixIconConstraints: const BoxConstraints(maxHeight: 30),
                                      contentPadding: const EdgeInsets.only(top: 5),
                                      hintText: 'Select Category',
                                      isDense: true,
                                      hintStyle: const TextStyle(fontSize: 13),
                                      suffixIcon: _selectedCategory == '' ? null : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            categoryController.text = '';
                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 4),
                                          child: Icon(Icons.close,size: 16),
                                        ),
                                      ),
                                    )
                                ),
                                suggestionsCallback: (pattern) {
                                  return allCategory
                                      .where((element) => element.productCategoryName
                                      .toLowerCase()
                                      .contains(pattern
                                      .toString()
                                      .toLowerCase()))
                                      .take(allCategory.length)
                                      .toList();
                                  // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                                },
                                itemBuilder: (context, suggestion) {
                                  return SizedBox(child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: Text(suggestion.productCategoryName,
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                  );
                                },
                                transitionBuilder:(context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected:(CategoryModel suggestion) {
                                  categoryController.text = suggestion.productCategoryName;
                                  setState(() {
                                    _selectedCategory = suggestion.productCategorySlNo.toString();
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
                  isProductWiseClicked == true ? Row(
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
                            child: SizedBox(
                              child: TypeAheadFormField(
                                textFieldConfiguration:
                                TextFieldConfiguration(
                                    onChanged: (value){
                                      if (value == '') {
                                        _selectedProduct = '';
                                      }
                                    },
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                        overflow: TextOverflow.ellipsis
                                    ),
                                    controller: productController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      suffixIconConstraints: const BoxConstraints(maxHeight: 30),
                                      contentPadding: const EdgeInsets.only(top: 5),
                                      isDense: true,
                                      hintText: 'Select Product',
                                      hintStyle: const TextStyle(fontSize: 13),
                                      suffixIcon: _selectedProduct == '' ? null : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            productController.text = '';
                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 3),
                                          child: Icon(Icons.close,size: 16),
                                        ),
                                      ),
                                    )
                                ),
                                suggestionsCallback: (pattern) {
                                  return productList
                                      .where((element) => element.displayText
                                      .toLowerCase()
                                      .contains(pattern
                                      .toString()
                                      .toLowerCase()))
                                      .take(productList.length)
                                      .toList();
                                  // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                                },
                                itemBuilder: (context, suggestion) {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      child: Text(suggestion.displayText,
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                },
                                transitionBuilder:(context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected:(ProductModel suggestion) {
                                  productController.text = suggestion.displayText;
                                  setState(() {
                                    _selectedProduct = suggestion.productSlNo;

                                    print("dfhsghdfkhgkh $_selectedProduct");

                                    final results = [
                                      productList.where((m) =>
                                          m.productSlNo.toString().contains(
                                              suggestion.productSlNo.toString())) // or Testing 123
                                          .toList(),
                                    ];
                                    print("dfhsghdfkhgkh $results");

                                    results.forEach((element) async {
                                    });
                                  });
                                },
                                onSaved: (value) {},
                              ),
                            )
                        ),
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
                              //margin: const EdgeInsets.only(top: 2, bottom: 2),
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
                                  items: items.map(
                                          (location) {
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
                                margin: const EdgeInsets.only(top: 4, bottom: 3),
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
                                    isExpanded: true,
                                    // hint: const Text(
                                    //   'Please select a record type',
                                    //   style: TextStyle(
                                    //     fontSize: 14,
                                    //   ),
                                    // ), // Not necessary for Option 1
                                    value: _selectedRecordTypes,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedRecordTypes = newValue!;
                                        _selectedRecordTypes ==
                                            "Without Details"
                                            ? isWithoutDetailsClicked = true
                                            : isWithoutDetailsClicked =
                                        false;
                                        _selectedRecordTypes ==
                                            "With Details"
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
                      ),
                    ],
                  )
                      : Container(),
                  SizedBox(
                    height: 40.0,
                    width: double.infinity,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(right: 5, bottom: 5),
                            height: 30,
                            padding: const EdgeInsets.only(
                                top:5, bottom: 5, left: 5, right: 5),
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
                                  contentPadding:
                                  const EdgeInsets.only(top: 10, left: 5),
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
                                  hintText: firstPickedDate ,
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
                        Container(
                          child: const Text("To"),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5,bottom: 5),
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
                                _secondSelectedDate();
                              }),
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  contentPadding:
                                  const EdgeInsets.only(top: 10, left: 5),
                                  filled: true,
                                  //fillColor: Colors.blue[50],
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
                                  hintText: secondPickedDate,
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
                      ],
                    ),
                  ),
                /// Date Picker
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      //color: const Color.fromARGB(255, 3, 91, 150),
                      padding: const EdgeInsets.all(1.0),
                      child: InkWell(
                        onTap: () async {
                          // final connectivityResult = await (Connectivity().checkConnectivity());
                          // if (connectivityResult == ConnectivityResult.mobile
                          //     || connectivityResult == ConnectivityResult.wifi) {
                            GetSalesProvider().on();
                            SalesRecordProvider().on();
                            SaleDetailsProvider().on();
                            setState(() {
                              // AllType
                              print(
                                  " dsafasfasfasdfasdf${isAllTypeClicked} && ${isWithoutDetailsClicked}");

                              if (isAllTypeClicked && isWithoutDetailsClicked) {
                                print(
                                    " dsafasfasfasdfasdf${isAllTypeClicked} && ${isWithoutDetailsClicked}");

                                data = 'showAllWithoutDetails';
                                //get sales api AllType
                                Provider.of<GetSalesProvider>(context,
                                        listen: false)
                                    .getGatSales(
                                  context,
                                  "",
                                  "$backEndFirstDate",
                                  "$backEndSecondtDate",
                                  "",
                                  "",
                                );
                                print(
                                    "get sales api AllType ${backEndFirstDate} && ${backEndSecondtDate}");
                              } else if (isAllTypeClicked &&
                                  isWithDetailsClicked) {
                                data = 'showAllWithDetails';
                                //get sales Record api AllType
                                Provider.of<SalesRecordProvider>(context,
                                        listen: false)
                                    .getSalesRecord(
                                  context,
                                  "",
                                  "$backEndFirstDate",
                                  "$backEndSecondtDate",
                                  "",
                                  "",
                                );
                                print(
                                    "get sales Record api AllType ${backEndFirstDate} && ${backEndSecondtDate}");
                              }
                              // By Customer
                              else if (isCustomerWiseClicked &&
                                  isWithoutDetailsClicked) {
                                data = 'showByCustomerWithoutDetails';
                                //get sales api CustomerType
                                Provider.of<GetSalesProvider>(context,
                                        listen: false)
                                    .getGatSales(
                                  context,
                                  "$_selectedCustomer",
                                  "$backEndFirstDate",
                                  "$backEndSecondtDate",
                                  "",
                                  "",
                                );
                                print(
                                    "get sales api CustomerType date ${backEndFirstDate} && ${backEndSecondtDate}");
                              } else if (isCustomerWiseClicked &&
                                  isWithDetailsClicked) {
                                data = 'showByCustomerWithDetails';
                                //get sales Record api CustomerType
                                Provider.of<SalesRecordProvider>(context,
                                        listen: false)
                                    .getSalesRecord(
                                  context,
                                  "$_selectedCustomer",
                                  "$backEndFirstDate",
                                  "$backEndSecondtDate",
                                  "",
                                  "",
                                );
                                print(
                                    "get sales record api CustomerType date ${backEndFirstDate} && ${backEndSecondtDate}");
                              }
                              // By Employee
                              else if (isEmployeeWiseClicked &&
                                  isWithoutDetailsClicked) {
                                data = 'showByEmployeeWithoutDetails';
                                //get sales api EmployeeType
                                Provider.of<GetSalesProvider>(context,
                                        listen: false)
                                    .getGatSales(
                                  context,
                                  "",
                                  "$backEndFirstDate",
                                  "$backEndSecondtDate",
                                  "$_selectedEmployee",
                                  "",
                                );
                                print(
                                    "get sales api EmployeeType date ${backEndFirstDate} && ${backEndSecondtDate}");
                              } else if (isEmployeeWiseClicked &&
                                  isWithDetailsClicked) {
                                data = 'showByEmployeeWithDetails';
                                //get sales Record api  EmployeeType
                                Provider.of<SalesRecordProvider>(context,
                                        listen: false)
                                    .getSalesRecord(
                                  context,
                                  "",
                                  "$backEndFirstDate",
                                  "$backEndSecondtDate",
                                  "$_selectedEmployee",
                                  "",
                                );
                                print(
                                    "get sales Record api  EmployeeType date ${backEndFirstDate} && ${backEndSecondtDate}");
                              }
                              // By Category
                              else if (isCategoryWiseClicked) {
                                data = 'showByCategoryDetails';
                                //get sale_details categoryType
                                Provider.of<SaleDetailsProvider>(context,
                                        listen: false)
                                    .getSaleDetails(
                                  context,
                                  "$_selectedCategory",
                                  "$backEndFirstDate",
                                  "$backEndSecondtDate",
                                  "",
                                );
                                print(
                                    "get sale_details categoryType date ${backEndFirstDate} && ${backEndSecondtDate}");
                              }
                              // By product
                              else if (isProductWiseClicked) {
                                data = 'showByProductDetails';
                                //get sale_details ProductType
                                Provider.of<SaleDetailsProvider>(context,
                                        listen: false)
                                    .getSaleDetails(
                                  context,
                                  "",
                                  "$backEndFirstDate",
                                  "$backEndSecondtDate",
                                  "$_selectedProduct",
                                );
                                print(
                                    "get sale_details  Product date ${backEndFirstDate} && ${backEndSecondtDate}");
                              }
                              // By User
                              else if (isUserWiseClicked &&
                                  isWithoutDetailsClicked) {
                                data = 'showByUserWithoutDetails';
                                //get sales api UserType
                                Provider.of<GetSalesProvider>(context,
                                        listen: false)
                                    .getGatSales(
                                  context,
                                  "",
                                  "$backEndFirstDate",
                                  "$backEndSecondtDate",
                                  "",
                                  "$_selectedUserTypes",
                                );
                              } else if (isUserWiseClicked &&
                                  isWithDetailsClicked) {
                                data = 'showByUserWithDetails';
                                //get sales Record api UserType
                                Provider.of<SalesRecordProvider>(context,
                                        listen: false)
                                    .getSalesRecord(
                                  context,
                                  "",
                                  "$backEndFirstDate",
                                  "$backEndSecondtDate",
                                  "",
                                  "$_selectedUserTypes",
                                );
                              }
                            });
                          // }
                          // else{
                          //   Utils.errorSnackBar(context, "Please connect with internet");
                          // }
                        },
                        child: Container(
                          height: 30.0,
                          width: 100.0,
                          decoration: BoxDecoration(

                            color: const Color.fromARGB(255, 4, 113, 185),
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3), // changes the position of the shadow
                              ),
                            ],
                          ),
                          child: const Center(
                              child: Text(
                                "Show Report",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            data == 'showAllWithoutDetails'
                ? Expanded(
              child:
              GetSalesProvider.isSearchTypeChange
                  ? const Center(child: CircularProgressIndicator())
                  : allGetSalesData.isNotEmpty?
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // color: Colors.red,
                          // padding:EdgeInsets.only(bottom: 16.0),
                          child: DataTable(
                            headingRowHeight: 25.0,
                            dataRowHeight: 25.0,
                            showCheckboxColumn: true,
                            border: TableBorder.all(
                                color: Colors.black54, width: 1),
                            columns: const [
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Invoice No'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Date'))),
                              ),
                              DataColumn(
                                label:
                                Expanded(child: Center(child: Text('Customer Name'))),
                              ),
                              DataColumn(
                                label:
                                Expanded(child: Center(child: Text('Employee Name'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Saved By'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Sub Total'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Vat'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Discount'))),
                              ),
                              DataColumn(
                                label:
                                Expanded(child: Center(child: Text('Transport Cost'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Total'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Paid'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Due'))),
                              ),
                              DataColumn(
                                label: Expanded(child: Center(child: Text('Invoice'))),
                              ),
                            ],
                            rows: List.generate(
                              allGetSalesData.length,
                                  (int index) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Center(
                                        child: Text(
                                            "${allGetSalesData[index].saleMasterInvoiceNo}")),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].saleMasterSaleDate}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].customerName}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].employeeName}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].addBy}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            "${allGetSalesData[index].saleMasterSubTotalAmount}")),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].saleMasterTaxAmount}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].saleMasterTotalDiscountAmount}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].saleMasterFreight}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].saleMasterTotalSaleAmount}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].saleMasterPaidAmount}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].saleMasterDueAmount}')),
                                  ),
                                  DataCell(
                                    Center(
                                      child:GestureDetector(
                                        child: const Icon(Icons.collections_bookmark,size: 18,),
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SalesInvoicePage(
                                            salesId: allGetSalesData[index].saleMasterSlNo,
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
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            const Text("Total Sub Total       :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                            Text("$subTotal"),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Text("Total Vat                  :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                            Text("$vatTotal"),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Text("Total Discount        :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                            Text("$discountTotal"),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Text("Total Trans.Cost    :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                            Text("$transferCost"),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Text("Total Amount         :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                            Text("$totalAmount"),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Text("Total paid               :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                            Text("$paidTotal"),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Text("Total Due                :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                            Text("$dueTotal"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ) : const Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 16,color: Colors.red),),)),
            )
                : data == 'showAllWithDetails'
                ? Expanded(
              child:
              SalesRecordProvider.isSearchTypeChange
                  ? const Center(child: CircularProgressIndicator())
                  : allGetSalesRecordData.isNotEmpty?
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowHeight: 25.0,
                      dataRowMaxHeight: double.infinity,
                      showCheckboxColumn: true,
                      border: TableBorder.all(
                          color: Colors.black54, width: 1),
                      columns: const [
                        DataColumn(
                          label:
                          Expanded(child: Center(child: Text('Invoice No'))),
                        ),
                        DataColumn(
                          label: Expanded(child: Center(child: Text('Date'))),
                        ),
                        DataColumn(
                          label: Expanded(
                              child: Center(child: Text('Customer Name'))),
                        ),
                        DataColumn(
                          label: Expanded(
                              child: Center(child: Text('Employee Name'))),
                        ),
                        DataColumn(
                          label:
                          Expanded(child: Center(child: Text('Saved By'))),
                        ),
                        DataColumn(
                          label: Expanded(
                              child: Center(child: Text('Product Name'))),
                        ),
                        DataColumn(
                          label: Expanded(child: Center(child: Text('Price'))),
                        ),
                        DataColumn(
                          label:
                          Expanded(child: Center(child: Text('Quantity'))),
                        ),
                        DataColumn(
                          label: Expanded(child: Center(child: Text('Total'))),
                        ),
                        DataColumn(
                          label: Expanded(child: Center(child: Text('Invoice'))),
                        ),
                      ],
                      rows: List.generate(
                        allGetSalesRecordData.length,
                            (int index) => DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Center(
                                  child: Text(
                                      "${allGetSalesRecordData[index].saleMasterInvoiceNo}")),
                            ),
                            DataCell(
                              Center(
                                  child: Text(
                                      '${allGetSalesRecordData[index].saleMasterSaleDate}')),
                            ),
                            DataCell(
                              Center(
                                  child: Text(
                                      '${allGetSalesRecordData[index].customerName}')),
                            ),
                            DataCell(
                              Center(
                                  child: Text(
                                      '${allGetSalesRecordData[index].employeeName}')),
                            ),
                            DataCell(
                              Center(
                                  child: Text(
                                      '${allGetSalesRecordData[index].addBy}')),
                            ),
                            DataCell(
                              Center(
                                child: Column(
                                    children:
                                    List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
                                      return Container(
                                        child: Center(
                                            child: Text(
                                                allGetSalesRecordData[index].saleDetails[j].productName)
                                        ),
                                      );
                                    })
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Column(
                                    children:
                                    List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
                                      return Container(
                                        child: Center(
                                            child: Text(
                                                double.parse(allGetSalesRecordData[index].saleDetails[j].saleDetailsRate).toStringAsFixed(2))
                                        ),
                                      );
                                    })
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Column(
                                    children:
                                    List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
                                      return Container(
                                        child: Center(
                                            child: Text(
                                                double.parse(allGetSalesRecordData[index].saleDetails[j].saleDetailsTotalQuantity).toStringAsFixed(2))
                                        ),
                                      );
                                    })
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Column(
                                    children:
                                    List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
                                      return Container(
                                        child: Center(
                                            child: Text(
                                                double.parse(allGetSalesRecordData[index].saleDetails[j].saleDetailsTotalAmount).toStringAsFixed(2))
                                        ),
                                      );
                                    })
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child:GestureDetector(
                                  child: const Icon(Icons.collections_bookmark,size: 18,),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SalesInvoicePage(
                                      salesId: allGetSalesRecordData[index].saleMasterSlNo,
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
              ): const Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 16,color: Colors.red),),)),
            )
                : data == 'showByCustomerWithoutDetails'
                ? Expanded(
              child:
              GetSalesProvider.isSearchTypeChange
                  ? const Center(child: CircularProgressIndicator())
                  : allGetSalesData.isNotEmpty?
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DataTable(
                          headingRowHeight: 20.0,
                          dataRowHeight: 20.0,
                          showCheckboxColumn: true,
                          border: TableBorder.all(
                              color: Colors.black54, width: 1),
                          columns: const [
                            DataColumn(
                              label: Expanded(
                                  child: Center(child: Text('Invoice No'))),
                            ),
                            DataColumn(
                              label:
                              Expanded(child: Center(child: Text('Date'))),
                            ),
                            DataColumn(
                              label: Expanded(
                                  child: Center(child: Text('Customer Name'))),
                            ),
                            DataColumn(
                              label: Expanded(
                                  child: Center(child: Text('Employee Name'))),
                            ),
                            DataColumn(
                              label: Expanded(
                                  child: Center(child: Text('Saved By'))),
                            ),
                            DataColumn(
                              label: Expanded(
                                  child: Center(child: Text('Sub Total'))),
                            ),
                            DataColumn(
                              label: Expanded(child: Center(child: Text('Vat'))),
                            ),
                            DataColumn(
                              label: Expanded(
                                  child: Center(child: Text('Discount'))),
                            ),
                            DataColumn(
                              label: Expanded(
                                  child:
                                  Center(child: Text('Transport Cost'))),
                            ),
                            DataColumn(
                              label:
                              Expanded(child: Center(child: Text('Total'))),
                            ),
                            DataColumn(
                              label:
                              Expanded(child: Center(child: Text('Paid'))),
                            ),
                            DataColumn(
                              label: Expanded(child: Center(child: Text('Due'))),
                            ),
                            DataColumn(
                              label: Expanded(child: Center(child: Text('Invoice'))),
                            ),
                          ],
                          rows: List.generate(
                            allGetSalesData.length,
                                (int index) => DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Center(
                                      child: Text(
                                          "${allGetSalesData[index].saleMasterInvoiceNo}")),
                                ),
                                DataCell(
                                  Center(
                                      child: Text(
                                          '${allGetSalesData[index].saleMasterSaleDate}')),
                                ),
                                DataCell(
                                  Center(
                                      child: Text(
                                          '${allGetSalesData[index].customerName}')),
                                ),
                                DataCell(
                                  Center(
                                      child: Text(
                                          '${allGetSalesData[index].employeeName}' == "null" ? '' : '${allGetSalesData[index].employeeName}')),
                                ),
                                DataCell(
                                  Center(
                                      child: Text(
                                          '${allGetSalesData[index].addBy}')),
                                ),
                                DataCell(
                                  Center(
                                      child: Text(
                                          "${allGetSalesData[index].saleMasterSubTotalAmount}")),
                                ),
                                DataCell(
                                  Center(
                                      child: Text(
                                          "${allGetSalesData[index].saleMasterTaxAmount}")),
                                ),
                                DataCell(
                                  Center(
                                      child: Text(
                                          '${allGetSalesData[index].saleMasterTotalDiscountAmount}')),
                                ),
                                DataCell(
                                  Center(
                                      child: Text(
                                          "${allGetSalesData[index].saleMasterFreight}")),
                                ),
                                DataCell(
                                  Center(
                                      child: Text(
                                          '${allGetSalesData[index].saleMasterTotalSaleAmount}')),
                                ),
                                DataCell(
                                  Center(
                                      child: Text(
                                          '${allGetSalesData[index].saleMasterPaidAmount}')),
                                ),
                                DataCell(
                                  Center(
                                      child: Text(
                                          '${allGetSalesData[index].saleMasterDueAmount}')),
                                ),
                                DataCell(
                                  Center(
                                    child:GestureDetector(
                                      child: const Icon(Icons.collections_bookmark,size: 18,),
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SalesInvoicePage(
                                          salesId: allGetSalesData[index].saleMasterSlNo,
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
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            const Text("Total Sub Total       :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                            Text("$subTotal"),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Text("Total Vat                  :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                            Text("$vatTotal"),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Text("Total Discount        :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                            Text("$discountTotal"),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Text("Total Trans.Cost    :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                            Text("$transferCost"),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Text("Total Amount         :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                            Text("$totalAmount"),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Text("Total paid               :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                            Text("$paidTotal"),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Text("Total Due                :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                            Text("$dueTotal"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ): const Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 16,color: Colors.red),),)),
            )
                : data == 'showByCustomerWithDetails'
                ? Expanded(
              child:
              SalesRecordProvider.isSearchTypeChange
                  ? const Center(child: CircularProgressIndicator())
                  : allGetSalesRecordData.isNotEmpty?
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      child: DataTable(
                        headingRowHeight: 25.0,
                        // dataRowHeight: 20.0,
                        dataRowMaxHeight: double.infinity,
                        showCheckboxColumn: true,
                        border: TableBorder.all(
                          color: Colors.black54,
                          width: 1,
                        ),
                        columns: const [
                          DataColumn(
                            label: Expanded(
                                child:
                                Center(child: Text('Invoice No'))),
                          ),
                          DataColumn(
                            label: Expanded(
                                child: Center(child: Text('Date'))),
                          ),
                          DataColumn(
                            label: Expanded(
                                child: Center(
                                  child: Text(
                                      'Customer Name'),
                                )),
                          ),
                          DataColumn(
                            label: Expanded(
                                child: Center(
                                  child: Text(
                                      'Employee Name'),
                                )),
                          ),
                          DataColumn(
                            label: Expanded(
                                child: Center(child: Text('Saved By'))),
                          ),
                          DataColumn(
                            label: Expanded(
                                child:
                                Center(child: Text('Product Name'))),
                          ),
                          DataColumn(
                            label: Expanded(
                                child: Center(child: Text('Price'))),
                          ),
                          DataColumn(
                            label: Expanded(
                                child: Center(child: Text('Quantity'))),
                          ),
                          DataColumn(
                            label: Expanded(
                                child: Center(child: Text('Total'))),
                          ),
                          DataColumn(
                            label: Expanded(
                                child: Center(child: Text('Invoice'))),
                          ),
                        ],
                        rows: List.generate(
                            allGetSalesRecordData.length,
                                (int index) {
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Center(
                                        child: Text(
                                            "${allGetSalesRecordData[index].saleMasterInvoiceNo}")),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesRecordData[index].saleMasterSaleDate}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesRecordData[index].customerName}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            "${allGetSalesRecordData[index].employeeName}")),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesRecordData[index].addBy}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Column(
                                            children:
                                            List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
                                              return Container(
                                                child: Center(
                                                    child: Text(
                                                        allGetSalesRecordData[index].saleDetails[j].productName)
                                                ),
                                              );
                                            })
                                        ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Column(
                                          children:
                                          List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
                                            return Container(
                                              child: Center(
                                                  child: Text(
                                                  double.parse(allGetSalesRecordData[index].saleDetails[j].saleDetailsRate).toStringAsFixed(2))
                                              ),
                                            );
                                          })
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Column(
                                          children:
                                          List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
                                            return Container(
                                              child: Center(
                                                  child: Text(
                                                  double.parse(allGetSalesRecordData[index].saleDetails[j].saleDetailsTotalQuantity).toStringAsFixed(2))
                                              ),
                                            );
                                          })
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Column(
                                          children:
                                          List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
                                            return Container(
                                              child: Center(
                                                  child: Text(
                                                  double.parse(allGetSalesRecordData[index].saleDetails[j].saleDetailsTotalAmount).toStringAsFixed(2))
                                            ),
                                            );
                                          })
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child:GestureDetector(
                                        child: const Icon(Icons.collections_bookmark,size: 18,),
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SalesInvoicePage(
                                            salesId: allGetSalesRecordData[index].saleMasterSlNo,
                                          ),
                                          )
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                  ),
                ),
              ): const Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 16,color: Colors.red),),)),
            )
                : data == 'showByEmployeeWithoutDetails'
                ? Expanded(
              child:
              GetSalesProvider.isSearchTypeChange
                  ? const Center(
                  child: CircularProgressIndicator())
                  : allGetSalesData.isNotEmpty?
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      // color: Colors.red,
                      // padding:EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DataTable(
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
                                          'Invoice No'),
                                    )),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Center(child: Text('Date'))),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Center(
                                      child: Text(
                                          'Customer Name'),
                                    )),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Center(
                                      child: Text(
                                          'Employee Name'),
                                    )),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child:
                                    Center(child: Text('Saved By'))),
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
                                    child: Center(child: Text('Vat'))),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child:
                                    Center(child: Text('Discount'))),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Center(
                                      child: Text(
                                          'Transport Cost'),
                                    )),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Center(child: Text('Total'))),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Center(child: Text('Paid'))),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Center(child: Text('Due'))),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Center(child: Text('Invoice'))),
                              ),
                            ],
                            rows: List.generate(
                              allGetSalesData.length,
                                  (int index) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].saleMasterInvoiceNo}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].saleMasterSaleDate}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].customerName}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].employeeName}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].addBy}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].saleMasterSubTotalAmount}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].saleMasterTaxAmount}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].saleMasterTotalDiscountAmount}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].saleMasterFreight}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].saleMasterTotalSaleAmount}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].saleMasterPaidAmount}')),
                                  ),
                                  DataCell(
                                    Center(
                                        child: Text(
                                            '${allGetSalesData[index].saleMasterDueAmount}')),
                                  ),
                                  DataCell(
                                    Center(
                                      child:GestureDetector(
                                        child: const Icon(Icons.collections_bookmark,size: 18,),
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SalesInvoicePage(
                                            salesId: allGetSalesData[index].saleMasterSlNo,
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
                          const SizedBox(height: 20,),
                          Row(
                            children: [
                              const Text("Total Sub Total       :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                              Text("$subTotal"),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              const Text("Total Vat                  :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                              Text("$vatTotal"),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              const Text("Total Discount        :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                              Text("$discountTotal"),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              const Text("Total Trans.Cost    :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                              Text("$transferCost"),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              const Text("Total Amount         :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                              Text("$totalAmount"),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              const Text("Total paid               :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                              Text("$paidTotal"),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              const Text("Total Due                :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                              Text("$dueTotal"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ): const Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 16,color: Colors.red),),)),
            )
                : data == 'showByEmployeeWithDetails'
                ? Expanded(
              child:
              SalesRecordProvider.isSearchTypeChange
                  ? const Center(
                  child:
                  CircularProgressIndicator())
                  : allGetSalesRecordData.isNotEmpty?
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection:
                    Axis.horizontal,
                    child: Container(
                      // color: Colors.red,
                      // padding:EdgeInsets.only(bottom: 16.0),
                      child: DataTable(
                        headingRowHeight: 25.0,
                        // dataRowHeight: 20.0,
                        dataRowMaxHeight: double.infinity,
                        showCheckboxColumn: true,
                        border: TableBorder.all(
                            color: Colors.black54,
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
                                child:
                                Center(child: Text('Date'))),
                          ),
                          DataColumn(
                            label: Expanded(
                                child: Center(
                                  child: Text(
                                      'Customer Name'),
                                )),
                          ),
                          DataColumn(
                            label: Expanded(
                                child: Center(
                                  child: Text(
                                      'Employee Name'),
                                )),
                          ),
                          DataColumn(
                            label: Expanded(
                                child: Center(
                                  child: Text(
                                      'Saved By'),
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
                                      'Price'),
                                )),
                          ),
                          DataColumn(
                            label: Expanded(
                                child: Center(
                                  child: Text(
                                      'Quantity'),
                                )),
                          ),
                          DataColumn(
                            label: Expanded(
                                child: Center(
                                  child: Text(
                                      'Total'),
                                )),
                          ),
                          DataColumn(
                            label: Expanded(
                                child: Center(
                                  child: Text('Invoice'),
                                )),
                          ),
                        ],
                        rows: List.generate(
                          allGetSalesRecordData
                              .length,
                              (int index) => DataRow(
                            cells: <DataCell>[
                              DataCell(
                                Center(
                                    child: Text(
                                        "${allGetSalesRecordData[index].saleMasterInvoiceNo}")),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        '${allGetSalesRecordData[index].saleMasterSaleDate}')),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        '${allGetSalesRecordData[index].customerName}')),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        '${allGetSalesRecordData[index].employeeName}')),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        '${allGetSalesRecordData[index].addBy}')),
                              ),
                              DataCell(
                                Center(
                                  child: Column(
                                      children:
                                      List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
                                        return Container(
                                          child: Center(
                                              child: Text(
                                                  allGetSalesRecordData[index].saleDetails[j].productName)
                                          ),
                                        );
                                      })
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Column(
                                      children:
                                      List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
                                        return Container(
                                          child: Center(
                                              child: Text(
                                              double.parse(allGetSalesRecordData[index].saleDetails[j].saleDetailsRate).toStringAsFixed(2))

                                        ),
                                        );
                                      })
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Column(
                                      children:
                                      List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
                                        return Container(
                                          child: Center(
                                              child: Text(
                                                  double.parse(allGetSalesRecordData[index].saleDetails[j].saleDetailsTotalQuantity).toStringAsFixed(2))

                                          ),
                                        );
                                      })
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Column(
                                      children:
                                      List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
                                        return Container(
                                          child: Center(
                                              child: Text(
                                                  double.parse(allGetSalesRecordData[index].saleDetails[j].saleDetailsTotalAmount).toStringAsFixed(2))

                                          ),
                                        );
                                      })
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child:GestureDetector(
                                    child: const Icon(Icons.collections_bookmark,size: 18,),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SalesInvoicePage(
                                        salesId: allGetSalesRecordData[index].saleMasterSlNo,
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
              ): const Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 16,color: Colors.red),),)),
            )
                : data == 'showByCategoryDetails'
                ? Expanded(
              child:
              SaleDetailsProvider.isSearchTypeChange
                  ? const Center(
                  child:
                  CircularProgressIndicator())
                  : allGetSaleDetailsData.isNotEmpty?
              SizedBox(
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
                      // color: Colors.red,
                      // padding:EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DataTable(
                            headingRowHeight: 20.0,
                            dataRowHeight: 20.0,
                            showCheckboxColumn:
                            true,
                            border:
                            TableBorder.all(
                                color: Colors
                                    .black54,
                                width: 1),
                            columns:  const [
                              DataColumn(
                                label: Expanded(
                                    child: Center(
                                      child: Text(
                                          'Product Id'),
                                    )),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Center(
                                      child: Text(
                                          'Category'),
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
                                    child:  Center(
                                      child: Text(
                                          'Sold Quantity'),
                                    )),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Center(
                                      child: Text(
                                          'Unit'),
                                    )),
                              ),
                            ],
                            rows: List.generate(
                              allGetSaleDetailsData
                                  .length,
                                  (int index) =>
                                  DataRow(
                                    cells: <DataCell>[
                                      DataCell(
                                        Center(
                                            child: Text(
                                                '${allGetSaleDetailsData[index].productCode}')),
                                      ),
                                      DataCell(
                                        Center(
                                            child: Text(
                                                '${allGetSaleDetailsData[index].productCategoryName}')),
                                      ),
                                      DataCell(
                                        Center(
                                            child: Text(
                                                '${allGetSaleDetailsData[index].productName.toString().trim()}')),
                                      ),
                                      DataCell(
                                        Center(
                                            child: Text(
                                                '${allGetSaleDetailsData[index].saleDetailsTotalQuantity}')),
                                      ),
                                      DataCell(
                                        Center(
                                            child: Text(
                                                '${allGetSaleDetailsData[index].unitName}')),
                                      ),
                                    ],
                                  ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            children: [
                              const Text("Total Quantity   :  ",style:TextStyle(fontWeight: FontWeight.bold),),
                              Text("$soldQuantity"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ): const Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 16,color: Colors.red),),)),
            )
                : data == 'showByProductDetails'
                ? Expanded(
              child:
              SaleDetailsProvider.isSearchTypeChange
                  ? const Center(
                  child:
                  CircularProgressIndicator())
                  : allGetSaleDetailsData.isNotEmpty?
              SizedBox(
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
                      // color: Colors.red,
                      // padding:EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DataTable(
                            headingRowHeight: 20.0,
                            dataRowHeight: 20.0,
                            showCheckboxColumn:
                            true,
                            border:
                            TableBorder.all(
                                color: Colors
                                    .black54,
                                width: 1),
                            columns:  const [
                              DataColumn(
                                label: Expanded(
                                    child: Center(
                                      child: Text(
                                          'Product Id'),
                                    )),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Center(
                                      child: Text(
                                          'Category'),
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
                                    child:  Center(
                                      child: Text(
                                          'Sold Quantity'),
                                    )),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Center(
                                      child: Text(
                                          'Unit'),
                                    )),
                              ),
                            ],
                            rows: List.generate(
                              allGetSaleDetailsData
                                  .length,
                                  (int index) =>
                                  DataRow(
                                    cells: <DataCell>[
                                      DataCell(
                                        Center(
                                            child: Text(
                                                '${allGetSaleDetailsData[index].productCode}')),
                                      ),
                                      DataCell(
                                        Center(
                                            child: Text(
                                                '${allGetSaleDetailsData[index].productCategoryName}')),
                                      ),
                                      DataCell(
                                        Center(
                                            child: Text(
                                                '${allGetSaleDetailsData[index].productName.toString().trim()}')),
                                      ),
                                      DataCell(
                                        Center(
                                            child: Text(
                                                '${allGetSaleDetailsData[index].saleDetailsTotalQuantity}')),
                                      ),
                                      DataCell(
                                        Center(
                                            child: Text(
                                                '${allGetSaleDetailsData[index].unitName}')),
                                      ),
                                    ],
                                  ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            children: [
                              const Text("Total Quantity   :  ",style:TextStyle(fontWeight: FontWeight.bold),),
                              Text("$soldQuantity"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ): const Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 16,color: Colors.red),),)),
            )
                :data ==
                'showByUserWithoutDetails'
                ? Expanded(
              child:
              GetSalesProvider.isSearchTypeChange
                  ? const Center(
                  child:
                  CircularProgressIndicator())
                  : allGetSalesData.isNotEmpty?
              SizedBox(
                width: double
                    .infinity,
                height: double
                    .infinity,
                child:
                SingleChildScrollView(
                  scrollDirection:
                  Axis.vertical,
                  child:
                  SingleChildScrollView(
                    scrollDirection:
                    Axis.horizontal,
                    child:
                    Container(
                      // color: Colors.red,
                      // padding:EdgeInsets.only(bottom: 16.0),
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DataTable(
                            headingRowHeight: 20.0,
                            dataRowHeight: 20.0,
                            showCheckboxColumn:
                            true,
                            border: TableBorder.all(
                                color: Colors
                                    .black54,
                                width:
                                1),
                            columns: const [
                              DataColumn(
                                label:
                                Expanded(child: Center(child: Text('Invoice No'))),
                              ),
                              DataColumn(
                                label:
                                Expanded(child: Center(child: Text('Date'))),
                              ),
                              DataColumn(
                                label:
                                Expanded(child: Center(child: Text('Customer Name'))),
                              ),
                              DataColumn(
                                label:
                                Expanded(child: Center(child: Text('Employee Name'))),
                              ),
                              DataColumn(
                                label:
                                Expanded(child: Center(child: Text('Saved By'))),
                              ),
                              DataColumn(
                                label:
                                Expanded(child: Center(child: Text('Sub Total'))),
                              ),
                              DataColumn(
                                label:
                                Expanded(child: Center(child: Text('Vat'))),
                              ),
                              DataColumn(
                                label:
                                Expanded(child: Center(child: Text('Discount'))),
                              ),
                              DataColumn(
                                label:
                                Expanded(child: Center(child: Text('Transport Cost'))),
                              ),
                              DataColumn(
                                label:
                                Expanded(child: Center(child: Text('Total'))),
                              ),
                              DataColumn(
                                label:
                                Expanded(child: Center(child: Text('Paid'))),
                              ),
                              DataColumn(
                                label:
                                Expanded(child: Center(child: Text('Due'))),
                              ),
                              // DataColumn(
                              //   label:
                              //   Expanded(child: Center(child: Text('Invoice'))),
                              // ),
                            ],
                            rows: List
                                .generate(
                              allGetSalesData
                                  .length,
                                  (int index) =>
                                  DataRow(
                                    cells: <DataCell>[
                                      DataCell(
                                        Center(child: Text('${allGetSalesData[index].saleMasterInvoiceNo}')),
                                      ),
                                      DataCell(
                                        Center(child: Text('${allGetSalesData[index].saleMasterSaleDate}')),
                                      ),
                                      DataCell(
                                        Center(child: Text('${allGetSalesData[index].customerName}')),
                                      ),
                                      DataCell(
                                        Center(child: Text('${allGetSalesData[index].employeeName}')),
                                      ),
                                      DataCell(
                                        Center(child: Text('${allGetSalesData[index].addBy}')),
                                      ),
                                      DataCell(
                                        Center(child: Text('${allGetSalesData[index].saleMasterSubTotalAmount}')),
                                      ),
                                      DataCell(
                                        Center(child: Text('${allGetSalesData[index].saleMasterTaxAmount}')),
                                      ),
                                      DataCell(
                                        Center(child: Text('${allGetSalesData[index].saleMasterTotalDiscountAmount}')),
                                      ),
                                      DataCell(
                                        Center(child: Text('${allGetSalesData[index].saleMasterFreight}')),
                                      ),
                                      DataCell(
                                        Center(child: Text('${allGetSalesData[index].saleMasterTotalSaleAmount}')),
                                      ),
                                      DataCell(
                                        Center(child: Text('${allGetSalesData[index].saleMasterPaidAmount}')),
                                      ),
                                      DataCell(
                                        Center(child: Text('${allGetSalesData[index].saleMasterDueAmount}')),
                                      ),
                                      // DataCell(
                                      //   Center(
                                      //     child:GestureDetector(
                                      //       child: const Icon(Icons.collections_bookmark,size: 18,),
                                      //       onTap: () {
                                      //         // Navigator.push(context, MaterialPageRoute(builder: (context) => InvoicePage(
                                      //         //   salesId: allGetSalesData[index].saleMasterSlNo!,
                                      //         // ),
                                      //         // ));
                                      //       },
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            children: [
                              const Text("Total Sub Total       :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                              Text("$subTotal"),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              const Text("Total Vat                  :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                              Text("$vatTotal"),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              const Text("Total Discount        :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                              Text("$discountTotal"),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              const Text("Total Trans.Cost    :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                              Text("$transferCost"),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              const Text("Total Amount         :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                              Text("$totalAmount"),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              const Text("Total paid               :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                              Text("$paidTotal"),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              const Text("Total Due                :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                              Text("$dueTotal"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ): const Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 16,color: Colors.red),),)),
            )
                : data ==
                'showByUserWithDetails'
                ? Expanded(
              child:
              SalesRecordProvider.isSearchTypeChange
                  ? const Center(
                  child:
                  CircularProgressIndicator())
                  : allGetSalesRecordData.isNotEmpty?
              SizedBox(
                width: double
                    .infinity,
                height: double
                    .infinity,
                child:
                SingleChildScrollView(
                  scrollDirection:
                  Axis.vertical,
                  child:
                  SingleChildScrollView(
                    scrollDirection:
                    Axis.horizontal,
                    child:
                    Container(
                      // color: Colors.red,
                      // padding:EdgeInsets.only(bottom: 16.0),
                      child:
                      DataTable(
                        headingRowHeight: 25.0,
                        dataRowMaxHeight: double.infinity,
                        showCheckboxColumn:
                        true,
                        border: TableBorder.all(
                            color: Colors.black54,
                            width: 1),
                        columns: const [
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Invoice No'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Date'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Customer Name'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Employee Name'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Saved By'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Product Name'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Price'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Quantity'))),
                          ),

                          DataColumn(
                            label: Expanded(child: Center(child: Text('Total'))),
                          ),
                          // DataColumn(
                          //   label: Expanded(child: Center(child: Text('Invoice'))),
                          // ),
                        ],
                        rows:
                        List.generate(
                          allGetSalesRecordData.length,
                              (int index) =>
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Center(child: Text('${allGetSalesRecordData[index].saleMasterInvoiceNo}')),
                                  ),
                                  DataCell(
                                    Center(child: Text('${allGetSalesRecordData[index].saleMasterSaleDate}')),
                                  ),
                                  DataCell(
                                    Center(child: Text('${allGetSalesRecordData[index].customerName}')),
                                  ),
                                  DataCell(
                                    Center(child: Text('${allGetSalesRecordData[index].employeeName}')),
                                  ),
                                  DataCell(
                                    Center(child: Text('${allGetSalesRecordData[index].addBy}')),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Column(
                                          children:
                                          List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
                                            return Container(
                                              child: Center(
                                                  child: Text(
                                                      allGetSalesRecordData[index].saleDetails[j].productName)
                                              ),
                                            );
                                          })
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Column(
                                          children:
                                          List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
                                            return Container(
                                              child: Center(
                                                  child: Text(
                                                      double.parse(allGetSalesRecordData[index].saleDetails[j].saleDetailsRate).toStringAsFixed(2))

                                              ),
                                            );
                                          })
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Column(
                                          children:
                                          List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
                                            return Container(
                                              child: Center(
                                                  child: Text(
                                                      double.parse(allGetSalesRecordData[index].saleDetails[j].saleDetailsTotalQuantity).toStringAsFixed(2))

                                              ),
                                            );
                                          })
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Column(
                                          children:
                                          List.generate( allGetSalesRecordData[index].saleDetails.length, (j) {
                                            return Container(
                                              child: Center(
                                                  child: Text(
                                                      double.parse(allGetSalesRecordData[index].saleDetails[j].saleDetailsTotalAmount).toStringAsFixed(2))

                                              ),
                                            );
                                          })
                                      ),
                                    ),
                                  ),
                                  // DataCell(
                                  //   Center(
                                  //     child:GestureDetector(
                                  //       child: const Icon(Icons.collections_bookmark,size: 18,),
                                  //       onTap: () {
                                  //         // Navigator.push(context, MaterialPageRoute(builder: (context) => InvoicePage(
                                  //         //   salesId: allGetSalesRecordData[index].saleMasterSlNo!,
                                  //         // ),
                                  //         // ));
                                  //       },
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ): const Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 16,color: Colors.red),),)),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
