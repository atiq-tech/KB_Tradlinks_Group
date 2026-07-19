//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/supplier_due_provider.dart';
import 'package:kbtradlink/provider/supplier_provider.dart';
import 'package:kbtradlink/screen/administation_module/model/supplier_model.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:provider/provider.dart';

class SupplierDueList extends StatefulWidget {
  const SupplierDueList({super.key});

  @override
  State<SupplierDueList> createState() => _SupplierDueListState();
}

class _SupplierDueListState extends State<SupplierDueList> {
  final TextEditingController supplierController = TextEditingController();
  bool isSupplierListClicked = false;
  String? _searchType = "All";

  final List<String> _searchTypeList = [
    'All',
    'By Supplier',
  ];
  String _selectedSupplier = "";
  var data;

  ///total due
  double? dueTotal;

  @override
  void initState() {
    Provider.of<SupplierProvider>(context,listen: false).getSupplierList();

    Provider.of<SupplierDueProvider>(context,listen: false).getSupplierDuelist = [];

    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    // Supplier list
    final allSuppliersList = Provider.of<SupplierProvider>(context).supplierList.where((element) => element.displayName != "General Supplier");
    // Supplier due
    final allSupplierDueData = Provider.of<SupplierDueProvider>(context).getSupplierDuelist.where((element) => element.due !='0.00').toList();

    ///Sub total
    dueTotal=allSupplierDueData.map((e) => e.due).fold(0.0, (p, element) => p!+double.parse(element));

    return Scaffold(
      appBar: const CustomAppBar(title:"Supplier Due Report",),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top:6.6,left: 6.0, right: 6.0,bottom: 6.0),
              decoration: BoxDecoration(
                color: Colors.green[100],
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
                                dropdownColor: const Color.fromARGB(255, 231, 251,
                                    255), // Not necessary for Option 1
                                value: _searchType,
                                onChanged: (newValue) {
                                  setState(() {
                                    _searchType = newValue!;
                                    _selectedSupplier='';

                                    if (_searchType == "By Supplier") {
                                      isSupplierListClicked = true;
                                    } else {
                                      _selectedSupplier = "";
                                      isSupplierListClicked = false;
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
                  isSupplierListClicked == true ? const SizedBox(height: 6.0):const SizedBox(height: 0.0),
                  isSupplierListClicked == true
                      ? Container(
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 4,
                          child: Text(
                            "Supplier",
                            style: TextStyle(
                                color:
                                Color.fromARGB(255, 126, 125, 125)),
                          ),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 11,
                          child: Container(
                            height:30.0,
                            width:
                            MediaQuery.of(context).size.width / 2,
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
                                      "${suggestion.supplierName}",
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
                                  (SupplierModel suggestion) {
                                supplierController.text = suggestion.supplierName!;
                                setState(() {
                                  _selectedSupplier =
                                      "${suggestion.supplierSlNo}";
                                  print(
                                      "Customer Wise Category ID ========== > ${suggestion.supplierSlNo} ");
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
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        //final connectivityResult = await (Connectivity().checkConnectivity());

                        if(isSupplierListClicked&&_selectedSupplier==""){
                          Utils.errorSnackBar(context, "Please Select Supplier");
                        } else{
                          // if (connectivityResult == ConnectivityResult.mobile
                          //     || connectivityResult == ConnectivityResult.wifi) {
                            SupplierDueProvider().on();
                            Provider.of<SupplierDueProvider>(
                                context, listen: false)
                                .getSupplierDue(
                                context,
                                "${_selectedSupplier}"
                            );
                        //   }
                        // else{
                        // Utils.errorSnackBar(context, "Please connect with internet");
                        // }
                        }
                      },
                      child: Container(
                        height: 30.0,
                        width: 75.0,
                        decoration: BoxDecoration(
                          color: Colors.green[500],
                         // color: const Color.fromARGB(255, 4, 113, 185),
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
            const SizedBox(height: 10.0),
            SupplierDueProvider.isSupplierTypeChange
                  ? const Center(child: CircularProgressIndicator())
                  : allSupplierDueData.isNotEmpty?
            Expanded(
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
                          Container(
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
                                  label: Expanded(child: Center(child: Text('Supplier Code'))),
                                ),
                                DataColumn(
                                  label: Expanded(child: Center(child: Text('Supplier Name'))),
                                ),
                                DataColumn(
                                  label: Expanded(child: Center(child: Text('Bill Amount'))),
                                ),
                                DataColumn(
                                  label: Expanded(child: Center(child: Text('Paid Amount'))),
                                ),
                                DataColumn(
                                  label: Expanded(child: Center(child: Text('Returned Amount'))),
                                ),
                                DataColumn(
                                  label: Expanded(child: Center(child: Text('Due'))),
                                ),
                              ],
                              rows: List.generate(
                                allSupplierDueData.length,
                                    (int index) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(
                                      Center(
                                          child: Text(
                                              '${allSupplierDueData[index].supplierCode}')),
                                    ),
                                    DataCell(
                                      Center(
                                          child: Text(
                                              '${allSupplierDueData[index].supplierName}')),
                                    ),
                                    DataCell(
                                      Center(
                                          child: Text(
                                              '${allSupplierDueData[index].bill}')),
                                    ),
                                    DataCell(
                                      Center(
                                          child: Text(
                                              '${allSupplierDueData[index].paid}')),
                                    ),
                                    DataCell(
                                      Center(
                                          child: Text(
                                              '${allSupplierDueData[index].returned}')),
                                    ),
                                    DataCell(
                                      Center(
                                          child: Text(
                                              '${double.parse("${allSupplierDueData[index].due}").toStringAsFixed(2)}')),
                                    ),
                                  ],
                                ),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ): const Align(alignment: Alignment.center,child: Center(child: Text("No Data Found",style: TextStyle(fontSize: 16,color: Colors.red),),)),
          ],
        ),
      ),
    );
  }
}
