import 'dart:convert';

//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kbtradlink/provider/branch_provider.dart';
import 'package:kbtradlink/provider/category_provider.dart';
import 'package:kbtradlink/provider/customer_provider.dart';
import 'package:kbtradlink/provider/employee_provider.dart';
import 'package:kbtradlink/provider/category_wise_product_provider.dart';
import 'package:kbtradlink/utils/const_page.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/screen/sales_module/model/branch_model.dart';
import 'package:kbtradlink/screen/sales_module/model/category_model.dart';
import 'package:kbtradlink/screen/administation_module/model/customer_model.dart';
import 'package:kbtradlink/screen/sales_module/model/employee_model.dart';
import 'package:kbtradlink/screen/administation_module/model/product_model.dart';
import 'package:kbtradlink/model/sales_cart_model_class.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesEntryPage extends StatefulWidget {
  const SalesEntryPage({super.key});
  @override
  State<SalesEntryPage> createState() => _SalesEntryPageState();
}

class _SalesEntryPageState extends State<SalesEntryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _paidController = TextEditingController();
  final TextEditingController _discountPercentController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _salesRateController = TextEditingController();
  final TextEditingController _DiscountController = TextEditingController();
  final TextEditingController _VatController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _transportController = TextEditingController();
  final customerController = TextEditingController();
  final empluyeeNameController = TextEditingController();
  final categoryController = TextEditingController();
  final branchController = TextEditingController();
  final productController = TextEditingController();

  var customerSlNo;

  String? Salling_Rate = "0.0";
  String? customerMobile;
  String? customerAddress;
  String? categoryId;
  String? branchId;
  String? _selectedCustomer;
  String? _selectedProduct;
  String? employeeSlNo;
  String? previousDue;
  String level = "retail";
  String availableStock = "0";
  double subtotal = 0;
  double CartTotal = 0;
  double TotalVat = 0;
  double totalDue = 0;
  double totalDueTc = 0;
  double Totaltc = 0;
  double DiccountTotal = 0;
  double TransportTotal = 0;
  double Diccountper = 0;
  double AfteraddVatTotal = 0;
  List<SalesApiModelClass> salesCartList = [];

  String? cproductId;
  String? ccategoryName;
  String? cname;
  String? csalesRate;
  String? cvat;
  String? cquantity;
  String? ctotal;
  String? cpurchaseRate;

  double h1TextSize = 16.0;
  double h2TextSize = 12.0;
  double Total = 0.0;

  bool isVisible = false;
  bool isEnabled = false;

  late final Box box;

  bool isSellBtnClk = false;
  // bool isCustomerTypeChange = false;

  @override
  void initState() {
    super.initState();
    Provider.of<AllEmployeeProvider>(context, listen: false).fetchEmployee(context);
    Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,customerType: level);
    Provider.of<BranchProvider>(context, listen: false).getBranchData();
    Provider.of<CategoryProvider>(context, listen: false).getCategoryData();
    Provider.of<CategoryWiseProductProvider>(context, listen: false).getCategoryWiseProduct(isService: "yes",categoryId: '',branchId:'');
    _quantityController.text = "1";
    _discountPercentController.text = "0";

    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
  }

  Response? response;
  void totalStack(String? branchId, String? catId, String? productId) async {
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    print('afsdjhf $productId $catId $branchId');
    response = await Dio().post(
        "${baseUrl}api/v1/getProductStock",
        data: {
          "branchId": "$branchId",
          "catId": "$catId",
          "productId": "$productId",
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }));
    print("response========> ${response!.data}");

    setState(() {
      availableStock = "${jsonDecode(response!.data)}";
    });
  }

  Response? result;
  void dueReport(String? customerId) async {
    print("Call Api $customerId");
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    result = await Dio().post("${baseUrl}api/v1/getCustomerDue",
        data: {"customerId": "$customerId"},
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }));

    var data = jsonDecode(result?.data);

    if(data!=null){
      print("responses result========> ${data[0]['dueAmount']}");
      setState(() {
        Previousdue = "${data[0]['dueAmount']}";
        _nameController.text = "${data[0]['Customer_Name']}";
      });
    }
  }

  var Previousdue;

  @override
  Widget build(BuildContext context) {

    final allEmployee = Provider.of<AllEmployeeProvider>(context).allEmployeeList;
    final allBranch = Provider.of<BranchProvider>(context).branchList;
    final allCustomer = Provider.of<CustomerListProvider>(context).customerList;
    final allCategory = Provider.of<CategoryProvider>(context).categoryList;
    final productList = Provider.of<CategoryWiseProductProvider>(context).categoryWiseProductList;

    return Scaffold(
        appBar: const CustomAppBar(title: "Sales Entry"),
        body: ModalProgressHUD(
          blur: 2,
          inAsyncCall: CustomerListProvider.isCustomerTypeChange||CategoryWiseProductProvider.isCustomerTypeChange,
          progressIndicator: Utils.showSpinKitLoad(),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: Card(
                      margin: EdgeInsets.only(bottom: 10),
                      color: Color.fromARGB(255, 7, 125, 180),
                      child: Center(
                        child: Text(
                          'Sales Information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
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
                    padding: const EdgeInsets.only(left: 4.0,right: 4.0),
                    decoration: BoxDecoration(
                      color: Color(0xffD2D2FF),
                      //color: Colors.yellow.shade50,
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
                                      "Date to      :",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 126, 125, 125)),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: GestureDetector(
                                      onTap: () {
                                        _selectedDate();
                                      },
                                      child: Container(
                                        margin:
                                        const EdgeInsets.only(top: 5,),
                                        height: 28,
                                        width: double.infinity,
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
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              firstPickedDate == null
                                                  ? Utils.formatFrontEndDate(DateTime.now())
                                                  : firstPickedDate!,
                                              style: const TextStyle(fontSize: 13.0),
                                            ),
                                            const Icon(Icons.calendar_month,size: 18,)
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

                        // Invoice no drop down
                        Row(
                          children: [
                            const Expanded(
                              flex:1,
                              child:Text(
                                "Sales By    :",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 126, 125, 125)),
                              ),),
                            const SizedBox(width: 5,),
                            Expanded(
                              flex:3,
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
                                child: TypeAheadFormField(
                                  textFieldConfiguration:
                                  TextFieldConfiguration(
                                    onChanged: (value){
                                      if (value == '') {
                                        employeeSlNo = '';
                                      }
                                    },
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                    controller: empluyeeNameController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Select Employee',
                                      hintStyle: const TextStyle(fontSize: 13.0),
                                      suffix: employeeSlNo == '' ? null : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            empluyeeNameController.text = '';
                                          });
                                        },
                                        child: const Icon(Icons.close,size: 14,),
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
                                          suggestion.employeeName,
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
                                    empluyeeNameController.text = suggestion.employeeName;
                                    setState(() {
                                      employeeSlNo = suggestion.employeeSlNo.toString();
                                    });
                                  },
                                  onSaved: (value) {},
                                ),
                              ),
                            ),
                          ],
                        ), // Sales by drop down
                      ],
                    ),
                  ),
                  // SizedBox(height: 10),
                  ////
                  ///
                  ///my practice
                  ///
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0,bottom: 4.0),
                    decoration: BoxDecoration(
                      color: const Color(0xffD2D2FF),
                      borderRadius: BorderRadius.circular(15.0),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 1.005,
                                  child: Radio(
                                      fillColor: MaterialStateColor.resolveWith(
                                            (states) =>
                                        const Color.fromARGB(255, 5, 114, 165),
                                      ),
                                      value: "retail",
                                      groupValue: level,
                                      onChanged: (value) {
                                        setState(() {
                                          level = value.toString();
                                          print(level);
                                          CustomerListProvider().on();
                                          customerController.text = '';
                                          Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,customerType: level);
                                        });
                                      }),
                                ),
                                const Text("Retail"),
                              ],
                            ),
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 1.005,
                                  child: Radio(
                                      fillColor: MaterialStateColor.resolveWith((states) =>
                                        const Color.fromARGB(255, 5, 114, 165),
                                      ),
                                      value: "wholesale",
                                      groupValue: level,
                                      onChanged: (value) {
                                        setState(() {
                                          level = value.toString();
                                          print(level);
                                          CustomerListProvider().on();
                                          customerController.text = '';
                                          Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,customerType: level);
                                        });
                                      }),
                                ),
                                const Text("Wholesale"),
                              ],
                            ),
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 1.005,
                                  child: Radio(
                                      fillColor: MaterialStateColor.resolveWith(
                                            (states) =>
                                        const Color.fromARGB(255, 5, 114, 165),
                                      ),
                                      value: "unpaid",
                                      groupValue: level,
                                      onChanged: (value) {
                                        setState(() {
                                          level = value.toString();
                                          print(level);
                                          CustomerListProvider().on();
                                          customerController.text = '';
                                          Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,customerType: level);
                                        });
                                      }),
                                ),
                                const Text("Unpaid"),
                              ],
                            ),
                          ],
                        ), // radio button
                        Row(
                          children: [
                            const SizedBox(width: 5),
                            const Text(
                              "Customer :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 5,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                height: 30,
                                padding: const EdgeInsets.only(left: 5, right: 3,top: 2),
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
                                          _selectedCustomer = '';
                                        }
                                      },
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                      controller: customerController,
                                      decoration: InputDecoration(
                                        hintText: 'Select Customer',
                                        isDense: true,
                                        hintStyle: const TextStyle(fontSize: 12.0),
                                        suffix: _selectedCustomer == '' ? null : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              customerController.text = '';
                                              _mobileNumberController.text = '';
                                              _addressController.text = '';
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 3),
                                            child: Icon(Icons.close,size: 14,),
                                          ),
                                        ),
                                      )
                                  ),
                                  suggestionsCallback: (pattern) {
                                    return allCustomer
                                        .where((element) => element
                                        .displayName!
                                        .toLowerCase()
                                        .contains(pattern
                                        .toString()
                                        .toLowerCase()))
                                        .take(allCustomer.length)
                                        .toList();
                                    // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                        child: Text(
                                          allCustomer[0].displayName=="General Customer" ?
                                          "${suggestion.displayName}":
                                          "${suggestion.customerCode} - ${suggestion.customerName} - - ${suggestion.customerAddress}",

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
                                      (CustomerModel suggestion) {
                                    customerController.text =
                                    suggestion.displayName!;
                                    setState(() {
                                      _selectedCustomer = suggestion.customerSlNo.toString();
                                      customerSlNo = suggestion.customerSlNo.toString();

                                      print("customer selected ======> $_selectedCustomer");

                                      if (_selectedCustomer == 'null') {

                                        print("No has not $_selectedCustomer");

                                        isVisible = true;
                                        isEnabled = true;
                                        _nameController.text = '';
                                        _mobileNumberController.text = '';
                                        _addressController.text = '';
                                      } else {
                                        print("Yes has $_selectedCustomer");

                                        isEnabled = false;
                                        isVisible = false;
                                        final results = [

                                          allCustomer.where((m) => m.customerSlNo
                                              .toString()
                                              .contains(
                                              '${suggestion.customerSlNo}')) // or Testing 123
                                              .toList(),
                                        ];
                                        results.forEach((element) {
                                          element.add(element.first);
                                          print("dfhsghdfkhgkh");
                                          print(
                                              "productSlNo===> ${element[0].displayName}");
                                          print(
                                              "productCategoryName===> ${element[0].customerName}");
                                          customerMobile =
                                          "${element[0].customerMobile}";
                                          _mobileNumberController.text =
                                          "${element[0].customerMobile}";
                                          print(
                                              "customerMobile===> ${element[0].customerMobile}");
                                          customerAddress =
                                          "${element[0].customerAddress}";
                                          _addressController.text =
                                          "${element[0].customerAddress}";
                                          print(
                                              "customerAddress===> ${element[0].customerAddress}");
                                          dueReport(customerSlNo);
                                          // previousDue = "${element[0].previousDue}";
                                          // _previousDueController.text =
                                          // "${element[0].previousDue}";
                                          print(
                                              "previousDue===> ${element[0].previousDue}");
                                        });
                                      }
                                      //  print(_selectedCustomer);
                                      print('isVisible $isVisible');

                                    });
                                  },
                                  onSaved: (value) {},
                                ),
                              ),
                            ),
                          ],
                        ), // drop down
                        Visibility(
                          visible: isVisible,
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 28),
                                child: Text(
                                  "Name :",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 126, 125, 125)),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: 28.0,
                                  margin: const EdgeInsets.only(bottom: 4),
                                  child: TextFormField(
                                    controller: _nameController,
                                    validator: (value) {
                                      if(value != null || value != ''){
                                        _nameController.text = value.toString();
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.text,
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
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 22),
                              child: Text(
                                "Mobile :",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 126, 125, 125)),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 28.0,
                                margin: const EdgeInsets.only(bottom: 4),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.grey[200],),
                                child: TextFormField(
                                  style: const TextStyle(fontSize: 13),
                                  enabled: isEnabled,
                                  controller: _mobileNumberController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if(value != null || value != ''){
                                      _mobileNumberController.text = value.toString();
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(bottom:18,left: 5),
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
                        // mobile

                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Text(
                                "Address :",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 126, 125, 125)),
                              ),
                            ),

                            const SizedBox(width: 16,),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 30,
                                //margin: const EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.grey[200],),
                                child: TextFormField(
                                  style: const TextStyle(fontSize: 13),
                                  maxLines: 2,
                                  controller: _addressController,
                                  validator: (value) {
                                    if(value != null || value != ''){
                                      _addressController.text = value.toString();
                                    }
                                    return null;
                                  },
                                  enabled: isEnabled,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(bottom:5,left: 5),
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
                  // SizedBox(height: 10),
                  Container(
                    height: 220,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      top: 10.0,
                    ),
                    padding:
                    const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Warehouse :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                            const SizedBox(width: 15,),
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
                                          branchId = '';
                                        }
                                      },
                                      style: const TextStyle(
                                        fontSize: 13, color: Color.fromARGB(255, 126, 125, 125),
                                      ),
                                      controller: branchController,
                                      decoration: InputDecoration(
                                        hintText: 'Select Branch',
                                        isDense: true,
                                        hintStyle: const TextStyle(fontSize: 13),
                                        suffix: branchId == '' ? null : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              branchController.text = '';
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 3),
                                            child: Icon(Icons.close,size: 14,),
                                          ),
                                        ),
                                      )
                                  ),
                                  suggestionsCallback: (pattern) {
                                    return allBranch
                                        .where((element) => element.brunchName
                                        .toString()
                                        .toLowerCase()
                                        .contains(pattern
                                        .toString()
                                        .toLowerCase()))
                                        .take(allBranch.length)
                                        .toList();
                                    // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return SizedBox(child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      child: Text("${suggestion.brunchName}",
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                    );
                                  },
                                  transitionBuilder:
                                      (context, suggestionsBox, controller) {
                                    return suggestionsBox;
                                  },
                                  onSuggestionSelected:
                                      (BranchModel suggestion) {
                                    branchController.text = "${suggestion.brunchName}";
                                    setState(() {
                                      // _selectedCategory = suggestion.brunchId.toString();
                                      branchId = suggestion.brunchId;
                                      // Provider.of<AllProductProvider>(context,
                                      //     listen: false)
                                      //     .getAllProduct(isService: "false",categoryId: branchId);
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
                            const SizedBox(width: 10,),
                            const Text(
                              "Category :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                            const SizedBox(width: 15,),
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
                                          categoryId = '';
                                        }
                                      },
                                      style: const TextStyle(
                                        fontSize: 13, color: Color.fromARGB(255, 126, 125, 125),
                                      ),
                                      controller: categoryController,
                                      decoration: InputDecoration(
                                        hintText: 'Select Category',
                                        isDense: true,
                                        hintStyle: const TextStyle(fontSize: 13),
                                        suffix: categoryId == '' ? null : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              categoryController.text = '';
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 3),
                                            child: Icon(Icons.close,size: 14,),
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
                                  transitionBuilder:
                                      (context, suggestionsBox, controller) {
                                    return suggestionsBox;
                                  },
                                  onSuggestionSelected:
                                      (CategoryModel suggestion) {
                                    categoryController.text = "${suggestion.productCategoryName}";
                                    setState(() {
                                      categoryId = suggestion.productCategorySlNo;
                                      CategoryWiseProductProvider().on();
                                      Provider.of<CategoryWiseProductProvider>(context,
                                          listen: false)
                                          .getCategoryWiseProduct(isService: "yes",categoryId: categoryId, branchId: branchId);
                                    });
                                  },
                                  onSaved: (value) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                        // category
                        Row(
                          children: [
                            const SizedBox(width: 17,),
                            const Text(
                              "Product :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                            const SizedBox(width: 15,),
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
                                            isDense: true,
                                            hintText: 'Select Product',
                                            hintStyle: const TextStyle(fontSize: 13),
                                            suffix: _selectedProduct == '' ? null : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  productController.text = '';
                                                });
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 3),
                                                child: Icon(Icons.close,size: 14,),
                                              ),
                                            ),
                                          )
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return productList
                                            .where((element) => element.displayText
                                            .toString()
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
                                      transitionBuilder:
                                          (context, suggestionsBox, controller) {
                                        return suggestionsBox;
                                      },
                                      onSuggestionSelected:
                                          (ProductModel suggestion) {
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
                                            element.add(element.first);
                                            cproductId = element[0].productSlNo;
                                            print(
                                                "productSlNo===> ${element[0].productSlNo}");
                                            ccategoryName =
                                            element[0].productCategoryName;
                                            print(
                                                "productCategoryName===> ${element[0].productCategoryName}");
                                            cname = element[0].productName;
                                            print(
                                                "productName===> ${element[0].productName}");
                                            print(
                                                "productSellingPrice===> ${element[0].productSellingPrice}");
                                            cvat = element[0].vat;
                                            print("vat===> ${element[0].vat}");
                                            print(
                                                "_quantityController ===> ${_quantityController.text}");
                                            print(
                                                "_quantityController ===> ${_quantityController.text}");
                                            cpurchaseRate =
                                            element[0].productPurchaseRate;
                                            print(
                                                "productPurchaseRate===> ${element[0].productPurchaseRate}");
                                            _VatController.text = element[0].vat;
                                            _salesRateController.text =
                                            element[0].productSellingPrice;
                                            setState(() {
                                              Total = (double.parse(
                                                  _quantityController.text) *
                                                  double.parse(
                                                      _salesRateController.text));
                                            });
                                            totalStack(branchId, categoryId, cproductId);
                                          });
                                        });
                                      },
                                      onSaved: (value) {},
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ), // product

                        Row(
                          children: [
                            const Text(
                              "Sales Rate :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 28.0,
                                child: TextField(
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 126, 125, 125),
                                      fontSize: 14.0),
                                  controller: _salesRateController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 6),
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
                              "Qty",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 28.0,
                                margin: const EdgeInsets.only(left: 5, right: 0),
                                child: TextField(
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 126, 125, 125),
                                      fontSize: 14.0),
                                  controller: _quantityController,
                                  onChanged: (value) {
                                    setState(() {
                                      Total = (double.parse(
                                          _quantityController.text) *
                                          double.parse(_salesRateController.text));
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 6),
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
                        ), // quantity
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 16,
                            ),
                            const Text(
                              "Amount :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              flex: 7,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 0, right: 5),
                                height: 28,
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 5, bottom: 0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 7, 125, 180),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  "$Total",
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 126, 125, 125),
                                      fontSize: 14.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "Available Stock,",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                child: Text(
                                  availableStock,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 126, 125, 125)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:const Color.fromARGB(255, 7, 125, 180),
                               // const Color.fromARGB(255, 6, 118, 170),
                              ),
                              onPressed: () {
                                if (categoryController.text != ''||categoryController.text.isNotEmpty) {
                                  if (productController.text != '' ||
                                      productController.text.isNotEmpty) {
                                    // if (_quantityController.text
                                    //     .toString()
                                    //     .isNotEmpty
                                    //     || _quantityController.text != '') {
                                    if (availableStock != '0') {
                                      setState(() {
                                        salesCartList.add(SalesApiModelClass(
                                            productId: "$cproductId",
                                            categoryName: "$ccategoryName",
                                            name: "$cname",
                                            salesRate: _salesRateController.text,
                                            vat: _VatController.text,
                                            quantity: _quantityController.text,
                                            total: "$Total",
                                            purchaseRate: "$cpurchaseRate"));

                                        CartTotal += Total;
                                        AfteraddVatTotal = CartTotal;
                                        DiccountTotal = AfteraddVatTotal;
                                        TransportTotal = DiccountTotal;
                                        print(
                                            "CartTotal ----------------- $CartTotal");
                                        categoryController.text = '';
                                        productController.text = '';
                                        _salesRateController.text = '';
                                        // _quantityController.text = '0';
                                        setState(() {
                                          Total = 0;
                                        });
                                      });
                                      // totalStack(cproductId);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text(
                                            "Stock Unavailable", style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.red),)));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Center(
                                          child: Text(
                                            "Please Select Product",
                                            style: TextStyle(fontSize: 16,
                                                color: Colors.red),),
                                        )));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Center(
                                        child: Text(
                                          "Please Select Category", style: TextStyle(
                                            fontSize: 16, color: Colors.red),),
                                      )));
                                }
                              },
                              child: const Text("Add to cart",style: TextStyle(color: Colors.white),)),
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
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              flex: 4,
                              child: Text(
                                "Category",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: h2TextSize,
                                ),
                              )),
                          Expanded(
                              flex: 6,
                              child: Text(
                                "Product Name",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: h2TextSize,
                                ),
                              )),
                          Expanded(
                              flex: 1,
                              child: Text(
                                "Qty",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: h2TextSize,
                                ),
                              )),
                          Expanded(
                              flex: 3,
                              child: Text(
                                "Rate",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: h2TextSize,
                                ),
                              )),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Amount",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: h2TextSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 2),
                      ...List.generate(salesCartList.length, (index){
                        return Column(
                          children: [
                            Container(
                             // color: Colors.blue[50],
                              color: Color(0xffD2D2FF),
                              height: 25,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
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
                                          flex: 4,
                                          child: Center(
                                            child: Text(
                                              "${salesCartList[index].categoryName}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                                fontSize: h2TextSize,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: Center(
                                            child: Text(
                                              "${salesCartList[index].name}",
                                              style: TextStyle(
                                                overflow:
                                                TextOverflow.ellipsis,
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
                                              "${salesCartList[index].quantity}",
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
                                              "${salesCartList[index].salesRate}",
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
                                              "${salesCartList[index].total}",
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
                      SizedBox(height: salesCartList.isNotEmpty ? 10 : 30),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: Card(
                      margin: EdgeInsets.only(bottom: 8),
                      color: const Color.fromARGB(255, 7, 125, 180),
                      child: Center(
                        child: Text(
                          'Amount Details',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  ///test
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.only(left: 4.0,right: 4.0),
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
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // const SizedBox(width: 28),
                            const Text(
                              "Sub Total :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                                flex: 3,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 4,),
                                  height: 30,
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 7, 125, 180),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    "$CartTotal",
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 126, 125, 125)),
                                  ),
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // const SizedBox(width: 65),
                            const Text(
                              "Vat :          ",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 28.0,
                                margin: const EdgeInsets.only(left: 5, right: 5),
                                child: TextField(
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 126, 125, 125)),
                                  controller: _VatController,
                                  onChanged: (value) {
                                    _transportController.text = '';
                                    _paidController.text = '';
                                    setState(() {
                                      TotalVat = CartTotal *
                                          (double.parse(_VatController.text) / 100);
                                      AfteraddVatTotal = CartTotal - TotalVat;
                                      DiccountTotal = AfteraddVatTotal;
                                      TransportTotal = DiccountTotal;

                                      Totaltc = CartTotal + TotalVat-double.parse(_discountPercentController.text);
                                      totalDue= Totaltc;
                                    });
                                  },
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: "0",
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 3),

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
                                  margin: const EdgeInsets.only(
                                      top: 5, bottom: 5),
                                  height: 30,
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 7, 125, 180),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    "$TotalVat",
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 126, 125, 125)),
                                  ),
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // const SizedBox(width: 30),
                            const Text(
                              "Discount :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: 28.0,
                                margin: const EdgeInsets.only(left: 5, right: 5),
                                child: TextField(
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 126, 125, 125)),
                                  controller: _DiscountController,
                                  onChanged: (value) {
                                    _transportController.text = '';
                                    _paidController.text = '';
                                    setState(() {
                                      Diccountper =  (double.parse(_DiscountController.text)/ 100) * CartTotal;
                                      print("Dis $Diccountper");
                                      _discountPercentController.text = "$Diccountper";
                                      DiccountTotal = AfteraddVatTotal - Diccountper;
                                      TransportTotal = DiccountTotal;

                                      Totaltc = CartTotal + TotalVat - Diccountper;
                                      totalDue = Totaltc;

                                    });
                                    // setState(() {
                                    //   Diccountper = AfteraddVatTotal *
                                    //       (double.parse(_DiscountController.text) /
                                    //           100);
                                    //   _discountPercentController.text =
                                    //       "${Diccountper}";
                                    //   DiccountTotal =
                                    //       AfteraddVatTotal - Diccountper;
                                    //   TransportTotal = DiccountTotal;
                                    // });
                                    //  setState(() {
                                    //   Diccountper = AfteraddVatTotal *
                                    //       (double.parse(_DiscountController.text) /
                                    //           100);
                                    //   // _discountPercentController.text =
                                    //   //     "${Diccountper}";
                                    //   DiccountTotal =
                                    //       AfteraddVatTotal - Diccountper;
                                    //   TransportTotal = DiccountTotal;
                                    //   Totaltc = TransportTotal +
                                    //       double.parse(_transportController.text);
                                    // });
                                  },
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(left: 6),
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
                                height: 28.0,
                                margin: const EdgeInsets.only(right: 2),
                                child: TextField(
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 126, 125, 125)),
                                  controller: _discountPercentController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value){
                                    _transportController.text = '';
                                    _paidController.text = '';
                                    var res = double.parse(_discountPercentController.text)*100;
                                    var rees = double.parse("${res}") / double.parse("${CartTotal}");
                                    setState(() {
                                      _DiscountController.text = double.parse("${rees}").toStringAsFixed(2);

                                      DiccountTotal = AfteraddVatTotal - double.parse(_discountPercentController.text);
                                      TransportTotal = DiccountTotal;

                                      Totaltc = CartTotal + TotalVat - double.parse(_discountPercentController.text);
                                      totalDue = Totaltc;

                                    });

                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(left: 6),
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
                            // const SizedBox(width: 24),
                            const Text(
                              "Transport :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 28.0,
                                margin: const EdgeInsets.only(top: 5, bottom: 5),
                                child: TextField(
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 126, 125, 125)),
                                  controller: _transportController,
                                  onChanged: (value) {
                                    setState(() {
                                      Totaltc = CartTotal + TotalVat + double.parse(_transportController.text);
                                      Totaltc = Totaltc - Diccountper;
                                      totalDue= Totaltc;
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding:
                                    const EdgeInsets.only(top: 5, left: 5),
                                    hintText: "0",
                                    // hintText: "$DiccountTotal",
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
                            // const SizedBox(width: 52),
                            const Text(
                              "Total :        ",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                                flex: 3,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 0, bottom: 5),
                                  height: 30,
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 7, 125, 180),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    "${Totaltc == 0.0 ? CartTotal : Totaltc.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 126, 125, 125)),
                                    //"$TransportTotal",
                                  ),
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            // const SizedBox(width: 55),
                            const Text(
                              "Paid :         ",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 28.0,
                                margin: const EdgeInsets.only(bottom: 5),
                                child: TextField(
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 126, 125, 125)),
                                  controller: _paidController,
                                  onChanged: (value) {
                                    if(_VatController.text == '0'){

                                      print("Empthy cart ${Totaltc == 0.0 ? CartTotal : Totaltc}");
                                      print("Empthy kajldfjas ${CartTotal}");
                                      setState(() {
                                        totalDue = CartTotal - double.parse(_paidController.text);
                                      });
                                      print("Empthy kajldfjas ${totalDue}");
                                    }
                                    else{
                                      setState(() {
                                        totalDue = Totaltc - double.parse(_paidController.text);
                                      });
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 6),
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
                            const Text(
                              "Due :             ",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                            Expanded(
                                flex: 3,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 0, bottom: 0,),
                                  height: 30,
                                  padding: const EdgeInsets.only(
                                    left: 5, right: 5, top: 5,),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 7, 125, 180),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    "${totalDue == 0.0 ? CartTotal : totalDue.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 126, 125, 125)),
                                    //"$TransportTotal",
                                  ),
                                )),
                            const SizedBox(width: 10,),
                            const Expanded(
                              flex: 1,
                              child: Text(
                                "P.Due ",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 126, 125, 125)),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                //margin: const EdgeInsets.only(bottom: 2),
                                height: 30,
                                padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 7, 125, 180),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: SizedBox(
                                  child: Text(
                                    "$Previousdue" == 'null' ? '0' : "${Previousdue}",
                                    style: const TextStyle(color: Colors.red),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () async {

                                // final connectivityResult = await (Connectivity().checkConnectivity());

                                // if (connectivityResult == ConnectivityResult.mobile
                                //     || connectivityResult == ConnectivityResult.wifi) {
                                  setState(() {
                                    isSellBtnClk = true;
                                  });
                                  if (CartTotal == 0) {
                                    setState(() {
                                      isSellBtnClk = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Please Add to Cart")));
                                  } else {
                                    print(
                                        "Name controller ${_nameController.text}");
                                    print("Name controller $_selectedCustomer");
                                    addSales();
                                  }
                                // }
                                // else{
                                // Utils.errorSnackBar(context, "Please connect with internet");
                                // }
                              },
                              child: Center(
                                  child: isSellBtnClk ? const SizedBox(height: 20,width:20,child: CircularProgressIndicator(color: Colors.white,)) : const Text(
                                    "Sale",
                                    style: TextStyle(
                                        letterSpacing: 1.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:const Color.fromARGB(255, 7, 125, 180),
                                 // const Color.fromARGB(255, 6, 118, 170),
                                ),
                                onPressed: () {},
                                child: const Text("New Sale",style: TextStyle(color: Colors.white),)),
                          ],
                        )

                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
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
  addSales() async {
    String link = "${baseUrl}api/v1/addSales";
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      var studentsmap = salesCartList.map((e) {
        return {
          "productId": e.productId,
          "categoryName": e.categoryName,
          "name": e.name,
          "unit": "?????",
          "salesRate": e.salesRate,
          "vat": e.vat,
          "quantity": e.quantity,
          "total": e.total,
          "purchaseRate": e.purchaseRate,
          "branchId": "$branchId",
          "branchName": "${branchController.text}"
        };
      }).toList();
      print(studentsmap);
      Response response = await Dio().post(
        link,
        data: {
          "sales": {
            "salesId": 0,
            "invoiceNo": "2023-08-170007569",
            "salesBy": GetStorage().read("name"),
            "salesType": level,
            "salesFrom": "1",
            "salesDate": "$backEndFirstDate",
            "customerId": "$_selectedCustomer",
            "employeeId": "$employeeSlNo",
            "subTotal": "$CartTotal",
            "discount":_discountPercentController.text,
            "vat": "$TotalVat",
            "transportCost":_transportController.text,
            "total": "${Totaltc == 0.0 ? CartTotal : Totaltc}",
            "paid": _paidController.text.trim(),
            "previousDue": "$previousDue",
            "due": "${totalDue == 0.0 ? CartTotal : totalDue}",
            "isService": "false",
            "note": "Note Here",
            "send_sms": true
          },
          "customer":{
            "Customer_Address": _addressController.text.trim(),
            "Customer_Code": '',
            "Customer_Mobile": _mobileNumberController.text.trim(),
            "Customer_Name": _nameController.text.trim(),
            "Customer_SlNo": '',
            "Customer_Type": "G",
            "display_name": 'General Customer'
          },
          "cart": studentsmap
        },
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }),
      );
      print(response.data);
      var item = jsonDecode(response.data);

      if(item["success"] == true){

        setState(() {
          isSellBtnClk = false;
        });
        _nameController.text = "";
        _paidController.text = "";
        _discountPercentController.text = "";
        _mobileNumberController.text = "";
        _addressController.text = "";
        _salesRateController.text = "";
        _DiscountController.text = "";
        _VatController.text = "";
        _quantityController.text = "";
        _transportController.text = "";
        DiccountTotal = 0;
        previousDue = "0";
        TotalVat = 0;
        CartTotal = 0;
        salesCartList.clear();
        DiccountTotal = 0;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),backgroundColor: Colors.black,
            content: Text("${item["message"]}",style: const TextStyle(fontSize: 16,color: Colors.white),)));
        Navigator.pop(context);
      }
      else{
        setState(() {
          isSellBtnClk = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),backgroundColor: Colors.black,
            content: Text("${item["message"]}",style: const TextStyle(fontSize: 16,color: Colors.red),)));
      }

    } catch (e) {
      print(e);
      setState(() {
        isSellBtnClk = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 1),backgroundColor: Colors.black,
          content: Text(e.toString(),style: const TextStyle(fontSize: 16,color: Colors.red),)));
    }
  }
  // addSales() async {
  //   String link = "${baseUrl}api/v1/addSales";
  //   SharedPreferences? sharedPreferences;
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   try {
  //     var studentsmap = salesCartList.map((e) {
  //       return {
  //         "productId": e.productId,
  //         "categoryName": e.categoryName,
  //         "name": e.name,
  //         "salesRate": e.salesRate,
  //         "vat": e.vat,
  //         "quantity": e.quantity,
  //         "total": e.total,
  //         "purchaseRate": e.purchaseRate,
  //       };
  //     }).toList();
  //     print(studentsmap);
  //     Response response = await Dio().post(
  //       link,
  //       data: {
  //         "sales": {
  //           "salesId": 0,
  //           "invoiceNo": "2023-08-170007569",
  //           "salesBy": GetStorage().read("name"),
  //           "salesType": level,
  //           "salesFrom": "1",
  //           "salesDate": "$backEndFirstDate",
  //           "customerId": "$_selectedCustomer",
  //           "employeeId": "$employeeSlNo",
  //           "subTotal": "$CartTotal",
  //           "discount":_discountPercentController.text,
  //           "vat": "$TotalVat",
  //           "transportCost":_transportController.text,
  //           "total": "${Totaltc == 0.0 ? CartTotal : Totaltc}",
  //           "paid": _paidController.text.trim(),
  //           "previousDue": "$previousDue",
  //           "due": "${totalDue == 0.0 ? CartTotal : totalDue}",
  //           "isService": "false",
  //           "note": "Note Here",
  //           "send_sms": true
  //           // "salesId": 0,
  //           // "invoiceNo": "",
  //           // "salesBy": GetStorage().read("name"),
  //           // "salesType": level,
  //           // "salesFrom": "1",
  //           // "salesDate": "$backEndFirstDate",
  //           // "customerId": "$_selectedCustomer",
  //           // "employeeId": "$employeeSlNo",
  //           // "subTotal": "$CartTotal",
  //           // "discount": _discountPercentController.text,
  //           // "vat": "$TotalVat",
  //           // "transportCost": _transportController.text,
  //           // "total": "${Totaltc == 0.0 ? CartTotal : Totaltc}",
  //           // //"total": "$DiccountTotal",
  //           // "paid": _paidController.text.trim(),
  //           // "previousDue": "$previousDue",
  //           // "due": "${totalDue == 0.0 ? CartTotal : totalDue}",
  //           // //"due": "$DiccountTotal",
  //           // "isService": "false",
  //           // "note": "Note Here"
  //         },
  //         "customer":{
  //           "Customer_Address": _addressController.text.trim(),
  //           "Customer_Code": '',
  //           "Customer_Mobile": _mobileNumberController.text.trim(),
  //           "Customer_Name": _nameController.text.trim(),
  //           "Customer_SlNo": '',
  //           "Customer_Type": "G",
  //           "display_name": 'General Customer'
  //         },
  //         "cart": studentsmap
  //       },
  //       options: Options(headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer ${sharedPreferences.getString("token")}",
  //       }),
  //     );
  //     print(response.data);
  //     var item = jsonDecode(response.data);
  //
  //     if(item["success"] == true){
  //
  //       setState(() {
  //         isSellBtnClk = false;
  //       });
  //       _nameController.text = "";
  //       _paidController.text = "";
  //       _discountPercentController.text = "";
  //       _mobileNumberController.text = "";
  //       _addressController.text = "";
  //       _salesRateController.text = "";
  //       _DiscountController.text = "";
  //       _VatController.text = "";
  //       _quantityController.text = "";
  //       _transportController.text = "";
  //       DiccountTotal = 0;
  //       previousDue = "0";
  //       TotalVat = 0;
  //       CartTotal = 0;
  //       salesCartList.clear();
  //       DiccountTotal = 0;
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           duration: const Duration(seconds: 1),backgroundColor: Colors.black,
  //           content: Text("${item["message"]}",style: const TextStyle(fontSize: 16,color: Colors.white),)));
  //       Navigator.pop(context);
  //     }
  //     else{
  //       setState(() {
  //         isSellBtnClk = false;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           duration: const Duration(seconds: 1),backgroundColor: Colors.black,
  //           content: Text("${item["message"]}",style: const TextStyle(fontSize: 16,color: Colors.red),)));
  //     }
  //
  //   } catch (e) {
  //     print(e);
  //     setState(() {
  //       isSellBtnClk = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         duration: const Duration(seconds: 1),backgroundColor: Colors.black,
  //         content: Text(e.toString(),style: const TextStyle(fontSize: 16,color: Colors.red),)));
  //   }
  // }
}
