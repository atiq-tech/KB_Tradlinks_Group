//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/all_product_provider.dart';
import 'package:kbtradlink/provider/product_ledger_provider.dart';
import 'package:kbtradlink/screen/administation_module/model/product_model.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:provider/provider.dart';

class ProductLedger extends StatefulWidget {
  const ProductLedger({super.key});

  @override
  State<ProductLedger> createState() => _ProductLedgerState();
}

class _ProductLedgerState extends State<ProductLedger> {
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

  String? _selectedProduct;

  bool isLoading = false;
  @override
  void initState() {
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    backEndSecondDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());

    Provider.of<AllProductProvider>(context, listen: false).getAllProduct();
    Provider.of<ProductLedgerProvider>(context, listen: false)
        .productLedgerList = [];

    // TODO: implement initState
    super.initState();
  }

  var productController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final allProductsData =
        Provider.of<AllProductProvider>(context).productList;

    final allProductLedgerData =
        Provider.of<ProductLedgerProvider>(context).productLedgerList;

    return Scaffold(
      appBar: const CustomAppBar(title: "Product Ledger"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150.0,
                width: double.infinity,
                // margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
                decoration: BoxDecoration(
                  color: Colors.teal[100],
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
                          flex: 4,
                          child: Text(
                            "Product      :",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
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
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 11),
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
                                                  horizontal: 8),
                                              child: Icon(
                                                Icons.close,
                                                size: 14
                                              ),
                                            ),
                                          ),
                                  )),
                              suggestionsCallback: (pattern) {
                                return allProductsData
                                    .where((element) => element.displayText
                                        .toLowerCase()
                                        .contains(
                                            pattern.toString().toLowerCase()))
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
                              onSuggestionSelected: (ProductModel suggestion) {
                                productController.text =
                                    suggestion.displayText;
                                setState(() {
                                  _selectedProduct =
                                      suggestion.productSlNo.toString();
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
                          flex: 4,
                          child: Text(
                            "Date From :",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        Expanded(
                          flex: 11,
                          child: Container(
                            height: 30,
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
                                  contentPadding: const EdgeInsets.only(
                                    top: 2,
                                    left: 5,
                                  ),
                                  suffixIcon: const Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: Colors.black87,
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
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          flex: 4,
                          child: Text(
                            "Date To     :",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        Expanded(
                          flex: 11,
                          child: Container(
                            height: 30,
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
                                      const EdgeInsets.only(top: 2, left: 5),
                                  suffixIcon: const Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: Colors.black87,
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
                    const SizedBox(height: 5.0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () async {
                          // final connectivityResult =
                          //     await (Connectivity().checkConnectivity());

                          if (productController.text == "") {
                            Utils.errorSnackBar(
                                context, "Please Select Product");
                          } else {
                            // if (connectivityResult ==
                            //         ConnectivityResult.mobile ||
                            //     connectivityResult == ConnectivityResult.wifi) {
                              ProductLedgerProvider().on();
                              Provider.of<ProductLedgerProvider>(context,
                                      listen: false)
                                  .getProductLedger(
                                      "$_selectedProduct",
                                      "$backEndFirstDate",
                                      "$backEndSecondDate");
                            // } else {
                            //   Utils.errorSnackBar(
                            //       context, "Please connect with internet");
                            // }
                          }
                        },
                        child: Container(
                          height: 35.0,
                          width: 75.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.teal, width: 2.0),
                            color: Colors.teal[300],
                            borderRadius: BorderRadius.circular(6.0),
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
                          child: const Center(
                              child: Text(
                            "Show",
                            style: TextStyle(
                                letterSpacing: 1.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 2.0),
            ProductLedgerProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : allProductLedgerData.isNotEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.height / 1.43,
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: SingleChildScrollView(
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
                                  border: TableBorder.all(
                                      color: Colors.black54, width: 1),
                                  columns: const [
                                    DataColumn(
                                      label: Expanded(
                                          child: Center(child: Text('Date'))),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                          child: Center(
                                              child: Text('Description'))),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                          child: Center(child: Text('Rate'))),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                          child: Center(
                                              child: Text('In Quantity'))),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                          child: Center(
                                              child: Text('Out Quantity'))),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                          child: Center(child: Text('Stock'))),
                                    ),
                                  ],
                                  rows: List.generate(
                                    allProductLedgerData.length,
                                    (int index) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Center(
                                              child: Text(
                                                  '${allProductLedgerData[index].date}')),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(
                                                  '${allProductLedgerData[index].description}')),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(
                                                  '${double.parse("${allProductLedgerData[index].rate}").toStringAsFixed(2)}')),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(
                                                  '${allProductLedgerData[index].inQuantity}')),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(
                                                  '${allProductLedgerData[index].outQuantity}')),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(
                                                  '${allProductLedgerData[index].stock}')),
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
                    : const Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Text(
                            "No Data Found",
                            style: TextStyle(fontSize: 16, color: Colors.red),
                          ),
                        ))
          ],
        ),
      ),
    );
  }
}
