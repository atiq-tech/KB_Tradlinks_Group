//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/all_product_provider.dart';
import 'package:kbtradlink/provider/customer_provider.dart';
import 'package:kbtradlink/provider/other_income_expense_provider.dart';
import 'package:kbtradlink/provider/all_profit_loss_provider.dart';
import 'package:kbtradlink/provider/profit_loss_product_provider.dart';
import 'package:kbtradlink/screen/administation_module/model/customer_model.dart';
import 'package:kbtradlink/screen/administation_module/model/product_model.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:provider/provider.dart';

class ProfitLossReportPage extends StatefulWidget {
  const ProfitLossReportPage({super.key});

  @override
  State<ProfitLossReportPage> createState() => _ProfitLossReportPageState();
}

class _ProfitLossReportPageState extends State<ProfitLossReportPage> {
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  bool isCustomerListClicked = false;
  bool isProductListClicked = false;
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

  var customerNameController = TextEditingController();
  var customer = '';

  final List<String> _searchTypeList = [
    'All',
    'By Customer',
    'By Product',
  ];
  String? _searchType = "All";
  String _selectedCustomer = "";
  String _selectedProduct = "";

  bool isLoading = false;

  @override
  void initState() {
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    backEndSecondDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    Provider.of<CustomerListProvider>(context, listen: false)
        .getCustomerList(context, customerType: '');
    Provider.of<AllProductProvider>(context, listen: false).getAllProduct();
    Provider.of<AllProfitLossProvider>(context, listen: false)
        .getAllProfitLosslist = [];
    Provider.of<ProfitLossProductProvider>(context, listen: false)
        .getProfitLossProductlist = [];

    Provider.of<OtherIncomeExpenseProvider>(context, listen: false)
        .getOtherIncomeExpenses(context, _selectedCustomer,
            "${backEndFirstDate}", "${backEndSecondDate}", _selectedProduct);
    // TODO: implement initState
    super.initState();
  }

  final List selesDetailslist = [];
  @override
  Widget build(BuildContext context) {
    ///Customers
    final allCustomersData = Provider.of<CustomerListProvider>(context)
        .customerList
        .where((element) => element.displayName != "General Customer");

    final productList = Provider.of<AllProductProvider>(context).productList;

    ///All ProfitLoss
    final allProfitLossData =
        Provider.of<AllProfitLossProvider>(context).getAllProfitLosslist;
    var totalPofitLoss;
    var totalPurchase;
    var totalSoldAmount;
    var totalDiscount;

    /// Total profit
    totalPofitLoss = allProfitLossData.map((e) => e.saleDetails.map((e) => e.profitLoss).fold(0.0, (p, e) => p + double.parse("${e}"))).fold(0.0, (p, element) => p + element);
    totalPurchase = allProfitLossData.map((e) => e.saleDetails.map((e) => e.purchasedAmount).fold(0.0, (p, e) => p + double.parse("${e}"))).fold(0.0, (p, element) => p + element);
    totalSoldAmount = allProfitLossData.map((e) => e.saleDetails.map((e) => e.saleDetailsTotalAmount).fold(0.0, (p, e) => p + double.parse("${e}"))).fold(0.0, (p, element) => p + element);
    totalDiscount = allProfitLossData.map((e) => e.saleMasterTotalDiscountAmount).fold(0.0, (p, e) => p + double.parse("${e}"));

    /// ProfitLossProduct
    final allProfitLossProductData = Provider.of<ProfitLossProductProvider>(context).getProfitLossProductlist;
    var totalSoldQuantity;
    var totalPurchased;
    var totalSAmount;
    var totalProfitLoss;

    /// Total profit
    totalSoldQuantity = allProfitLossProductData.map((e) => e.saleDetailsTotalQuantity).fold(0.0, (p, e) => p + double.parse("${e}"));
    totalPurchased = allProfitLossProductData.map((e) => e.purchasedAmount).fold(0.0, (p, e) => p + double.parse("${e}"));
    totalSAmount = allProfitLossProductData.map((e) => e.saleDetailsTotalAmount).fold(0.0, (p, e) => p + double.parse("${e}"));
    totalProfitLoss = allProfitLossProductData.map((e) => e.profitLoss).fold(0.0, (p, e) => p + double.parse("${e}"));

    ///get OtherIncomeExpense
    final allOtherIncomeExpenseData = Provider.of<OtherIncomeExpenseProvider>(context).allOtherIncomeExpenselist;

    return Scaffold(
      appBar: const CustomAppBar(title: "Profit & Loss"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: isCustomerListClicked
                    ? 185.0
                    : isProductListClicked
                        ? 185.0
                        : 155.0,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                decoration: BoxDecoration(
                  color: Colors.lightGreen.shade100,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                      color: const Color.fromARGB(255, 7, 125, 180),
                      width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset:
                          Offset(0, 3), // changes the position of the shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 4,
                            child: Text(
                              "Search Type",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 126, 125, 125)),
                            ),
                          ),
                          //
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
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  hint: const Text(
                                    'All',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  dropdownColor: const Color.fromARGB(255, 231,
                                      251, 255), // Not necessary for Option 1
                                  value: _searchType,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _searchType = newValue!;
                                      _selectedCustomer = '';
                                      _selectedProduct = '';

                                      if (_searchType == "By Customer") {
                                        isCustomerListClicked = true;
                                      } else {
                                        _selectedCustomer = "";
                                        isCustomerListClicked = false;
                                      }
                                      if (_searchType == "By Product") {
                                        isProductListClicked = true;
                                      } else {
                                        _selectedProduct = "";
                                        isProductListClicked = false;
                                      }
                                    });
                                  },
                                  items: _searchTypeList.map((location) {
                                    return DropdownMenuItem(
                                      value: location,
                                      child: Text(
                                        maxLines: 1,
                                        location,
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    isCustomerListClicked == true
                        ? Container(
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 4,
                                  child: Text(
                                    "Customer",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 126, 125, 125)),
                                  ),
                                ),
                                const Expanded(flex: 1, child: Text(":")),
                                Expanded(
                                  flex: 11,
                                  child: Container(
                                    height: 30,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    padding: const EdgeInsets.only(left: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 5, 107, 155),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: TypeAheadFormField(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        onChanged: (value) {
                                          if (value == '') {
                                            _selectedCustomer = '';
                                          }
                                        },
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                        controller: _customerController,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.only(bottom: 12),
                                          hintText: 'Select Customer',
                                          suffix: _selectedCustomer == ''
                                              ? null
                                              : GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _customerController.text =
                                                          '';
                                                    });
                                                  },
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 3),
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 14,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return allCustomersData
                                            .where((element) => element
                                                .displayName!
                                                .toLowerCase()
                                                .contains(pattern
                                                    .toString()
                                                    .toLowerCase()))
                                            .take(allCustomersData.length)
                                            .toList();
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            child: Text(
                                              "${suggestion.customerCode}-${suggestion.customerName}--${suggestion.customerAddress}",
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
                                          (CustomerModel suggestion) {
                                        _customerController.text =
                                            suggestion.displayName!;
                                        setState(() {
                                          _selectedCustomer = suggestion
                                              .customerSlNo
                                              .toString();
                                        });
                                      },
                                      onSaved: (value) {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    isProductListClicked == true
                        ? Container(
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 4,
                                  child: Text(
                                    "Product",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 126, 125, 125)),
                                  ),
                                ),
                                const Expanded(flex: 1, child: Text(":")),
                                Expanded(
                                  flex: 11,
                                  child: Container(
                                    height: 30,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    padding: const EdgeInsets.only(left: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 5, 107, 155),
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: TypeAheadFormField(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                              onChanged: (value) {
                                                if (value == '') {
                                                  _selectedProduct = '';
                                                }
                                              },
                                              style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 13,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              controller: _productController,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                hintText: 'Select Product',
                                                hintStyle: const TextStyle(
                                                    fontSize: 13),
                                                suffix: _selectedProduct == ''
                                                    ? null
                                                    : GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _productController
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
                                        return productList
                                            .where((element) => element
                                                .displayText
                                                .toLowerCase()
                                                .contains(pattern
                                                    .toString()
                                                    .toLowerCase()))
                                            .take(productList.length)
                                            .toList();
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return SizedBox(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            child: Text(
                                              suggestion.displayText,
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
                                        _productController.text =
                                            suggestion.displayText;
                                        setState(() {
                                          _selectedProduct =
                                              suggestion.productSlNo;
                                          print(
                                              "dfhsghdfkhgkh $_selectedProduct");
                                        });
                                      },
                                      onSaved: (value) {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          flex: 4,
                          child: Text(
                            "Date From",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: Container(
                            height: 30,
                            child: GestureDetector(
                              onTap: (() {
                                _firstSelectedDate();
                              }),
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(top: 2, left: 5),
                                  filled: true,
                                  fillColor: Colors.white,
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
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        const Expanded(
                          flex: 4,
                          child: Text(
                            "Date To:",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: Container(
                            height: 30,
                            child: GestureDetector(
                              onTap: (() {
                                _secondSelectedDate();
                              }),
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(top: 2, left: 5),
                                  filled: true,
                                  fillColor: Colors.white,
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

                          // if (connectivityResult == ConnectivityResult.mobile ||
                          //     connectivityResult == ConnectivityResult.wifi) {
                            if (_searchType == "All") {
                              AllProfitLossProvider().on();
                              Provider.of<AllProfitLossProvider>(context,
                                      listen: false)
                                  .getAllProfitLoss("", "${backEndFirstDate}",
                                      "${backEndSecondDate}");
                            } else if (_searchType == "By Customer") {
                              AllProfitLossProvider().on();
                              Provider.of<AllProfitLossProvider>(context,
                                      listen: false)
                                  .getAllProfitLoss(
                                      _selectedCustomer,
                                      "${backEndFirstDate}",
                                      "${backEndSecondDate}");
                            } else if (_searchType == "By Product") {
                              ProfitLossProductProvider().on();
                              Provider.of<ProfitLossProductProvider>(context,
                                      listen: false)
                                  .getProfitLossProduct(
                                      _selectedProduct,
                                      "${backEndFirstDate}",
                                      "${backEndSecondDate}");
                            }
                            Provider.of<OtherIncomeExpenseProvider>(context,
                                    listen: false)
                                .getOtherIncomeExpenses(
                              context,
                              _selectedCustomer,
                              "${backEndFirstDate}",
                              "${backEndSecondDate}",
                              _selectedProduct,
                            );
                          // } else {
                          //   Utils.errorSnackBar(
                          //       context, "Please connect with internet");
                          // }
                        },
                        child: Container(
                          height: 35.0,
                          width: 85.0,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 7, 125, 180),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: const Center(
                              child: Text(
                            "Search",
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
            _searchType == "All" || _searchType == "By Customer"
                ? AllProfitLossProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : allProfitLossData.isNotEmpty
                        ? Container(
                            height: MediaQuery.of(context).size.height / 1.43,
                            width: double.infinity,
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DataTable(
                                          headingRowHeight: 25.0,
                                          dataRowMaxHeight: double.infinity,
                                          showCheckboxColumn: true,
                                          border: TableBorder.all(
                                              color: Colors.black54, width: 1),
                                          columns: const [
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text('Invoice'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text('Date'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text('Customer'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child:
                                                          Text('Product Id'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text('Product'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text(
                                                          'Sold Quantity'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text(
                                                          'Purchase Rate'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child: Text(
                                                          'Purchased Total'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child:
                                                          Text('Sold Amount'))),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                  child: Center(
                                                      child:
                                                          Text('Profit/Loss'))),
                                            ),
                                          ],
                                          rows: List.generate(
                                            allProfitLossData.length,
                                            (int index) => DataRow(
                                              cells: <DataCell>[
                                                DataCell(
                                                  Center(
                                                    child: Text(
                                                        "${allProfitLossData[index].saleMasterInvoiceNo}"),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Text(
                                                        "${allProfitLossData[index].saleMasterSaleDate}"),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Text(
                                                        "${allProfitLossData[index].customerName}"),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Column(
                                                        children: List.generate(
                                                            allProfitLossData[
                                                                    index]
                                                                .saleDetails
                                                                .length, (j) {
                                                      return Container(
                                                        child: Center(
                                                          child: Text(
                                                              allProfitLossData[
                                                                      index]
                                                                  .saleDetails[
                                                                      j]
                                                                  .productCode),
                                                        ),
                                                      );
                                                    })),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Column(
                                                        children: List.generate(
                                                            allProfitLossData[
                                                                    index]
                                                                .saleDetails
                                                                .length, (j) {
                                                      return Container(
                                                        child: Center(
                                                          child: Text(
                                                              allProfitLossData[
                                                                      index]
                                                                  .saleDetails[
                                                                      j]
                                                                  .productName),
                                                        ),
                                                      );
                                                    })),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Column(
                                                        children: List.generate(
                                                            allProfitLossData[
                                                                    index]
                                                                .saleDetails
                                                                .length, (j) {
                                                      return Container(
                                                        child: Center(
                                                          child: Text(
                                                              allProfitLossData[
                                                                      index]
                                                                  .saleDetails[
                                                                      j]
                                                                  .saleDetailsTotalQuantity),
                                                        ),
                                                      );
                                                    })),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Column(
                                                        children: List.generate(
                                                            allProfitLossData[
                                                                    index]
                                                                .saleDetails
                                                                .length, (j) {
                                                      return Container(
                                                        child: Center(
                                                          child: Text(
                                                              allProfitLossData[
                                                                      index]
                                                                  .saleDetails[
                                                                      j]
                                                                  .purchaseRate),
                                                        ),
                                                      );
                                                    })),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Column(
                                                        children: List.generate(
                                                            allProfitLossData[
                                                                    index]
                                                                .saleDetails
                                                                .length, (j) {
                                                      return Container(
                                                        child: Center(
                                                            child: Text(double.parse(
                                                                    allProfitLossData[
                                                                            index]
                                                                        .saleDetails[
                                                                            j]
                                                                        .purchasedAmount)
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
                                                            allProfitLossData[
                                                                    index]
                                                                .saleDetails
                                                                .length, (j) {
                                                      return Container(
                                                        child: Center(
                                                          child: Text(
                                                              allProfitLossData[
                                                                      index]
                                                                  .saleDetails[
                                                                      j]
                                                                  .saleDetailsTotalAmount),
                                                        ),
                                                      );
                                                    })),
                                                  ),
                                                ),
                                                DataCell(
                                                  Center(
                                                    child: Column(
                                                        children: List.generate(
                                                            allProfitLossData[
                                                                    index]
                                                                .saleDetails
                                                                .length, (j) {
                                                      return Container(
                                                        child: Center(
                                                          child: Text(double.parse(
                                                                  allProfitLossData[
                                                                          index]
                                                                      .saleDetails[
                                                                          j]
                                                                      .profitLoss)
                                                              .toStringAsFixed(
                                                                  2)),
                                                        ),
                                                      );
                                                    })),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0.0, bottom: 5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Total Purchased                :    ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    double.parse(
                                                            "${totalPurchase}")
                                                        .toStringAsFixed(2),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black87,
                                                        fontSize: 13.0),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Total Sold Amount            :    ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    "${totalSoldAmount}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black87,
                                                        fontSize: 13.0),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Total Profit/Loss               :    ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    ("${totalPofitLoss}"),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black87,
                                                        fontSize: 13.0),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Total Discount                   :    ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    "${totalDiscount}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black87,
                                                        fontSize: 13.0),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 300,
                                          height: 180.0,
                                          child: ListView.builder(
                                              itemCount: 5,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Container(
                                                    height: 30,
                                                    child: index == 0
                                                        ? Row(
                                                            children: [
                                                              const Text(
                                                                "Other Income (+)               :    ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                              Text(
                                                                "${allOtherIncomeExpenseData?.income}",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black87,
                                                                    fontSize:
                                                                        13.0),
                                                              ),
                                                            ],
                                                          )
                                                        : index == 1
                                                            ? Row(
                                                                children: [
                                                                  const Text(
                                                                    "Total Returned Value (-)   :    ",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                  Text(
                                                                      "${allOtherIncomeExpenseData?.returnedAmount}",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color: Colors
                                                                              .black87,
                                                                          fontSize:
                                                                              13.0)),
                                                                ],
                                                              )
                                                            : index == 2
                                                                ? Row(
                                                                    children: [
                                                                      const Text(
                                                                        "Total Damaged (-)             :    ",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 14),
                                                                      ),
                                                                      Text(
                                                                          "${allOtherIncomeExpenseData?.damagedAmount}",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black87,
                                                                              fontSize: 13.0)),
                                                                    ],
                                                                  )
                                                                : index == 3
                                                                    ? Row(
                                                                        children: [
                                                                          const Text(
                                                                            "Cash Transaction (-)	        :    ",
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                                          ),
                                                                          Text(
                                                                              "${allOtherIncomeExpenseData?.expense}",
                                                                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87, fontSize: 13.0)),
                                                                        ],
                                                                      )
                                                                    : Row(
                                                                        children: [
                                                                          const Text(
                                                                            "Employee Payment (-)	     :   ",
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                                          ),
                                                                          Text(
                                                                            "${allOtherIncomeExpenseData?.employeePayment}",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Colors.black87,
                                                                                fontSize: 13.0),
                                                                          ),
                                                                        ],
                                                                      ));
                                              }),
                                        )
                                      ],
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
                                style:
                                    TextStyle(fontSize: 16, color: Colors.red),
                              ),
                            ))
                : _searchType == "By Product"
                    ? ProfitLossProductProvider.isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : allProfitLossProductData.isNotEmpty
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height / 1.43,
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            DataTable(
                                              headingRowHeight: 25.0,
                                              dataRowHeight: 20.0,
                                              showCheckboxColumn: true,
                                              border: TableBorder.all(
                                                  color: Colors.black54,
                                                  width: 1),
                                              columns: const [
                                                DataColumn(
                                                  label: Expanded(
                                                      child: Center(
                                                          child: Text('Date'))),
                                                ),
                                                DataColumn(
                                                  label: Expanded(
                                                      child: Center(
                                                          child:
                                                              Text('Invoice'))),
                                                ),
                                                DataColumn(
                                                  label: Expanded(
                                                      child: Center(
                                                          child: Text(
                                                              'Product Id'))),
                                                ),
                                                DataColumn(
                                                  label: Expanded(
                                                      child: Center(
                                                          child:
                                                              Text('Product'))),
                                                ),
                                                DataColumn(
                                                  label: Expanded(
                                                      child: Center(
                                                          child: Text(
                                                              'Sold Quantity'))),
                                                ),
                                                DataColumn(
                                                  label: Expanded(
                                                      child: Center(
                                                          child: Text(
                                                              'Purchase Rate'))),
                                                ),
                                                DataColumn(
                                                  label: Expanded(
                                                      child: Center(
                                                          child: Text(
                                                              'Purchased Total'))),
                                                ),
                                                DataColumn(
                                                  label: Expanded(
                                                      child: Center(
                                                          child: Text(
                                                              'Sold Amount'))),
                                                ),
                                                DataColumn(
                                                  label: Expanded(
                                                      child: Center(
                                                          child: Text(
                                                              'Profit/Loss'))),
                                                ),
                                              ],
                                              rows: List.generate(
                                                allProfitLossProductData.length,
                                                (int index) => DataRow(
                                                  cells: <DataCell>[
                                                    DataCell(
                                                      Center(
                                                        child: Text(
                                                            "${allProfitLossProductData[index].saleMasterSaleDate}"),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                        child: Text(
                                                            "${allProfitLossProductData[index].saleMasterInvoiceNo}"),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                        child: Text(
                                                            "${allProfitLossProductData[index].productCode}"),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                        child: Text(
                                                            "${allProfitLossProductData[index].productName}"),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                        child: Text(
                                                            "${allProfitLossProductData[index].saleDetailsTotalQuantity}"),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                        child: Text(
                                                            "${allProfitLossProductData[index].purchaseRate}"),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                        child: Text(
                                                            "${allProfitLossProductData[index].purchasedAmount}"),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                        child: Text(
                                                            "${allProfitLossProductData[index].saleDetailsTotalAmount}"),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                        child: Text(
                                                            "${allProfitLossProductData[index].profitLoss}"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10.0),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0, bottom: 5.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Total Sold Quantity       :   ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        double.parse(
                                                                "${totalSoldQuantity}")
                                                            .toStringAsFixed(2),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 13.0),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Total Purchased            :   ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        ("${totalPurchased}"),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 13.0),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Total Sold Amount        :    ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        "${totalSAmount}",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 13.0),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Total Profit/Loss           :    ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        "${totalProfitLoss}",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 13.0),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Align(
                                alignment: Alignment.center,
                                child: Center(
                                  child: Text(
                                    "No Data Found",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.red),
                                  ),
                                ))
                    : Container()
          ],
        ),
      ),
    );
  }
}
