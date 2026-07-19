//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/customer_due_provider.dart';
import 'package:kbtradlink/provider/customer_provider.dart';
import 'package:kbtradlink/screen/administation_module/model/customer_model.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class CustomerDueList extends StatefulWidget {
  const CustomerDueList({super.key});

  @override
  State<CustomerDueList> createState() => _CustomerDueListState();
}

class _CustomerDueListState extends State<CustomerDueList> {
  final TextEditingController customerController = TextEditingController();
  bool isRetailCustomersListClicked = false;
  bool isWholesaleCustomersListClicked = false;
  bool isUnpaidCustomersListClicked = false;
  bool isCustomerListClicked = false;
  String? _searchType = "All";

 final List<String> _searchTypeList = [
    'All',
    'By Retail Customers',
    'By Wholesale Customers',
    'By Unpaid Customers',
  ];
 String? customerType = "";

  String? _selectedCustomer;
  String customerId = "";
  double? dueTotal;

  @override
  void initState() {
    Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context, customerType: "");
    Provider.of<CustomerDueListProvider>(context, listen: false).getCustomerDuelist = [];

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final allCustomersData = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.displayName!="General Customer");
    /*final retailCustomersData = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.displayName!="General Customer").where((element) => element.customerType!="retail");
    final wholesaleCustomersData = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.displayName!="General Customer").where((element) => element.customerType!="wholesale");
    final unpaidCustomersData = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.displayName!="General Customer").where((element) => element.customerType!="unpaid");
    print('asdlfkj1 ${retailCustomersData.length}');
    print('asdlfkj2 ${wholesaleCustomersData.length}');
    print('asdlfkj3 ${unpaidCustomersData.length}');
    print('asdlfkj4 ${allCustomersData.length}');*/
    final allCustomerDueData=Provider.of<CustomerDueListProvider>(context).getCustomerDuelist.where((element) => element.dueAmount != "0.00").toList()..sort((a, b) {
      return a.customerName.toLowerCase().compareTo(b.customerName.toLowerCase());
    });
    dueTotal = allCustomerDueData.map((e) => e.dueAmount).fold(0.0, (p, element) => p!+double.parse(element));
    return Scaffold(
      appBar: const CustomAppBar(title:"Customer due list",),
      body: ModalProgressHUD(
        inAsyncCall: CustomerListProvider.isCustomerTypeChange,
        blur: 2,
        progressIndicator: Utils.showSpinKitLoad(),
        child: Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Column(
              children: [
                Container(
                  height: isRetailCustomersListClicked==true?125.0:
                  isWholesaleCustomersListClicked==true?125.0:
                  isUnpaidCustomersListClicked==true?125.0:
                  isCustomerListClicked==true?125.0:
                  95.0,
                  width: double.infinity,
                  // margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(top:6.6,left: 6.0, right: 6.0,bottom: 6.0),
                  decoration: BoxDecoration(
                    color: const Color(0xffD2D2FF),
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
                    children: [
                      Row(
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
                                  dropdownColor: const Color.fromARGB(255, 231, 251,
                                      255), // Not necessary for Option 1
                                  value: _searchType,
                                  onChanged: (newValue) {
                                      _searchType = newValue!;
                                      setState(() {
                                        CustomerListProvider().on();
                                      });
                                      if(_searchType == "By Retail Customers"){
                                        setState(() {
                                          isRetailCustomersListClicked = true;
                                          isWholesaleCustomersListClicked = false;
                                          isUnpaidCustomersListClicked = false;
                                          isCustomerListClicked = false;
                                        });
                                        customerType = "retail";
                                      }
                                      else if(_searchType == "By Wholesale Customers"){
                                        setState(() {
                                          isRetailCustomersListClicked = false;
                                          isWholesaleCustomersListClicked = true;
                                          isUnpaidCustomersListClicked = false;
                                          isCustomerListClicked = false;
                                        });
                                        customerType = "wholesale";
                                      }
                                      else if(_searchType == "By Unpaid Customers"){
                                        setState(() {
                                          isRetailCustomersListClicked = false;
                                          isWholesaleCustomersListClicked = false;
                                          isUnpaidCustomersListClicked = true;
                                          isCustomerListClicked = false;
                                        });
                                        customerType = "unpaid";
                                      }
                                      // else if(_searchType == "By Customer"){
                                      //   setState(() {
                                      //     isRetailCustomersListClicked = false;
                                      //     isWholesaleCustomersListClicked = false;
                                      //     isUnpaidCustomersListClicked = false;
                                      //     isCustomerlistClicked = true;
                                      //   });
                                      //   customerType = "";
                                      // }
                                      else if(_searchType == "All"){
                                        setState(() {
                                          isRetailCustomersListClicked = false;
                                          isWholesaleCustomersListClicked = false;
                                          isUnpaidCustomersListClicked = false;
                                          isCustomerListClicked = false;
                                        });
                                        customerType = "";
                                      }
                                      customerId = "";
                                      customerController.text = '';
                                      Provider.of<CustomerListProvider>(context, listen: false).getCustomerList(context, customerType: customerType);
                                  },
                                  items: _searchTypeList.map((location) {
                                    return DropdownMenuItem(
                                      value: location,
                                      child: Text(
                                        maxLines: 1,
                                        location,
                                        style: const TextStyle(
                                          fontSize:13,
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
                      const SizedBox(height: 6.0),
                      Visibility(
                        visible: _searchType != "All",
                        child: Container(
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
                                child:  Container(
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
                                        contentPadding: const EdgeInsets.only(bottom: 12),
                                        hintText: 'Select Customer',
                                        suffix: _selectedCustomer == '' ? null : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              customerController.text = '';
                                              customerId = "";
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 3),
                                            child: Icon(Icons.close,size: 14,),
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
                                        _selectedCustomer = "${suggestion.customerSlNo}";
                                        customerId = "${suggestion.customerSlNo}";
                                      });
                                    },
                                    onSaved: (value) {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                          /*: Container(),*/
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () async {

                            // final connectivityResult = await (Connectivity().checkConnectivity());

                            // if (connectivityResult == ConnectivityResult.mobile
                            //     || connectivityResult == ConnectivityResult.wifi){

                              setState(() {
                                CustomerDueListProvider().on();
                                // CustomerDueListProvider.isLoading == true;
                              });
                              Provider.of<CustomerDueListProvider>(context, listen: false).getCustomerDue("${customerId}", "${customerType}");

                            // }else{
                            //   Utils.errorSnackBar(context, "Please connect with internet");
                            // }
                          },
                          child: Container(
                            height: 35.0,
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
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                //if (data == 'all' || data == 'by supplier' )
                CustomerDueListProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : allCustomerDueData.isNotEmpty
                    ? Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.43,
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: SizedBox(
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
                                  border:
                                  TableBorder.all(color: Colors.black54, width: 1),
                                  columns: const [
                                    DataColumn(
                                      label: Expanded(child: Center(child: Text('Customer Id'))),
                                    ),
                                    DataColumn(
                                      label: Expanded(child: Center(child: Text('Customer Type'))),
                                    ),
                                    DataColumn(
                                      label: Expanded(child: Center(child: Text('Customer Name'))),
                                    ),
                                    DataColumn(
                                      label: Expanded(child: Center(child: Text('Customer Owner'))),
                                    ),
                                    DataColumn(
                                      label: Expanded(child: Center(child: Text('Customer Mobile'))),
                                    ),
                                    DataColumn(
                                      label: Expanded(child: Center(child: Text('Address'))),
                                    ),
                                    DataColumn(
                                      label: Expanded(child: Center(child: Text('Area'))),
                                    ),
                                    DataColumn(
                                      label: Expanded(child: Center(child: Text('Due'))),
                                    ),
                                  ],
                                  rows: List.generate(
                                    allCustomerDueData.length,
                                        (int index) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Center(
                                              child: Text(
                                                  allCustomerDueData[index].customerCode)),
                                        ),
                                        const DataCell(
                                          Center(
                                              child: Text(
                                                  '')),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(
                                                  allCustomerDueData[index].customerName)),
                                        ),
                                        const DataCell(
                                          Center(
                                              child: Text(
                                                  '')),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(
                                                  allCustomerDueData[index].customerMobile)),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(
                                                  allCustomerDueData[index].customerAddress)),
                                        ),
                                        const DataCell(
                                          Center(
                                              child: Text(
                                                  '')),
                                        ),
                                        DataCell(
                                          Center(
                                              child: Text(
                                                  double.parse(allCustomerDueData[index].dueAmount).toStringAsFixed(2))),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20,),
                                Row(
                                  children: [
                                    const Text("Total Due       :    ",style:TextStyle(fontWeight: FontWeight.bold),),
                                    Text("$dueTotal"),
                                  ],
                                ),
                                const SizedBox(height: 20,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                    : FutureBuilder(
                  future: Provider.of<CustomerDueListProvider>(context, listen: false).getDueDataFromLocal(),
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
                                showCheckboxColumn: true,
                                border:
                                TableBorder.all(color: Colors.black54, width: 1),
                                columns: const [
                                  DataColumn(
                                    label: Expanded(child: Center(child: Text('Customer Id'))),
                                  ),
                                  DataColumn(
                                    label: Expanded(child: Center(child: Text('Customer Type'))),
                                  ),
                                  DataColumn(
                                    label: Expanded(child: Center(child: Text('Customer Name'))),
                                  ),
                                  DataColumn(
                                    label: Expanded(child: Center(child: Text('Customer Owner'))),
                                  ),
                                  DataColumn(
                                    label: Expanded(child: Center(child: Text('Customer Mobile'))),
                                  ),
                                  DataColumn(
                                    label: Expanded(child: Center(child: Text('Address'))),
                                  ),
                                  DataColumn(
                                    label: Expanded(child: Center(child: Text('Area'))),
                                  ),
                                  DataColumn(
                                    label: Expanded(child: Center(child: Text('Due'))),
                                  ),
                                ],
                                rows: List.generate(
                                  snapshot.data!.length,
                                      (int index) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(
                                        Center(
                                            child: Text(
                                                snapshot.data![index].customerCode)),
                                      ),
                                      const DataCell(
                                        Center(
                                            child: Text(
                                                '')),
                                      ),
                                      DataCell(
                                        Center(
                                            child: Text(
                                                snapshot.data![index].customerName)),
                                      ),
                                      const DataCell(
                                        Center(
                                            child: Text(
                                                '')),
                                      ),
                                      DataCell(
                                        Center(
                                            child: Text(
                                                snapshot.data![index].customerMobile)),
                                      ),
                                      DataCell(
                                        Center(
                                            child: Text(
                                                snapshot.data![index].customerAddress)),
                                      ),
                                      const DataCell(
                                        Center(
                                            child: Text(
                                                '')),
                                      ),
                                      DataCell(
                                        Center(
                                            child: Text(
                                                double.parse(snapshot.data![index].dueAmount).toStringAsFixed(2))),
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
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    else{
                      return const SizedBox();
                    }
                  },)

                    // : const Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 16,color: Colors.red),),)),
              ]),
        ),
      ),
    );
  }
}
