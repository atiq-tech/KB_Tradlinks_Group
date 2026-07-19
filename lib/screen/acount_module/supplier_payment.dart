import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/bank_account_provider.dart';
import 'package:kbtradlink/provider/supplier_payment_provider.dart';
import 'package:kbtradlink/provider/supplier_provider.dart';
import 'package:kbtradlink/screen/acount_module/model/bank_account_model.dart';
import 'package:kbtradlink/screen/administation_module/model/supplier_model.dart';
import 'package:kbtradlink/utils/const_page.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupplierPaymentPage extends StatefulWidget {
  const SupplierPaymentPage({super.key});

  @override
  State<SupplierPaymentPage> createState() => _SupplierPaymentPageState();
}

class _SupplierPaymentPageState extends State<SupplierPaymentPage> {

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController dueCtrl = TextEditingController();
  //
  String? firstPickedDate;
  String? backEndFirstDate;

  String? _selectedAccount;
  final TextEditingController accountController = TextEditingController();

  var toDay = DateTime.now();
  bool isLoading = false;


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
        SupplierPaymentProvider().on();
        Provider.of<SupplierPaymentProvider>(context,listen: false).getAllSupplierPayment("${backEndFirstDate}","${backEndFirstDate}");

      });
    }
    else{
      setState(() {
        firstPickedDate = Utils.formatFrontEndDate(toDay);
        backEndFirstDate = Utils.formatBackEndDate(toDay);
      });
    }
  }

  String? getTransactionType;
  String? _transactionType = 'Receive';
  final List<String> _transactionTypeList = [
    'Receive',
    'Payment',
  ];
  bool isBankListClicked = false;
  String? _paymentType = 'Cash';
  final List<String> _paymentTypeList = [
    'Cash',
    'Bank',
  ];
  String? _selectedSupplier;
  ScrollController mainScrollController = ScrollController();
  late final ScrollController _listViewScrollController = ScrollController()
    ..addListener(listViewScrollListener);
  ScrollPhysics _physics = const ScrollPhysics();

  void listViewScrollListener() {
    
    if (_listViewScrollController.offset >=
        _listViewScrollController.position.maxScrollExtent &&
        !_listViewScrollController.position.outOfRange) {
      if (mainScrollController.offset == 0) {
        mainScrollController.animateTo(50,
            duration: const Duration(milliseconds: 200), curve: Curves.linear);
      }
      setState(() {
        _physics = const NeverScrollableScrollPhysics();
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
          _physics = const ScrollPhysics();

          _listViewScrollController.animateTo(
              _listViewScrollController.position.maxScrollExtent - 50,
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear);
        }
      });
      print("top");
    }
  }

  @override
  void initState() {
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    getTransactionType = 'CR';

    SupplierPaymentProvider.isLoading = true;
    Provider.of<SupplierPaymentProvider>(context,listen: false).supplierPaymentList = [];
    Provider.of<SupplierProvider>(context,listen: false).getSupplierList();
    Provider.of<SupplierPaymentProvider>(context,listen: false).getAllSupplierPayment("${Utils.formatBackEndDate(DateTime.now())}","${Utils.formatBackEndDate(DateTime.now())}");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mainScrollController.addListener(mainScrollListener);
    //bank accounts
    final allSuppliersList = Provider.of<SupplierProvider>(context).supplierList;

    //Get Supplier Payment
    final allSupplierPaymentList = Provider.of<SupplierPaymentProvider>(context).supplierPaymentList;

     return Scaffold(
      appBar: const CustomAppBar(title: "Supplier Payment"),
      body: SingleChildScrollView(
        controller: mainScrollController,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0,bottom: 4.0),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
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
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            "Transaction Type",
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
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: const Text(
                                  'Select Type',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                dropdownColor: const Color.fromARGB(255, 231, 251,
                                    255), // Not necessary for Option 1
                                value: _transactionType,
                                onChanged: (newValue) {
                                  setState(() {
                                    _transactionType = newValue!;
                                    if (newValue == "Receive") {
                                      getTransactionType = "CR";
                                    }
                                    if (newValue == "Payment") {
                                      getTransactionType = "CP";
                                    }
                                  });
                                },
                                items: _transactionTypeList.map((location) {
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
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Container(
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 6,
                            child: Text(
                              "Payment Type",
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
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  hint: const Text(
                                    'Select Type',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  dropdownColor: const Color.fromARGB(255, 231, 251,
                                      255), // Not necessary for Option 1
                                  value: _paymentType,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _paymentType = newValue!;
                                      _paymentType == "Bank"
                                          ? isBankListClicked = true
                                          : isBankListClicked = false;
                                    });
                                  },
                                  items: _paymentTypeList.map((location) {
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
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    isBankListClicked == true
                        ? Container(
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 6,
                            child: Text(
                              "Bank Account",
                              style: TextStyle(
                                  color: Color.fromARGB(
                                      255, 126, 125, 125)),
                            ),
                          ),
                          const Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 11,
                            child: Container(
                              height: 30.0,
                              width:
                              MediaQuery.of(context).size.width / 2,
                              padding: const EdgeInsets.only(left: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color:
                                  const Color.fromARGB(255, 5, 107, 155),
                                ),
                                borderRadius:
                                BorderRadius.circular(10.0),
                              ),
                              child: FutureBuilder(
                                future: Provider.of<BankAccountProvider>(context).getBankAccountList(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return TypeAheadFormField(
                                      textFieldConfiguration:
                                      TextFieldConfiguration(
                                          onChanged: (value){
                                            if (value == '') {
                                              _selectedAccount = '';
                                            }
                                          },
                                          style: const TextStyle(
                                            fontSize: 13,
                                          ),
                                          controller: accountController,
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.only(bottom: 12),
                                            hintText: 'Select Account',
                                            suffix: _selectedAccount == '' ? null : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  accountController.text = '';
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
                                        return snapshot.data!
                                            .where((element) => element.accountName
                                            .toLowerCase()
                                            .contains(pattern
                                            .toString()
                                            .toLowerCase()))
                                            .take(snapshot.data!.length)
                                            .toList();
                                        // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                            child: Text(
                                              "${suggestion.accountName} - ${suggestion.accountNumber} - ${suggestion.bankName}",
                                              style: const TextStyle(fontSize: 12),
                                              maxLines: 1,overflow: TextOverflow.ellipsis,),
                                          ),
                                        );
                                        //   ListTile(
                                        //   title: SizedBox(child: Text("${suggestion.accountName} - ${suggestion.accountNumber} (${suggestion.bankName})",style: const TextStyle(fontSize: 11), maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                        // );
                                      },
                                      transitionBuilder:
                                          (context, suggestionsBox, controller) {
                                        return suggestionsBox;
                                      },
                                      onSuggestionSelected:
                                          (BankAccountModel suggestion) {
                                        accountController.text = "${suggestion.accountName}-${suggestion.accountNumber} (${suggestion.bankName})";
                                        setState(() {
                                          _selectedAccount = suggestion.accountId.toString();
                                        });
                                      },
                                      onSaved: (value) {},
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        : Container(),
                    const SizedBox(height: 3.0),
                    Row(
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            "Supplier",
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
                                      _selectedSupplier = '';
                                    }
                                  },
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                  controller: supplierController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(bottom: 12),
                                    hintText: 'Select Supplier',
                                    suffix: _selectedSupplier == '' ? null : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          supplierController.text = '';
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
                                allSuppliersList.removeAt(0);
                                return allSuppliersList
                                    .where((element) => element.supplierName.toString()
                                    .toLowerCase()
                                    .contains(pattern
                                    .toString()
                                    .toLowerCase()))
                                    .take(allSuppliersList.length)
                                    .toList();
                                // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                              },
                              itemBuilder: (context, suggestion) {
                                return SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                    child: Text(
                                      "${suggestion.supplierCode} - ${suggestion.supplierName}",
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 1,overflow: TextOverflow.ellipsis,),
                                  ),
                                );
                                //   ListTile(
                                //   title: SizedBox(child: Text("${suggestion.supplierName}",style: const TextStyle(fontSize: 12), maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                // );
                              },
                              transitionBuilder:
                                  (context, suggestionsBox, controller) {
                                return suggestionsBox;
                              },
                              onSuggestionSelected:
                                  (SupplierModel suggestion) {
                                supplierController.text = suggestion.supplierName!;
                                setState(() {
                                  _selectedSupplier =
                                      suggestion.supplierSlNo;
                                  print(
                                      "Customer Wise Category ID ========== > ${suggestion.supplierSlNo} ");
                                });
                                previousDueAmount(_selectedSupplier);
                              },
                              onSaved: (value) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    Row(
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            "Due",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: SizedBox(
                            height:30.0,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: const TextStyle(fontSize: 13),
                              controller: dueCtrl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "0",
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 5.0),
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
                          flex: 6,
                          child: Text(
                            "Payment Date",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 3,
                              bottom: 3,
                            ),
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: const Color.fromARGB(255, 7, 125, 180))),
                            child: GestureDetector(
                              onTap: (() {
                                _firstSelectedDate();
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
                    Row(
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            "Description",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: SizedBox(
                            height: 30.0,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: const TextStyle(fontSize: 13),
                              controller: _descriptionController,
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
                    const SizedBox(height: 3.0),
                    Row(
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            "Amount",
                            style: TextStyle(
                                color: Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: SizedBox(
                            height:30.0,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              style: const TextStyle(fontSize: 13),
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "0",
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 5.0),
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            if(supplierController.text==''){
                              Utils.errorSnackBar(context, "Supplier is required");
                            }
                            else if( _amountController.text==''){
                              Utils.errorSnackBar(context, "Amount is required");
                            }
                            else{
                              setState(() {
                                isLoading = true;
                              });

                              getApiAllAddSupplierPayment(
                                context,
                                "$_paymentType",
                                "$getTransactionType",
                                _amountController.text,
                                "$_selectedSupplier",
                                "$backEndFirstDate",
                                0,
                                _descriptionController.text,
                                "$_selectedAccount",
                              ).then((value){
                                if(value=='true'){
                                  setState(() {
                                    isLoading = false;
                                  });
                                  _descriptionController.text = "";
                                  supplierController.text = '';
                                  _amountController.text = "";
                                  Provider.of<SupplierPaymentProvider>(context,listen: false).getAllSupplierPayment("${Utils.formatBackEndDate(DateTime.now())}","${Utils.formatBackEndDate(DateTime.now())}");
                                  setState(() {

                                  });
                                }
                              });
                            }
                          },
                          child: Container(
                            height: 35.0,
                            width: 85.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromARGB(255, 88, 204, 91),
                                  width: 2.0),
                              color: const Color.fromARGB(255, 5, 114, 165),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.6),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3), // changes the position of the shadow
                                ),
                              ],
                            ),
                            child: Center(
                                child: isLoading ? const SizedBox(height: 20,width:20,child: CircularProgressIndicator(color: Colors.white,)) : const Text(
                                  "SAVE",
                                  style: TextStyle(
                                      letterSpacing: 1.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        InkWell(
                          onTap: () {
                            _descriptionController.text = "";
                            supplierController.text = '';
                            _amountController.text = "";
                          },
                          child: Container(
                            height: 35.0,
                            width: 85.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromARGB(255, 88, 204, 91),
                                  width: 2.0),
                              color: const Color.fromARGB(255, 252, 33, 4),
                              borderRadius: BorderRadius.circular(10.0),
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
                                  "CANCEL",
                                  style: TextStyle(
                                      letterSpacing: 1.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 2.0),
            SupplierPaymentProvider.isLoading
                ? const Center(child: CircularProgressIndicator(),)
                : Container(
              height: MediaQuery.of(context).size.height / 1.43,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: allSupplierPaymentList.isNotEmpty
                  ? SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  controller: _listViewScrollController,
                  physics: _physics,
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowHeight: 20.0,
                      dataRowHeight: 20.0,
                      showCheckboxColumn: true,
                      border:
                      TableBorder.all(color: Colors.black54, width: 1),
                      columns: const [
                        DataColumn(
                          label: Expanded(child: Center(child: Text('Transaction Id'))),
                        ),
                        DataColumn(
                          label: Expanded(child: Center(child: Text('Date'))),
                        ),
                        DataColumn(
                          label: Expanded(child: Center(child: Text('Supplier'))),
                        ),
                        DataColumn(
                          label: Expanded(child: Center(child: Text('Transaction Type'))),
                        ),
                        DataColumn(
                          label: Expanded(child: Center(child: Text('Payment by'))),
                        ),
                        DataColumn(
                          label: Expanded(child: Center(child: Text('Amount'))),
                        ),
                        DataColumn(
                          label: Expanded(child: Center(child: Text('Description'))),
                        ),
                        DataColumn(
                          label: Expanded(child: Center(child: Text('Save By'))),
                        ),
                      ],
                      rows: List.generate(
                        allSupplierPaymentList.length > 100 ? 100 : allSupplierPaymentList.length,
                            (int index) => DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Center(
                                  child: Text(
                                      '${allSupplierPaymentList[index].sPaymentInvoice}')),
                            ),
                            DataCell(
                              Center(
                                  child: Text(
                                      '${allSupplierPaymentList[index].sPaymentDate}')),
                            ),
                            DataCell(
                              Center(
                                  child: Text(
                                      '${allSupplierPaymentList[index].supplierName}')),
                            ),
                            DataCell(
                              Center(
                                  child: Text(
                                      '${allSupplierPaymentList[index].transactionType}')),
                            ),
                            DataCell(
                              Center(
                                  child: Text(
                                      '${allSupplierPaymentList[index].paymentBy}')),
                            ),
                            DataCell(
                              Center(
                                  child: Text(
                                      '${allSupplierPaymentList[index].sPaymentAmount}')),
                            ),
                            DataCell(
                              Center(
                                  child: Text(
                                      '${allSupplierPaymentList[index].sPaymentNotes}')),
                            ),
                            DataCell(
                              Center(
                                  child: Text(
                                      '${allSupplierPaymentList[index].sPaymentAddby}')),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
                  : Text("No Record Found",textAlign: TextAlign.center, style: TextStyle(color: Colors.red.shade600),),
            ),
          ],
        ),
      ),
    );
  }

  Future<String>getApiAllAddSupplierPayment(
      context,
      String? spaymentPaymentby,
      String? spaymentTransactiontype,
      String? spaymentAmount,
      String? spaymentCustomerid,
      String? spaymentDate,
      int? spaymentId,
      String? spaymentNotes,
      String? accountId,
      ) async {
    String Link = "${baseUrl}api/v1/addSupplierPayment";
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(Link,
          data: {
            "SPayment_Paymentby": "$spaymentPaymentby",
            "SPayment_TransactionType": "$spaymentTransactiontype",
            "SPayment_amount": "$spaymentAmount",
            "SPayment_customerID": "$spaymentCustomerid",
            "SPayment_date": "$spaymentDate",
            "SPayment_id": spaymentId,
            "SPayment_notes": "$spaymentNotes",
            "account_id": "$accountId"
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      if(data['success'] == true){
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 1),
            content: Center(child: Text("${data["message"]}",style: const TextStyle(color: Colors.white),))));
        return 'true';
      }else{
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 1),
            content: Center(child: Text("${data["message"]}",style: const TextStyle(color: Colors.red),))));
        return '';
      }

    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Something is wrong AAAAdd Supplier PPPayment=======:$e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 1),
          content: Center(child: Text(e.toString(),style: const TextStyle(color: Colors.red),))));
      return '';
    }
  }


  Response? result;
  void previousDueAmount(String? supplierId) async {
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

    if(data!=null){
      print("responses result========> ${data[0]['due']}");
      setState(() {
        dueCtrl.text = "${data[0]['due']}";
      });
    }
  }

}
