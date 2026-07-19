//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/customer_payment_provider.dart';
import 'package:kbtradlink/provider/customer_provider.dart';
import 'package:kbtradlink/screen/administation_module/model/customer_model.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:provider/provider.dart';

class CustomerPaymentHistory extends StatefulWidget {
  const CustomerPaymentHistory({super.key});

  @override
  State<CustomerPaymentHistory> createState() => _CustomerPaymentHistoryState();
}

class _CustomerPaymentHistoryState extends State<CustomerPaymentHistory> {
  final customerController = TextEditingController();
  bool isAllPaymentTypeClicked = false;
  bool isReceivedPaymentTypeClicked = false;
  bool isPaidPaymentTypeClicked = false;
  bool isCategoryWiseClicked = false;
  bool isProductWiseClicked = false;
  double thFontSize = 10.0;
  String data = '';
  String data2 = '';
  bool isSecondCaregory = false;
  bool isFirstCaregory = false;

  final List<String> _category = [
    'All',
    'Received',
    'Paid',
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
        backEndSecondDate = Utils.formatBackEndDate(selectedDate);
        print("First Selected date $secondPickedDate");
      });
    } else {
      setState(() {
        secondPickedDate = Utils.formatFrontEndDate(toDay);
        backEndSecondDate = Utils.formatBackEndDate(toDay);
        print("First Selected date $secondPickedDate");
      });
    }
  }

  String? _selectedCustomer;
  String? _selectedPaymentType = 'All';
  String customerId = "";
  String paymentType = "";
  @override
  void initState() {
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    backEndSecondDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    Provider.of<CustomerListProvider>(context, listen: false)
        .getCustomerList(context,customerType: "");
    Provider.of<CustomerPaymentProvider>(context, listen: false).customerPaymentList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allCustomerData=Provider.of<CustomerListProvider>(context).customerList.where((element) => element.displayName!="General Customer").toList();
    final allCustomerPaymentData=Provider.of<CustomerPaymentProvider>(context).customerPaymentList;
    final data = Provider.of<CustomerPaymentProvider>(context).customerPaymentList.fold(0.0, (p, e) => p + double.parse(e.cPaymentAmount));

    print('aksljfhk $data');

    return Scaffold(
      appBar: const CustomAppBar(title: "Customer Payment History"),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Container(
              // margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.only(left: 4.0, right: 4.0,bottom: 4.0),
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
                          flex: 3,
                          child: Text(
                            "Customer         :",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            margin: const EdgeInsets.only(top:5,bottom: 5),
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
                                return allCustomerData
                                    .where((element) => element
                                    .displayName!
                                    .toLowerCase()
                                    .contains(pattern
                                    .toString()
                                    .toLowerCase()))
                                    .take(allCustomerData.length)
                                    .toList();
                                // return placesSearchResult.where((element) => element.name.toLowerCase().contains(pattern.toString().toLowerCase())).take(10).toList();
                              },
                              itemBuilder: (context, suggestion) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: Text(
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
                                  //customerSlNo = suggestion.customerSlNo.toString();
                                  print("customer selected ======> $_selectedCustomer");

                                });
                              },
                              onSaved: (value) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            "Payment Type :",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 2),
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
                                  'Please select a payment type',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ), // Not necessary for Option 1
                                value: _selectedPaymentType,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedPaymentType = newValue.toString();
                                    _selectedPaymentType == 'Paid'
                                        ? paymentType = 'paid'
                                        : _selectedPaymentType == 'Received'
                                        ? paymentType = "received"
                                        : _selectedPaymentType == 'All'
                                        ? paymentType = ""
                                        : paymentType = "";
                                    print("Payment Type: $paymentType");
                                  });
                                },
                                items: _category.map((location) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      location,
                                      style: const TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                    value: location,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(
                                right: 5,bottom: 5),
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
                        const Text("To"),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin:
                            const EdgeInsets.only(left: 5,bottom: 5),
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
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () async {
                        //final connectivityResult = await (Connectivity().checkConnectivity());

                        if(customerController.text != ''){
                          // if (connectivityResult == ConnectivityResult.mobile
                          //     || connectivityResult == ConnectivityResult.wifi) {
                            setState(() {
                              CustomerPaymentProvider().on();
                            });
                            Provider.of<CustomerPaymentProvider>(context,
                                    listen: false)
                                .getAllCustomerPayment(
                                    "${_selectedCustomer}",
                                    "${backEndFirstDate}",
                                    "${backEndSecondDate}",
                                    "${paymentType}");
                          // }
                          // else{
                          //   Utils.errorSnackBar(context, "Please connect with internet");
                          // }
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              backgroundColor: Colors.black,
                              content: Center(child: Text("Please Select Customer",style: TextStyle(color: Colors.red),))));
                        }

                      },
                      child: Container(
                        height: 32.0,
                        width: 105.0,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 4, 113, 185),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Center(
                            child: Text(
                              "Show Report",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w400),
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2.0,)
                ],
              ),
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 92, 90, 90),
          ),
          CustomerPaymentProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : allCustomerPaymentData.isNotEmpty?
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.31,
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
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
                              label:
                              Expanded(child: Center(child: Text('Transaction Id'))),
                            ),
                            DataColumn(
                              label: Expanded(child: Center(child: Text('Date'))),
                            ),
                            DataColumn(
                              label: Expanded(child: Center(child: Text('Customer'))),
                            ),
                            DataColumn(
                              label:
                              Expanded(child: Center(child: Text('Transaction Type'))),
                            ),
                            DataColumn(
                              label: Expanded(child: Center(child: Text('Payment by'))),
                            ),
                            DataColumn(
                              label: Expanded(child: Center(child: Text('Amount'))),
                            ),
                          ],
                          rows: List.generate(
                            allCustomerPaymentData.length,
                                (int index) => DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Center(
                                      child: Text(
                                          allCustomerPaymentData[
                                          index]
                                              .cPaymentInvoice
                                              .toString())),
                                ),
                                DataCell(
                                  Center(
                                      child: Text(
                                          allCustomerPaymentData[
                                          index]
                                              .cPaymentDate
                                              .toString())),
                                ),
                                DataCell(
                                  Center(
                                      child: Text(
                                          "${allCustomerPaymentData[index].customerCode.toString()} - " + allCustomerPaymentData[
                                          index]
                                              .customerName
                                              .toString())),
                                ),
                                DataCell(
                                  Center(
                                      child: Text(
                                          allCustomerPaymentData[
                                          index]
                                              .transactionType
                                              .toString())),
                                ),
                                DataCell(
                                  Center(
                                      child: Text(
                                          allCustomerPaymentData[
                                          index]
                                              .paymentBy
                                              .toString())),
                                ),
                                DataCell(
                                  Center(
                                      child: Text(
                                          allCustomerPaymentData[
                                          index]
                                              .cPaymentAmount
                                              .toString())),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: paymentType =='' ? Text('') : Row(
                            children: [
                              const Text(//111111
                                "Total Amount        :      ",
                                style: TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: 14),
                              ),
                              allCustomerPaymentData
                                  .length ==
                                  0
                                  ? const Text(
                                "0",
                                style: TextStyle(
                                    fontSize: 14),
                              )
                                  : Text(
                                "$data",
                                style: const TextStyle(
                                    fontSize: 14),
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
    );
  }
}
