import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/all_product_provider.dart';
import 'package:kbtradlink/provider/category_provider.dart';
import 'package:kbtradlink/provider/unit_provider.dart';
import 'package:kbtradlink/screen/administation_module/model/unit_model.dart';
import 'package:kbtradlink/screen/sales_module/model/category_model.dart';
import 'package:kbtradlink/utils/const_page.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductEntry extends StatefulWidget {
  const ProductEntry({super.key});

  @override
  State<ProductEntry> createState() => _ProductEntryState();
}

class _ProductEntryState extends State<ProductEntry> {
  //final  _categoryController = TextEditingController();
  final  _productNameController = TextEditingController();
  final  _unitController = TextEditingController();
  final  _vatController = TextEditingController();
  final  _reOrderLevelController = TextEditingController();
  final  _purchaseRateController = TextEditingController();
  final  _salesRateController = TextEditingController();
  final  _WholesaleRateController = TextEditingController();

  String? productCategorySlNo;
  String? _selectedCategory;
  String? _selectedUnit;
  bool? check1 = false;
  bool productEntryBtnClk = false;

  @override
  void initState() {
    AllProductProvider.isLoading=true;
    Provider.of<CategoryProvider>(context, listen: false).getCategoryData();
    Provider.of<AllProductProvider>(context, listen: false).getAllProduct();

    // TODO: implement initState
    super.initState();
  }
  ScrollController mainScrollController = ScrollController();
  late ScrollController _listViewScrollController = ScrollController()
    ..addListener(listViewScrollListener);
  ScrollPhysics _physics = ScrollPhysics();

  void listViewScrollListener() {
    
    if (_listViewScrollController.offset >=
        _listViewScrollController.position.maxScrollExtent &&
        !_listViewScrollController.position.outOfRange) {
      if (mainScrollController.offset == 0) {
        mainScrollController.animateTo(50,
            duration: Duration(milliseconds: 200), curve: Curves.linear);
      }
      setState(() {
        _physics = NeverScrollableScrollPhysics();
      });
      print("bottom");
    }
  }

  void mainScrollListener() {
    if (mainScrollController.offset <=
        mainScrollController.position.minScrollExtent &&
        !mainScrollController.position.outOfRange) {
      setState(() {
        if (_physics is NeverScrollableScrollPhysics) {
          _physics = ScrollPhysics();

          _listViewScrollController.animateTo(
              _listViewScrollController.position.maxScrollExtent - 50,
              duration: Duration(milliseconds: 200),
              curve: Curves.linear);
        }
      });
      print("top");
    }
  }
  var categoryController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    mainScrollController.addListener(mainScrollListener);

    final allCategoryListData = Provider.of<CategoryProvider>(context).categoryList;
    final allProductsData=Provider.of<AllProductProvider>(context).productList;

    return Scaffold(
      appBar: const CustomAppBar(title: "Product Entry"),
      body: SingleChildScrollView(
        controller: mainScrollController,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top:4.0,left: 4.0, right: 4.0),
                decoration: BoxDecoration(
                  color: Colors.teal[100],
                  borderRadius: BorderRadius.circular(10.0),
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
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            "Category",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: Container(
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
                                      _selectedCategory = '';
                                    }
                                  },
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                  controller: categoryController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    contentPadding: const EdgeInsets.only(bottom: 11),
                                    hintText: 'Select Category',
                                    suffix: _selectedCategory == '' ? null : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          categoryController.text = '';
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Icon(Icons.close,size: 14),
                                      ),
                                    ),
                                  )
                              ),
                              suggestionsCallback: (pattern) {
                                return allCategoryListData
                                    .where((element) => element.productCategoryName
                                    .toLowerCase()
                                    .contains(pattern
                                    .toString()
                                    .toLowerCase()))
                                    .take(allCategoryListData.length)
                                    .toList();
                              },
                              itemBuilder: (context, suggestion) {
                                return SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                    child: Text(
                                      suggestion.productCategoryName,
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
                                  (CategoryModel suggestion) {
                                categoryController.text = suggestion.productCategoryName;
                                setState(() {
                                  _selectedCategory = suggestion.productCategorySlNo.toString();
                                  getProductCode();
                                });
                              },
                              onSaved: (value) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            "Product Name",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: Container(
                            height: 30.0,
                            width: MediaQuery.of(context).size.width / 2,

                            child: TextField(
                              style: const TextStyle(fontSize: 13),
                              controller: _productNameController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 6),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Enter product name",
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
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            "Unit",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: Container(
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
                            child: FutureBuilder(
                              future: Provider.of<UnitProvider>(context).getUnit(),
                              builder: (context, snapshot) {
                                return TypeAheadFormField(
                                  textFieldConfiguration:
                                  TextFieldConfiguration(
                                      onChanged: (value){
                                        if (value == '') {
                                          _selectedUnit = '';
                                        }
                                      },
                                      style: const TextStyle(
                                        fontSize: 13,
                                      ),
                                      controller: _unitController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        contentPadding: const EdgeInsets.only(bottom: 11),
                                        hintText: 'Select Unit',
                                        suffix: _selectedUnit == '' ? null : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _unitController.text = '';
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 8),
                                            child: Icon(Icons.close,size: 14),
                                          ),
                                        ),
                                      )
                                  ),
                                  suggestionsCallback: (pattern) {
                                    return snapshot.data!
                                        .where((element) => element.unitName
                                        .toLowerCase()
                                        .contains(pattern
                                        .toString()
                                        .toLowerCase()))
                                        .take(snapshot.data!.length)
                                        .toList();
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return SizedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                        child: Text(
                                          suggestion.unitName,
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
                                      (UnitModel suggestion) {
                                        _unitController.text = suggestion.unitName;
                                    setState(() {
                                      _selectedUnit = suggestion.unitSlNo.toString();
                                    });
                                  },
                                  onSaved: (value) {},
                                );
                              }
                            ),

                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            "VAT",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: Container(
                            height: 30.0,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: const TextStyle(fontSize: 13),
                              controller: _vatController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 5),
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
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            "Purchase Rate",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: Container(
                            height: 30.0,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: const TextStyle(fontSize: 13),
                              controller: _purchaseRateController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 5),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "0",
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
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            "Sales Rate",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: Container(
                            height: 30.0,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: const TextStyle(fontSize: 13),
                              controller: _salesRateController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 5),
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
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            "Wholesale Rate",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: Container(
                            height: 30.0,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: const TextStyle(fontSize: 13),
                              controller: _WholesaleRateController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 5),
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
                    //SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                            children: [
                              const Text(
                                "Is Service :",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 126, 125, 125)),
                              ),
                              Checkbox(
                                //only check box
                                  value: check1, //unchecked
                                  onChanged: (bool? value) {
                                    //value returned when checkbox is clicked
                                    setState(() {
                                      check1 = value;
                                    });
                                  }),
                            ]
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () {
                              if(categoryController.text==""){
                                Utils.errorSnackBar(context, "Please Select Category");
                              }
                              else if(_unitController.text==""){
                                Utils.errorSnackBar(context, "Please Select Unit");
                              }
                              else if(_productNameController.text==""){
                                Utils.errorSnackBar(context, "Please Select Product Name");
                              }
                              else if(_purchaseRateController.text==""){
                                Utils.errorSnackBar(context, "Please Select Purchase Rate");
                              }
                              else if(_salesRateController.text==""){
                                Utils.errorSnackBar(context, "Please Select Sales Rate");
                              }
                              else{
                                setState(() {
                                  productEntryBtnClk = true;
                                });
                                Utils.closeKeyBoard(context);
                                getProductCode().then((value){
                                  if(value!=""){
                                    addProduct(
                                        context,
                                        "$_selectedCategory",
                                        "$iitem",
                                        _productNameController.text,
                                        _purchaseRateController.text,
                                        _reOrderLevelController.text,
                                        _salesRateController.text,
                                        "",
                                        _WholesaleRateController.text,
                                        "$_selectedUnit",
                                        "",
                                        check1,
                                        _vatController.text).then((value){
                                          if(value=="true"){
                                            Provider.of<AllProductProvider>(context, listen: false)
                                                .getAllProduct();
                                            setState(() {

                                            });
                                          }
                                    });
                                  }
                                });
                              }
                            },
                            child: Container(
                                height: 30.0,
                                width: 60.0,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 2, 163, 82),
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                        color: const Color.fromARGB(255, 75, 196, 201),
                                        width: 1)),
                                child: Center(
                                    child: productEntryBtnClk ? const SizedBox(height: 20,width:20,child: CircularProgressIndicator(color: Colors.white,)) : const Text(
                                      "Save",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromARGB(255, 255, 255, 255)),
                                    ))),
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5.0),
           AllProductProvider.isLoading?
           const Center(child: CircularProgressIndicator(),):
           allProductsData.isNotEmpty?
            Container(
              height: MediaQuery.of(context).size.height / 1.43,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  controller: _listViewScrollController,
                  physics: _physics,
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      // color: Colors.red,
                      // padding:EdgeInsets.only(bottom: 16.0),
                      child: DataTable(
                        headingRowHeight: 20.0,
                        dataRowHeight: 20.0,
                        showCheckboxColumn: true,
                        border:
                        TableBorder.all(color: Colors.black54, width: 1),
                        columns: const [
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Product Id'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Product Name'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Category'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Purchase Price'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Sales Price'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Wholesale Price'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('VAT'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Is Service'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Unit'))),
                          ),
                        ],
                        rows: List.generate(
                          allProductsData.length,
                              (int index) => DataRow(
                            cells: <DataCell>[
                              DataCell(
                                Center(
                                    child: Text(
                                        allProductsData[index].productCode)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allProductsData[index].productName.toString().trim())),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allProductsData[index].productCategoryName)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allProductsData[index].productPurchaseRate)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allProductsData[index].productSellingPrice)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allProductsData[index].productWholesaleRate)),
                              ),
                              DataCell(
                                Center(
                                    child:
                                    Text(allProductsData[index].vat)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allProductsData[index].isService)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allProductsData[index].unitName)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
               : const Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 16,color: Colors.red),),)),
            //const SizedBox(height: 15.0,)
          ],
        ),
      ),
    );
  }
  emtyMethod() {
    setState(() {
      iitem = "";
      categoryController.text= "";
      _productNameController.text= "";
      _selectedUnit = null;
      _vatController.text = "";
      _reOrderLevelController.text = "";
      _purchaseRateController.text = "";
      _salesRateController.text = "";
      _WholesaleRateController.text = "";
      check1=false;
    });
  }

  String? iitem;
  Future<String>getProductCode() async {
    String link = "${baseUrl}api/v1/getProductCode";
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      var response = await Dio().post(
        link,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }),
      );
      print(response.data);
      iitem = jsonDecode(response.data);
      print("Product Code===========> $iitem");
      return response.data;
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<String>addProduct(
      context,
      String? productId,
      String? productCode,
      String? productName,
      String? productPurchaseRate,
      String? reorderList,
      String? salesPrice,
      String? productSlNo,
      String? productWholesaleRate,
      String? unitId,
      String? brand,
      bool? isService,
      String? vat,
      ) async {
    String url = "${baseUrl}api/v1/addProduct";
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      var response = await Dio().post(url,
          data: {
            "ProductCategory_ID":"$productId",
            "Product_Code":"$productCode",
            "Product_Name":"$productName",
            "Product_Purchase_Rate":"$productPurchaseRate",
            "Product_ReOrederLevel":"$reorderList",
            "Product_SellingPrice":"$salesPrice",
            "Product_SlNo":"$productSlNo",
            "Product_WholesaleRate":"$productWholesaleRate",
            "Unit_ID":"$unitId",
            "brand":"$brand",
            "is_service":isService,
            "vat":"$vat"
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      print(
          "AddProduct AddProduct AddProduct:${response.data}");
      print("===========++++++=============");
      print("AddProduct AddProduct AddProduct");
      print("============+++++++++++++++=========");

      var data = jsonDecode(response.data);
      Provider.of<AllProductProvider>(context, listen: false).getAllProduct();
      print("AddProduct AddProduct length is ${data}");
      print("success============> ${data["success"]}");
      print("message =================> ${data["message"]}");
      print("productionId ================>  ${data["productionId"]}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: const Color.fromARGB(255, 4, 108, 156),
          duration: const Duration(seconds: 1), content: Center(child: Text("${data["message"]}"))));
      setState(() {
        productEntryBtnClk = false;
      });
      emtyMethod();
      return "true";
    } catch (e) {
      setState(() {
        productEntryBtnClk = false;
      });
      print("Something is wrong AddProduct=======:$e");
      return "";
    }
  }
}
