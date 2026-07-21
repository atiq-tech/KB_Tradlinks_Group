import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/bank_account_provider.dart';
import 'package:kbtradlink/provider/customer_provider.dart';
import 'package:kbtradlink/provider/customer_payment_provider.dart';
import 'package:kbtradlink/screen/acount_module/model/bank_account_model.dart';
import 'package:kbtradlink/screen/administation_module/model/customer_model.dart';
import 'package:kbtradlink/utils/const_page.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerPaymentPage extends StatefulWidget {
  const CustomerPaymentPage({super.key});
  @override
  State<CustomerPaymentPage> createState() => _CustomerPaymentPageState();
}

class _CustomerPaymentPageState extends State<CustomerPaymentPage> {

  final TextEditingController dueController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController customerController = TextEditingController();

  final TextEditingController accountController = TextEditingController();

  String? firstPickedDate;

  bool customerEntryBtnClk = false;

  var backEndFirstDate;
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
        CustomerPaymentProvider().on();
        Provider.of<CustomerPaymentProvider>(context, listen: false).getAllCustomerPayment("","${backEndFirstDate}","${backEndFirstDate}","");
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

  String? getTransactionType;
  String? _transactionType = "Receive";
  final List<String> _transactionTypeList = [
    'Receive',
    'Payment',
  ];

  bool isBankListClicked = false;
  String? getPaymentType;
  String? _paymentType = 'Cash';
  String? _selectedAccount;

  final List<String> _paymentTypeList = [
    'Cash',
    'Bank',
  ];
  String? _selectedCustomer;
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

  @override
  void initState() {
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    getTransactionType = "CR";
    getPaymentType = "cash";

    CustomerPaymentProvider.isLoading = true;
    Provider.of<CustomerPaymentProvider>(context, listen: false).customerPaymentList = [];
    Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context,customerType: '');
    Provider.of<CustomerPaymentProvider>(context, listen: false).getAllCustomerPayment("","${Utils.formatBackEndDate(DateTime.now())}","${Utils.formatBackEndDate(DateTime.now())}","");

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mainScrollController.addListener(mainScrollListener);
    final allCustomersData = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.displayName!="General Customer");
    final allGetCustomerPaymentData = Provider.of<CustomerPaymentProvider>(context).customerPaymentList;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(
        title: "Customer Payment",
      ),
      body: SingleChildScrollView(
        controller: mainScrollController,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
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

                                      if (newValue == "Cash") {
                                        getPaymentType = "cash";
                                      }
                                      if (newValue == "Bank") {
                                        getPaymentType = "bank";
                                      }
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
                    const SizedBox(height: 4.0),
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
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            contentPadding: const EdgeInsets.only(bottom: 11.5),
                                            hintText: 'Select Account',
                                            suffix: _selectedAccount == '' ? null : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  accountController.text = '';
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
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            "Customer",
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
                                  contentPadding: const EdgeInsets.only(bottom: 11.5),
                                  hintText: 'Select Customer',
                                  suffix: _selectedCustomer == '' ? null : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        customerController.text = '';
                                      });
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: Icon(Icons.close,size: 14),
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
                                //   ListTile(
                                //   title: SizedBox(child: Text("${suggestion.displayName}",style: const TextStyle(fontSize: 12), maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                // );
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
                                previousDueAmount(_selectedCustomer);
                                },
                              onSaved: (value) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                   const SizedBox(height: 5.0),
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
                              controller: dueController,
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
                              top: 5,
                              bottom: 5,
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
                              controller: descriptionController,
                              decoration: InputDecoration(
                                filled: true,
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
                              controller: amountController,
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
                        GestureDetector(
                          onTap: () {

                            if(customerController.text==''){
                              Utils.errorSnackBar(context, "Customer is required");
                            }
                            else if(amountController.text==''){
                              Utils.errorSnackBar(context, "Amount is required");
                            }
                            else{
                              setState(() {
                                customerEntryBtnClk = true;
                              });
                              Utils.closeKeyBoard(context);
                               getApiAllAddCustomerPayment(
                                context,
                                "$_paymentType",
                                "$getTransactionType",
                                amountController.text,
                                "$_selectedCustomer",
                                "$backEndFirstDate",
                                0,
                                descriptionController.text,
                                dueController.text,
                                "$_selectedAccount",
                              ).then((value){
                                if(value=="true"){
                                  setState(() {
                                    customerEntryBtnClk = false;
                                  });
                                  descriptionController.text = "";
                                  customerController.text = '';
                                  amountController.text = "";
                                  Provider.of<CustomerPaymentProvider>(context, listen: false).getAllCustomerPayment("","${Utils.formatBackEndDate(DateTime.now())}","${Utils.formatBackEndDate(DateTime.now())}","");
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
                                child: customerEntryBtnClk ? const SizedBox(height: 20,width:20,child: CircularProgressIndicator(color: Colors.white,)) : const Text(
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
                            descriptionController.text = "";
                            customerController.text = '';
                            amountController.text = "";
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
            CustomerPaymentProvider.isLoading ?
                Center(child: CircularProgressIndicator(),):
            Container(
              height: MediaQuery.of(context).size.height / 1.43,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: allGetCustomerPaymentData.isNotEmpty
                  ? SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  controller: _listViewScrollController,
                  physics: _physics,
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
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
                            label: Expanded(child: Center(child: Text('Customer'))),
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
                          allGetCustomerPaymentData.length > 100 ? 100 : allGetCustomerPaymentData.length,
                              (int index) => DataRow(
                            cells: <DataCell>[
                              DataCell(
                                Center(
                                    child: Text(
                                        allGetCustomerPaymentData[index].cPaymentInvoice)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allGetCustomerPaymentData[index].cPaymentDate)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allGetCustomerPaymentData[index].customerName)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allGetCustomerPaymentData[index].transactionType)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allGetCustomerPaymentData[index].paymentBy)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allGetCustomerPaymentData[index].cPaymentAmount)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allGetCustomerPaymentData[index].cPaymentNotes)),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        allGetCustomerPaymentData[index].cPaymentAddby)),
                              ),
                            ],
                          ),
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

  Future<String>getApiAllAddCustomerPayment(
      context,
      String? cpaymentPaymentby,
      String? cpaymentTransactiontype,
      String? cpaymentAmount,
      String? cpaymentCustomerid,
      String? cpaymentDate,
      int? cpaymentId,
      String? cpaymentNotes,
      String? cpaymentPreviousDue,
      String? accountId,
      ) async {
    String Link = "${baseUrl}api/v1/addCustomerPayment";
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(Link,
          data: {
            "CPayment_Paymentby": "$cpaymentPaymentby",
            "CPayment_TransactionType": "$cpaymentTransactiontype",
            "CPayment_amount": "$cpaymentAmount",
            "CPayment_customerID": "$cpaymentCustomerid",
            "CPayment_date": "$cpaymentDate",
            "CPayment_id":cpaymentId,
            "CPayment_notes": "$cpaymentNotes",
            "CPayment_previous_due": "$cpaymentPreviousDue",
            "account_id": "$accountId"
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));

      var data = jsonDecode(response.data);
      if(data['success'] == true){
        // isBtnClkkk = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 1),
            content: Center(child: Text("${data["message"]}",style: const TextStyle(color: Colors.white),))));
        setState(() {
          customerEntryBtnClk = false;
        });
        return "true";
      }else{
        // isBtnClkkk = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 1),
            content: Center(child: Text("${data["message"]}",style: const TextStyle(color: Colors.red),))));
        setState(() {
          customerEntryBtnClk = false;
        });
        return "";
      }
    } catch (e) {
      print("Something is wrong AAAAdd CCCCustomer PPPayment=======:$e");
      // isBtnClkkk = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 1),
          content: Center(child: Text(e.toString(),style: const TextStyle(color: Colors.red),))));
      setState(() {
        customerEntryBtnClk = false;
      });
      return "";
    }
  }

  Response? result;
  void previousDueAmount(String? customerId) async {
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
        dueController.text = "${data[0]['dueAmount']}";
      });
    }
  }

}