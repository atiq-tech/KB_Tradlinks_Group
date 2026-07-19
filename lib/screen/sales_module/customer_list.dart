//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/customer_provider.dart';
import 'package:provider/provider.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key,
   //this.connectivityResult
   }) : super(key: key);
  //final ConnectivityResult? connectivityResult;
  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {

  String? _searchType = "All";

  final List<String> _searchTypeList = [
    'All',
    'Retail Customers',
    'Wholesale Customers',
    'Unpaid Customers',
  ];
  String? customerType;

  @override
  void initState() {
    CustomerListProvider.isCustomerTypeChange = true;
    Provider.of<CustomerListProvider>(context,listen: false).getCustomerList(context,customerType: "");
    super.initState();
  }

  // ConnectivityResult? connectivityResult;
  //
  // @override
  // void didChangeDependencies() async{
  //   connectivityResult = await (Connectivity().checkConnectivity());
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    print('sadjkfhkjasdhf');
    final customerList = Provider.of<CustomerListProvider>(context).customerList.where((element) => element.displayName!="General Customer").toList();
    return Scaffold(
        appBar: const CustomAppBar(title: "Customer List",),
        body: /*(connectivityResult == ConnectivityResult.mobile
    || connectivityResult == ConnectivityResult.wifi)
          ? */
        Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.only(top:6.6,left: 6.0, right: 6.0,bottom: 6.0),
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
                          dropdownColor: const Color.fromARGB(255, 231, 251,
                              255), // Not necessary for Option 1
                          value: _searchType,
                          onChanged: (newValue) {
                            _searchType = newValue!;
                            setState(() {
                              CustomerListProvider().on();
                            });
                            if(_searchType == "Retail Customers"){
                              customerType = "retail";
                            }
                            else if(_searchType == "Wholesale Customers"){
                              customerType = "wholesale";
                            }
                            else if(_searchType == "Unpaid Customers"){
                              customerType = "unpaid";
                            }
                            else{
                              customerType = "";
                            }
                            print('sadjkfhkjasdhf2');

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
            ),
            CustomerListProvider.isCustomerTypeChange == true
                ? const Center(child: CircularProgressIndicator(),)
                : Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: DataTable(
                      headingRowHeight: 20.0,
                      dataRowMaxHeight: double.infinity,
                      dataRowMinHeight: 20,
                      showCheckboxColumn: true,
                      border: TableBorder.all(color: Colors.black54, width: 1),
                      columns: const [
                        DataColumn(
                          label: Expanded(child: Center(child: Text('SI.'))),
                        ),
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
                          label: Expanded(child: Center(child: Text('Owner Name'))),
                        ),
                        DataColumn(
                          label: Expanded(child: Center(child: Text('Address'))),
                        ),
                        DataColumn(
                          label: Expanded(child: Center(child: Text('Area'))),
                        ),
                        DataColumn(
                          label: Expanded(child: Center(child: Text('Contact No'))),
                        ),
                      ],
                      rows: List.generate(
                        customerList.length,
                            (int index) => DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Center(child: Text("${index + 1}")),
                            ),
                            DataCell(
                              Center(child: Text("${customerList[index].customerCode}")),
                            ),
                            DataCell(
                              Center(child: Text("${customerList[index].customerType}")),
                            ),
                            DataCell(
                              Center(child: Text("${customerList[index].customerName}")),
                            ),
                            DataCell(
                              Center(child: Text("${customerList[index].ownerName}")),
                            ),
                            DataCell(
                              Center(child: Text("${customerList[index].customerAddress}")),
                            ),
                            DataCell(
                              Center(child: Text("${customerList[index].districtName}")),
                            ),
                            DataCell(
                              Center(child: Text("${customerList[index].customerMobile}")),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
            // :Center(child: Text("Please connect with internet"),),
    );
  }
}
