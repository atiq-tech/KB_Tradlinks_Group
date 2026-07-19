
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/all_product_provider.dart';
import 'package:kbtradlink/provider/branch_provider.dart';
import 'package:kbtradlink/provider/category_provider.dart';
import 'package:kbtradlink/provider/current_stock_provider.dart';
import 'package:kbtradlink/provider/total_stock_provider.dart';
import 'package:kbtradlink/provider/warehouse_wise_stock_provider.dart';
import 'package:kbtradlink/screen/sales_module/model/branch_model.dart';
import 'package:kbtradlink/screen/sales_module/model/category_model.dart';
import 'package:kbtradlink/screen/administation_module/model/product_model.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:provider/provider.dart';

class StockReport extends StatefulWidget {
  const StockReport({super.key});

  @override
  State<StockReport> createState() => _StockReportState();
}
class _StockReportState extends State<StockReport> {
  final categoryController = TextEditingController();
  final productController = TextEditingController();
  final branchController = TextEditingController();
  bool isCategoryWiseClicked = false;
  bool isProductWiseClicked = false;
  bool isWarehouseWiseClicked = false;
  double thFontSize = 10.0;
  String data = 'Current Stock';
  final List<String> _types = [
    'Current Stock',
    'Total Stock',
    'Category Wise Stock',
    'Product Wise Stock',
    'Warehouse Wise Stock'
  ];

  String _selectedTypes = 'Current Stock';
  String? _selectedProduct;

  String categoryId = "";
  String productId = "";
  String? branchId;
  ///Sub total
  double? currentQuantity;
  double? currentStockValue;
  double? currentQuantityTotalStock;
  double? currentStockValueTotalStock;
  double? warehouseWiseCurrentQuantity;
  double? warehouseWiseStockValue;

  @override
  void initState() {
    Provider.of<CategoryProvider>(context, listen: false).getCategoryData();
    Provider.of<AllProductProvider>(context, listen: false).getAllProduct();
    Provider.of<BranchProvider>(context, listen: false).getBranchData();
    Provider.of<TotalStockProvider>(context, listen: false).getTotalStocklist = [];
    Provider.of<CurrentStockProvider>(context, listen: false).getCurrentStocklist = [];
    Provider.of<WarehouseWiseStockProvider>(context, listen: false).getWarehouseWiseStockList = [];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allCurrentStockData = Provider.of<CurrentStockProvider>(context).getCurrentStocklist.where((element) => element.currentQuantity !='0.000' && !element.currentQuantity.startsWith("-")).toList();
    final allTotalStockData=Provider.of<TotalStockProvider>(context).getTotalStocklist.where((element) => element.currentQuantity !='0' && !element.currentQuantity.startsWith("-")).toList();
    final allWarehouseWiseStockData = Provider.of<WarehouseWiseStockProvider>(context).getWarehouseWiseStockList;
    final allCategory = Provider.of<CategoryProvider>(context).categoryList;
    final productList = Provider.of<AllProductProvider>(context).productList;
    final allBranch = Provider.of<BranchProvider>(context).branchList;
    // getDataFromLocal();

    ///Sub total
    currentQuantity=allCurrentStockData.map((e) => e.currentQuantity).fold(0.0, (p, element) => p!+double.parse(element));
    currentStockValue=allCurrentStockData.map((e) => e.stockValue).fold(0.0, (p, element) => p!+double.parse(element));
    currentQuantityTotalStock=allTotalStockData.map((e) => e.currentQuantity).fold(0.0, (p, element) => p!+double.parse(element));
    currentStockValueTotalStock=allTotalStockData.map((e) => e.stockValue).fold(0.0, (p, element) => p!+double.parse(element));
    warehouseWiseCurrentQuantity=allWarehouseWiseStockData.map((e) => e.currentQuantity).fold(0.0, (p, element) => p!+double.parse(element));
    warehouseWiseStockValue=allWarehouseWiseStockData.map((e) => e.stockValue).fold(0.0, (p, element) => p!+double.parse(element));

    return Scaffold(
     appBar: const CustomAppBar(title:"Stock Report",),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0),
            child: Container(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0,bottom: 4.0),
              decoration: BoxDecoration(
                color: Color(0xffD2D2FF),
                //color: Colors.yellow.shade50,
               // color: Colors.blue[100],
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
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text(
                          "Select Type :",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
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
                                isExpanded: true,
                                hint: const Text(
                                  'Please select a type',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ), // Not necessary for Option 1
                                value: _selectedTypes,
                                onChanged: (newValue) {

                                  setState(() {
                                    _selectedTypes = newValue!;
                                  });

                                    if(_selectedTypes == "Category Wise Stock"){
                                      setState(() {
                                        isCategoryWiseClicked = true;
                                        isProductWiseClicked = false;
                                        isWarehouseWiseClicked = false;
                                        categoryId = "";
                                        productId = "";
                                        branchId = "";
                                        branchController.text = '';
                                        categoryController.text = '';
                                        productController.text = '';
                                      });
                                    }
                                    else if(_selectedTypes == "Product Wise Stock"){
                                      setState(() {
                                        isCategoryWiseClicked = false;
                                        isProductWiseClicked = true;
                                        isWarehouseWiseClicked = false;
                                        categoryId = "";
                                        productId = "";
                                        branchId = "";
                                        branchController.text = '';
                                        categoryController.text = '';
                                        productController.text = '';
                                      });
                                    }
                                    else if(_selectedTypes == "Warehouse Wise Stock"){
                                      setState(() {
                                        isCategoryWiseClicked = false;
                                        isProductWiseClicked = false;
                                        isWarehouseWiseClicked = true;
                                        categoryId = "";
                                        productId = "";
                                        branchId = "";
                                        branchController.text = '';
                                        categoryController.text = '';
                                        productController.text = '';
                                      });
                                    }
                                    else if(_selectedTypes == "Total Stock"){
                                      setState(() {
                                        isCategoryWiseClicked = false;
                                        isProductWiseClicked = false;
                                        isWarehouseWiseClicked = false;
                                        categoryId = "";
                                        productId = "";
                                        branchId = "";
                                        branchController.text = '';
                                        categoryController.text = '';
                                        productController.text = '';
                                      });
                                    }
                                    else if(_selectedTypes == "Current Stock"){
                                      setState(() {
                                        isCategoryWiseClicked = false;
                                        isProductWiseClicked = false;
                                        isWarehouseWiseClicked = false;
                                        categoryId = "";
                                        productId = "";
                                        branchId = "";
                                        branchController.text = '';
                                        categoryController.text = '';
                                        productController.text = '';
                                      });
                                    }

                                },
                                items: _types.map((location) {
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
                  isCategoryWiseClicked == true
                      ? Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Text(
                            "Category     :",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
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
                                    .toString()
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
                                categoryController.text = suggestion.productCategoryName;
                                setState(() {
                                  categoryId = suggestion.productCategorySlNo;
                                });
                              },
                              onSaved: (value) {},
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                      : Container(),
                  isProductWiseClicked == true
                      ? Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Text(
                            "Product       :",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
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
                                      productId = suggestion.productSlNo;
                                    });
                                  },
                                  onSaved: (value) {},
                                ),
                              )
                          ),
                        )
                      ],
                    ),
                  )
                      : Container(),
                  isWarehouseWiseClicked == true
                      ? Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Text(
                            "Warehouse :",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
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
                                    hintText: 'Select Warehouse',
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
                                  child: Text(suggestion.brunchName,
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
                                branchController.text = suggestion.brunchName;
                                setState(() {
                                  branchId = suggestion.brunchId;
                                });
                              },
                              onSaved: (value) {},
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                      : Container(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.all(1.0),
                      child: InkWell(
                        onTap: () async {

                          // final connectivityResult = await (Connectivity().checkConnectivity());

                          // if (connectivityResult == ConnectivityResult.mobile
                          // || connectivityResult == ConnectivityResult.wifi) {
                            setState(() {
                              _selectedTypes == "Current Stock"
                                  ? data = 'Current Stock'
                                  : _selectedTypes == "Total Stock"
                                  ? data = 'Total Stock'
                                  : _selectedTypes == "Category Wise Stock"
                                  ? data = "Category Wise Stock"
                                  : _selectedTypes == "Product Wise Stock"
                                  ? data = "Product Wise Stock"
                                  : _selectedTypes == "Warehouse Wise Stock"
                                  ? data = "Warehouse Wise Stock"
                                  : data = '';
                            });

                            if(data=="Current Stock"){
                              setState(() {
                                CurrentStockProvider().on();
                              });
                              Provider.of<CurrentStockProvider>(context, listen: false)
                                  .getCurrentStock(context, ""
                              );
                            }
                            else{
                              if(data == "Category Wise Stock" && categoryController.text == ""){
                                Utils.errorSnackBar(context, "Please Select Category");
                              }
                              else if(data == "Product Wise Stock" && productController.text == ""){
                                Utils.errorSnackBar(context, "Please Select Product");
                              }
                              else if(data == "Warehouse Wise Stock"){
                                if(branchController.text == ""){
                                  Utils.errorSnackBar(context, "Please Select Warehouse");
                                }
                                else{
                                  setState(() {
                                    WarehouseWiseStockProvider().on();
                                  });
                                  Provider.of<WarehouseWiseStockProvider>(context, listen: false)
                                      .getWarehouseWiseStock("$branchId");
                                }
                              }
                              else{
                                setState(() {
                                  TotalStockProvider().on();
                                });
                                Provider.of<TotalStockProvider>(context, listen: false)
                                    .getTotalStock(context,productId,categoryId,''
                                );
                              }
                            }
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
          ),
          const Divider(
            color: Color.fromARGB(255, 92, 90, 90),
          ),
          if (data == 'Current Stock')
           /* LayoutBuilder(builder: (context, constraints) {*/
              CurrentStockProvider.isLoading == true && allCurrentStockData.isEmpty
                 ? const Center(child: CircularProgressIndicator())
                  : allCurrentStockData.isEmpty
                  ? FutureBuilder(
                future: Provider.of<CurrentStockProvider>(context, listen: false).getDataFromLocal(),
                builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              // color: Colors.red,
                              padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                              child: DataTable(
                                headingRowHeight: 20.0,
                                dataRowHeight: 20.0,
                                //columnSpacing: 2,
                                border: TableBorder.all(
                                    color: Colors.black54, width: 1),
                                columns:  const [
                                  DataColumn(
                                    label: Expanded(
                                        child: Text('Product Id',
                                            textAlign: TextAlign.center)),
                                  ),
                                  DataColumn(
                                    label:Expanded(

                                        child: Text('Product Name',
                                            textAlign: TextAlign.center)),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                        child: Text('Category',
                                            textAlign: TextAlign.center)),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                        child: Text('Warehouse',
                                            textAlign: TextAlign.center)),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                        child: Text('Purchase Rate',
                                            textAlign: TextAlign.center)),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                        child: Text('Current Quantity',
                                            textAlign: TextAlign.center)),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                        child: Text('Stock Value',
                                            textAlign: TextAlign.center)),
                                  ),
                                ],
                                rows: List.generate(
                                  snapshot.data!.length,
                                      (int index) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(
                                        SizedBox(
                                            child: Center(
                                                child: Text(
                                                  snapshot.data![index].productCode,
                                                  textAlign: TextAlign.center,
                                                ))),
                                      ),
                                      DataCell(
                                        SizedBox(
                                            child: Center(
                                              child: Text(
                                                  snapshot.data![index].productName.toString().trim(),
                                                  textAlign: TextAlign.center),
                                            )),
                                      ),
                                      DataCell(
                                        SizedBox(
                                            child: Center(
                                              child: Text(
                                                  snapshot.data![index].productCategoryName,
                                                  textAlign: TextAlign.center),
                                            )),
                                      ),
                                      DataCell(
                                        SizedBox(
                                            child: Center(
                                              child: Text(
                                                  snapshot.data![index].brunchName,
                                                  textAlign: TextAlign.center),
                                            )),
                                      ),
                                      DataCell(
                                        SizedBox(
                                            child: Center(
                                              child: Text(
                                                  snapshot.data![index].productPurchaseRate,
                                                  textAlign: TextAlign.center),
                                            )),
                                      ),
                                      DataCell(
                                        SizedBox(
                                            child: Center(
                                                child: Text(
                                                    double.parse(snapshot.data![index].currentQuantity).toStringAsFixed(2),
                                                    textAlign: TextAlign.center))),
                                      ),
                                      DataCell(
                                        SizedBox(
                                            child: Center(
                                                child: Text(
                                                    double.parse(snapshot.data![index].stockValue).toStringAsFixed(2),
                                                    textAlign: TextAlign.center))),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    else if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    else{
                      return SizedBox();
                    }
                  },)
                  : Expanded(
                  // height: 500,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        // color: Colors.red,
                        padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DataTable(
                              headingRowHeight: 20.0,
                              dataRowHeight: 20.0,
                              //columnSpacing: 2,
                              border: TableBorder.all(
                                  color: Colors.black54, width: 1),
                              columns:  const [
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Product Id',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label:Expanded(

                                      child: Text('Product Name',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Category',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Warehouse',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Purchase Rate',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Current Quantity',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Stock Value',
                                          textAlign: TextAlign.center)),
                                ),
                              ],
                              rows: List.generate(
                                allCurrentStockData.length,
                                    (int index) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      SizedBox(
                                          child: Center(
                                              child: Text(
                                                allCurrentStockData[index].productCode,
                                                textAlign: TextAlign.center,
                                              ))),
                                    ),
                                    DataCell(
                                      SizedBox(
                                          child: Center(
                                            child: Text(
                                                allCurrentStockData[index].productName.toString().trim(),
                                                textAlign: TextAlign.center),
                                          )),
                                    ),
                                    DataCell(
                                      SizedBox(
                                          child: Center(
                                            child: Text(
                                                allCurrentStockData[index].productCategoryName,
                                                textAlign: TextAlign.center),
                                          )),
                                    ),
                                    DataCell(
                                      SizedBox(
                                          child: Center(
                                            child: Text(
                                                allCurrentStockData[index].brunchName,
                                                textAlign: TextAlign.center),
                                          )),
                                    ),
                                    DataCell(
                                      SizedBox(
                                          child: Center(
                                            child: Text(
                                                allCurrentStockData[index].productPurchaseRate,
                                                textAlign: TextAlign.center),
                                          )),
                                    ),
                                    DataCell(
                                      SizedBox(
                                          child: Center(
                                              child: Text(
                                                  double.parse(allCurrentStockData[index].currentQuantity).toStringAsFixed(2),
                                                  textAlign: TextAlign.center))),
                                    ),
                                    DataCell(
                                      SizedBox(
                                          child: Center(
                                              child: Text(
                                                  double.parse(allCurrentStockData[index].stockValue).toStringAsFixed(2),
                                                  textAlign: TextAlign.center))),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              children: [
                                const Text("Total Current Quantity   :  ",style:TextStyle(fontWeight: FontWeight.bold),),
                                Text("$currentQuantity"),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Total Stock Value           :  ",style:TextStyle(fontWeight: FontWeight.bold),),
                                Text("$currentStockValue"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )

            // CurrentStockProvider.isLoading == true
            //     ? const Center(child: CircularProgressIndicator())
            //     : Expanded(
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.vertical,
            //     child: SingleChildScrollView(
            //       scrollDirection: Axis.horizontal,
            //       child: Container(
            //         // color: Colors.red,
            //         padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             DataTable(
            //               headingRowHeight: 20.0,
            //               dataRowHeight: 20.0,
            //               //columnSpacing: 2,
            //               border: TableBorder.all(
            //                   color: Colors.black54, width: 1),
            //               columns:  const [
            //                 DataColumn(
            //                   label: Expanded(
            //                       child: Text('Product Id',
            //                           textAlign: TextAlign.center)),
            //                 ),
            //                 DataColumn(
            //                   label:Expanded(
            //
            //                       child: Text('Product Name',
            //                           textAlign: TextAlign.center)),
            //                 ),
            //                 DataColumn(
            //                   label: Expanded(
            //                       child: Text('Category',
            //                           textAlign: TextAlign.center)),
            //                  ),
            //                   DataColumn(
            //                     label: Expanded(
            //                         child: Text('Warehouse',
            //                             textAlign: TextAlign.center)),
            //                   ),
            //                   DataColumn(
            //                     label: Expanded(
            //                         child: Text('Purchase Rate',
            //                             textAlign: TextAlign.center)),
            //                   ),
            //                 DataColumn(
            //                   label: Expanded(
            //                       child: Text('Current Quantity',
            //                           textAlign: TextAlign.center)),
            //                 ),
            //                 DataColumn(
            //                   label: Expanded(
            //                       child: Text('Stock Value',
            //                           textAlign: TextAlign.center)),
            //                 ),
            //               ],
            //               rows: List.generate(
            //                 allCurrentStockData.length,
            //                     (int index) => DataRow(
            //                   cells: <DataCell>[
            //                     DataCell(
            //                       SizedBox(
            //                           child: Center(
            //                               child: Text(
            //                                 allCurrentStockData[index].productCode,
            //                                 textAlign: TextAlign.center,
            //                               ))),
            //                     ),
            //                     DataCell(
            //                       SizedBox(
            //                           child: Center(
            //                             child: Text(
            //                             allCurrentStockData[index].productName.toString().trim(),
            //                                 textAlign: TextAlign.center),
            //                           )),
            //                     ),
            //                     DataCell(
            //                       SizedBox(
            //                           child: Center(
            //                             child: Text(
            //                              allCurrentStockData[index].productCategoryName,
            //                                 textAlign: TextAlign.center),
            //                           )),
            //                     ),
            //              DataCell(
            //                       SizedBox(
            //                           child: Center(
            //                             child: Text(
            //                                 allCurrentStockData[index].brunchName,
            //                                 textAlign: TextAlign.center),
            //                           )),
            //                     ),
            //                   DataCell(
            //                       SizedBox(
            //                           child: Center(
            //                             child: Text(
            //                                 allCurrentStockData[index].productPurchaseRate,
            //                                 textAlign: TextAlign.center),
            //                           )),
            //                     ),
            //                     DataCell(
            //                       SizedBox(
            //                           child: Center(
            //                               child: Text(
            //                                 double.parse(allCurrentStockData[index].currentQuantity).toStringAsFixed(2),
            //                                   textAlign: TextAlign.center))),
            //                     ),
            //                     DataCell(
            //                       SizedBox(
            //                           child: Center(
            //                               child: Text(
            //                                 double.parse(allCurrentStockData[index].stockValue).toStringAsFixed(2),
            //                                   textAlign: TextAlign.center))),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //
            //             const SizedBox(height: 20,),
            //             Row(
            //               children: [
            //                 const Text("Total Current Quantity   :  ",style:TextStyle(fontWeight: FontWeight.bold),),
            //                 Text("$currentQuantity"),
            //               ],
            //             ),
            //             Row(
            //               children: [
            //                 const Text("Total Stock Value           :  ",style:TextStyle(fontWeight: FontWeight.bold),),
            //                 Text("$currentStockValue"),
            //               ],
            //             ),
            //
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          else if (data == 'Total Stock')
            TotalStockProvider.isLoading == true
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    // color: Colors.red,
                    padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
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
                                  child: Text(
                                    'Product Id',
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            DataColumn(
                              label: Expanded(
                                  child: Text('Product Name',
                                      textAlign: TextAlign.center)),
                            ),
                            DataColumn(
                              label: Expanded(
                                  child: Text('Category',
                                      textAlign: TextAlign.center)),
                            ),
                            DataColumn(
                              label: Expanded(
                                  child: Text('Warehouse',
                                      textAlign: TextAlign.center)),
                            ),
                            DataColumn(
                              label: Expanded(
                                  child: Text('Purchased Quantity',
                                      textAlign: TextAlign.center)),
                            ),
                            DataColumn(
                              label: Expanded(
                                  child: Text('Purchase Returned Quantity',
                                      textAlign: TextAlign.center)),
                            ),
                            DataColumn(
                              label: Expanded(
                                  child: Text('Damaged Quantity',
                                      textAlign: TextAlign.center)),
                            ),
                            DataColumn(
                              label: Expanded(
                                  child: Text('Sold Quantity',
                                      textAlign: TextAlign.center)),
                            ),
                            DataColumn(
                              label: Expanded(
                                  child: Text('Sales Returned Quantity',
                                      textAlign: TextAlign.center)),
                            ),
                            DataColumn(
                              label: Expanded(
                                  child: Text('Transferred In Quantity',
                                      textAlign: TextAlign.center)),
                            ),
                            DataColumn(
                              label: Expanded(
                                  child: Text('Transferred Out Quantity',
                                      textAlign: TextAlign.center)),
                            ),
                            DataColumn(
                              label: Expanded(
                                  child: Text('Current Quantity',
                                      textAlign: TextAlign.center)),
                            ),
                            DataColumn(
                              label: Expanded(
                                  child: Text('Stock Value',
                                      textAlign: TextAlign.center)),
                            ),
                          ],
                          rows: List.generate(
                             allTotalStockData.length,
                                (int index) => DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  SizedBox(
                                      child: Center(
                                          child: Text(
                                             allTotalStockData[index].productCode,
                                              textAlign: TextAlign.center))),
                                ),
                                DataCell(
                                  SizedBox(
                                      child: Center(
                                        child: Text(
                                          allTotalStockData[index].productName.toString().trim(),
                                            textAlign: TextAlign.center),
                                      )),
                                ),
                                DataCell(
                                  SizedBox(
                                      child: Center(
                                        child: Text(
                                            allTotalStockData[index].productCategoryName,
                                            textAlign: TextAlign.center),
                                      )),
                                ),
                                 DataCell(
                                  SizedBox(

                                      child: Center(
                                          child: Text(
                                              allTotalStockData[index].brunchName,
                                              textAlign: TextAlign.center))),
                                ),
                                DataCell(
                                  SizedBox(

                                      child: Center(
                                          child: Text(
                                              double.parse(allTotalStockData[index].purchasedQuantity).toStringAsFixed(2),
                                              textAlign: TextAlign.center))),
                                ),
                                DataCell(
                                  SizedBox(

                                      child: Center(
                                          child: Text(
                                              double.parse(allTotalStockData[index].purchaseReturnedQuantity).toStringAsFixed(2),
                                              textAlign: TextAlign.center))),
                                ),
                                DataCell(
                                  SizedBox(

                                      child: Center(
                                          child: Text(
                                              double.parse(allTotalStockData[index].damagedQuantity).toStringAsFixed(2),
                                              textAlign: TextAlign.center))),
                                ),
                                DataCell(
                                  SizedBox(

                                      child: Center(
                                          child: Text(
                                              double.parse(allTotalStockData[index].soldQuantity).toStringAsFixed(2),
                                              textAlign: TextAlign.center))),
                                ),
                                DataCell(
                                  SizedBox(

                                      child: Center(
                                          child: Text(
                                              double.parse(allTotalStockData[index].salesReturnedQuantity).toStringAsFixed(2),
                                              textAlign: TextAlign.center))),
                                ),
                                DataCell(
                                  SizedBox(

                                      child: Center(
                                          child: Text(
                                              double.parse(allTotalStockData[index].transferredToQuantity).toStringAsFixed(2),
                                              textAlign: TextAlign.center))),
                                ),
                                DataCell(
                                  SizedBox(

                                      child: Center(
                                          child: Text(
                                              double.parse(allTotalStockData[index].transferredFromQuantity).toStringAsFixed(2),
                                              textAlign: TextAlign.center))),
                                ),
                                DataCell(
                                  SizedBox(
                                      child: Center(
                                          child: Text(
                                             "${double.parse(allTotalStockData[index].currentQuantity).toStringAsFixed(2)} ${allTotalStockData[index].unitName}" ,
                                              textAlign: TextAlign.center))),
                                ),
                                DataCell(
                                  SizedBox(
                                      child: Center(
                                          child: Text(
                                              double.parse(allTotalStockData[index].stockValue).toStringAsFixed(2),
                                              textAlign: TextAlign.center))),
                                ),
                              ],
                            ),
                          ),
                        ),
                       SizedBox(height: 20,),
                        Row(
                          children: [
                           Text("Total Current Quantity   :  ",style:TextStyle(fontWeight: FontWeight.bold),),
                            Text(double.parse("${currentQuantityTotalStock}").toStringAsFixed(2) ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Total Stock Value           :  ",style:TextStyle(fontWeight: FontWeight.bold),),
                            Text(double.parse("$currentStockValueTotalStock").toStringAsFixed(2) ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )

          else if (data == 'Category Wise Stock')
              TotalStockProvider.isLoading == true
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
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
                                  color: Colors.black54, width: 1),
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
                                  label: Expanded(
                                      child: Text('Warehouse',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Purchased Quantity',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Purchase Returned Quantity',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Damaged Quantity',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Sold Quantity',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Sales Returned Quantity',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Transferred In Quantity',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Transferred Out Quantity',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label:
                                  Expanded(child: Center(child: Text('Current Quantity'))),
                                ),
                                DataColumn(
                                  label: Expanded(child: Center(child: Text('Stock Value'))),
                                ),
                              ],
                              rows: List.generate(
                                allTotalStockData.length,
                                    (int index) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Center(
                                          child: Text(
                                            allTotalStockData[index].productCode
                                          )),
                                    ),
                                    DataCell(
                                      Center(
                                          child: Text(
                                             allTotalStockData[index].productName.toString().trim()
                                          )),
                                    ),
                                    DataCell(
                                      Center(
                                          child: Text(
                                            allTotalStockData[index].productCategoryName
                                          )),
                                    ),
                                 DataCell(
                                      SizedBox(

                                          child: Center(
                                              child: Text(
                                                  allTotalStockData[index].brunchName,
                                                  textAlign: TextAlign.center))),
                                    ),
                                    DataCell(
                                      SizedBox(

                                          child: Center(
                                              child: Text(
                                                  double.parse(allTotalStockData[index].purchasedQuantity).toStringAsFixed(2),
                                                  textAlign: TextAlign.center))),
                                    ),
                                    DataCell(
                                      SizedBox(

                                          child: Center(
                                              child: Text(
                                                  double.parse(allTotalStockData[index].purchaseReturnedQuantity).toStringAsFixed(2),
                                                  textAlign: TextAlign.center))),
                                    ),
                                    DataCell(
                                      SizedBox(

                                          child: Center(
                                              child: Text(
                                                  double.parse(allTotalStockData[index].damagedQuantity).toStringAsFixed(2),
                                                  textAlign: TextAlign.center))),
                                    ),
                                    DataCell(
                                      SizedBox(

                                          child: Center(
                                              child: Text(
                                                  double.parse(allTotalStockData[index].soldQuantity).toStringAsFixed(2),
                                                  textAlign: TextAlign.center))),
                                    ),
                                    DataCell(
                                      SizedBox(

                                          child: Center(
                                              child: Text(
                                                  double.parse(allTotalStockData[index].salesReturnedQuantity).toStringAsFixed(2),
                                                  textAlign: TextAlign.center))),
                                    ),
                                    DataCell(
                                      SizedBox(

                                          child: Center(
                                              child: Text(
                                                  double.parse(allTotalStockData[index].transferredToQuantity).toStringAsFixed(2),
                                                  textAlign: TextAlign.center))),
                                    ),
                                    DataCell(
                                      SizedBox(

                                          child: Center(
                                              child: Text(
                                                  double.parse(allTotalStockData[index].transferredFromQuantity).toStringAsFixed(2),
                                                  textAlign: TextAlign.center))),
                                    ),
                                    DataCell(
                                      Center(
                                          child: Text(
                                             allTotalStockData[index].currentQuantity+" "+allTotalStockData[index].unitName
                                          )),
                                    ),
                                    DataCell(
                                      Center(
                                          child: Text(
                                            double.parse(allTotalStockData[index].stockValue).toStringAsFixed(2)
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              children: [
                                const Text("Total Current Quantity   :  ",style:TextStyle(fontWeight: FontWeight.bold),),
                                Text("$currentQuantityTotalStock"),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Total Stock Value           :  ",style:TextStyle(fontWeight: FontWeight.bold),),
                                Text("$currentStockValueTotalStock"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else if (data == 'Product Wise Stock')
                TotalStockProvider.isLoading == true
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
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
                                  label: Expanded(child: Center(child: Text('Product Id'))),
                                ),
                                DataColumn(
                                  label: Expanded(child: Center(child: Text('Product Name'))),
                                ),
                                DataColumn(
                                  label: Expanded(child: Center(child: Text('Category'))),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Warehouse',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Purchased Quantity',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Purchase Returned Quantity',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Damaged Quantity',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Sold Quantity',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Sales Returned Quantity',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Transferred In Quantity',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text('Transferred Out Quantity',
                                          textAlign: TextAlign.center)),
                                ),
                                DataColumn(
                                  label: Expanded(child: Center(child: Text('Current Quantity'))),
                                ),
                                DataColumn(
                                  label: Expanded(child: Center(child: Text('Stock Value'))),
                                ),
                              ],
                              rows: List.generate(
                                allTotalStockData.length,
                                    (int index) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Center(
                                          child: Text(
                                              allTotalStockData[index].productCode
                                          )),
                                    ),
                                    DataCell(
                                      Center(
                                          child: Text(
                                              ' ${allTotalStockData[index].productName.toString().trim()}'
                                          )),
                                    ),
                                    DataCell(
                                      Center(
                                          child: Text(
                                        ' ${allTotalStockData[index].productCategoryName}'
                                          )),
                                    ),
                                    DataCell(
                                      SizedBox(
                                          child: Center(
                                              child: Text(
                                                  allTotalStockData[index].brunchName,
                                                  textAlign: TextAlign.center))),
                                    ),
                                    DataCell(
                                      SizedBox(

                                          child: Center(
                                              child: Text(
                                                  double.parse(allTotalStockData[index].purchasedQuantity).toStringAsFixed(2),
                                                  textAlign: TextAlign.center))),
                                    ),
                                    DataCell(
                                      SizedBox(

                                          child: Center(
                                              child: Text(
                                                  double.parse(allTotalStockData[index].purchaseReturnedQuantity).toStringAsFixed(2),
                                                  textAlign: TextAlign.center))),
                                    ),
                                    DataCell(
                                      SizedBox(

                                          child: Center(
                                              child: Text(
                                                  double.parse(allTotalStockData[index].damagedQuantity).toStringAsFixed(2),
                                                  textAlign: TextAlign.center))),
                                    ),
                                    DataCell(
                                      SizedBox(

                                          child: Center(
                                              child: Text(
                                                  double.parse(allTotalStockData[index].soldQuantity).toStringAsFixed(2),
                                                  textAlign: TextAlign.center))),
                                    ),
                                    DataCell(
                                      SizedBox(

                                          child: Center(
                                              child: Text(
                                                  double.parse(allTotalStockData[index].salesReturnedQuantity).toStringAsFixed(2),
                                                  textAlign: TextAlign.center))),
                                    ),
                                    DataCell(
                                      SizedBox(

                                          child: Center(
                                              child: Text(
                                                  double.parse(allTotalStockData[index].transferredToQuantity).toStringAsFixed(2),
                                                  textAlign: TextAlign.center))),
                                    ),
                                    DataCell(
                                      SizedBox(

                                          child: Center(
                                              child: Text(
                                                  double.parse(allTotalStockData[index].transferredFromQuantity).toStringAsFixed(2),
                                                  textAlign: TextAlign.center))),
                                    ),
                                    DataCell(
                                      Center(
                                          child: Text(
                                          '${allTotalStockData[index].currentQuantity} ${allTotalStockData[index].unitName}'
                                          )),
                                    ),
                                    DataCell(
                                      Center(
                                          child: Text(
                                           ' ${allTotalStockData[index].stockValue}'
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              children: [
                                const Text("Total Current Quantity   :  ",style:TextStyle(fontWeight: FontWeight.bold),),
                                Text("$currentQuantityTotalStock"),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Total Stock Value           :  ",style:TextStyle(fontWeight: FontWeight.bold),),
                                Text("$currentStockValueTotalStock"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else if (data == "Warehouse Wise Stock")
                  WarehouseWiseStockProvider.isLoading == true
                    ? const Center(child: CircularProgressIndicator())
                    :
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DataTable(
                                // headingRowHeight: 20.0,
                                // dataRowHeight: 100.0,
                                dataRowMaxHeight: double.infinity,
                                showCheckboxColumn: true,
                                border: TableBorder.all(
                                    color: Colors.black54, width: 1),
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
                                    label: Expanded(
                                        child: Text('Current Quantity with Warehouse',
                                            textAlign: TextAlign.center)),
                                  ),
                                ],
                                rows: List.generate(
                                  allWarehouseWiseStockData.length,
                                      (int index) =>  DataRow(
                                    cells: <DataCell>[
                                      DataCell(
                                        Center(
                                            child: Text(
                                                allWarehouseWiseStockData[index].productCode
                                            )),
                                      ),
                                      DataCell(
                                        Center(
                                            child: Text(
                                                ' ${allWarehouseWiseStockData[index].productName.toString().trim()}'
                                            )),
                                      ),
                                      DataCell(
                                        Center(
                                            child: Text(
                                                ' ${allWarehouseWiseStockData[index].productCategoryName}'
                                            )),
                                      ),
                                      DataCell(
                                        Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Total = ${allWarehouseWiseStockData[index].totalQty} ${allWarehouseWiseStockData[index].unitName}',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.bold),
                                                ),
                                                ...List.generate(allWarehouseWiseStockData[index].brances.length, (i){
                                                  return Text("${allWarehouseWiseStockData[index].brances[i].brunchName} = ${allWarehouseWiseStockData[index].brances[i].currentQuantity} ${allWarehouseWiseStockData[index].unitName}");
                                                })
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                children: [
                                  const Text("Total Current Quantity   :  ",style:TextStyle(fontWeight: FontWeight.bold),),
                                  Text(double.parse("$warehouseWiseCurrentQuantity").toStringAsFixed(2)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("Total Stock Value           :  ",style:TextStyle(fontWeight: FontWeight.bold),),
                                  Text(double.parse("$warehouseWiseStockValue").toStringAsFixed(2)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
        ],
      ),
    );
  }
}
