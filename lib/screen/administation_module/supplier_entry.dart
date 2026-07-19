import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/supplier_provider.dart';
import 'package:kbtradlink/utils/const_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupplierEntry extends StatefulWidget {
  const SupplierEntry({super.key});

  @override
  State<SupplierEntry> createState() => _SupplierEntryState();
}

class _SupplierEntryState extends State<SupplierEntry> {
  final TextEditingController _supplierNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _previousDueController = TextEditingController();

  //ApiAllSuppliers? apiAllSuppliers;
  @override
  void initState() {
  SupplierProvider.isLoading=true;
    Provider.of<SupplierProvider>(context,listen: false).getSupplierList();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //get Suppliers
    final allSuppliersData = Provider.of<SupplierProvider>(context).supplierList.where((element) => element.supplierName!=null).toList();
    // allSuppliersData.removeAt(0);
    return Scaffold(
      appBar: CustomAppBar(title: "Supplier Entry"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 250.0,
                width: double.infinity,
                //margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(top:4.0,left: 4.0, right: 4.0),
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
                      offset: Offset(0, 3), // changes the position of the shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          flex: 5,
                          child: Text(
                            "Supplier Name",
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
                              style: TextStyle(fontSize: 13),
                              controller: _supplierNameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Enter Supplier Name",
                                contentPadding: EdgeInsets.only(left: 5),
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
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          flex: 5,
                          child: Text(
                            "Owner Name",
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
                              style: TextStyle(fontSize: 13),
                              controller: _ownerNameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Enter Owner Name",
                                contentPadding: EdgeInsets.only(left: 5),
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
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          flex: 5,
                          child: Text(
                            "Address",
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
                              style: TextStyle(fontSize: 13),
                              controller: _addressController,
                              keyboardType: TextInputType.streetAddress,
                              decoration: InputDecoration(
                                hintText: "Enter Address",
                                contentPadding: EdgeInsets.only(left: 5),
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
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          flex: 5,
                          child: Text(
                            "Mobile",
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
                              style: TextStyle(fontSize: 13),
                              controller: _mobileController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: "Enter Mobile Number",
                                contentPadding: EdgeInsets.only(left: 5),
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
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          flex: 5,
                          child: Text(
                            "Email",
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
                              style: TextStyle(fontSize: 13),
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Enter Email",
                                contentPadding: EdgeInsets.only(left: 5),
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
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          flex: 5,
                          child: Text(
                            "Previous Due",
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
                              style: TextStyle(fontSize: 13),
                              controller: _previousDueController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 5),
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
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            supplierEntryBtnClk = true;
                            getSupplierCode().then((value) {
                              if(value!=""){
                                addSupply(context).then((value){
                                  if(value=="true"){
                                    Provider.of<SupplierProvider>(context, listen: false).getSupplierList();
                                    setState(() {

                                    });
                                  }
                                });
                              }
                            });
                          });
                        },
                        child: Container(
                          height: 35.0,
                          width: 70.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(255, 173, 241, 179),
                                width: 2.0),
                            color: const Color.fromARGB(255, 75, 90, 131),
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3), // changes the position of the shadow
                              ),
                            ],
                          ),
                          child: Center(
                              child: supplierEntryBtnClk ? SizedBox(height: 20,width:20,child: CircularProgressIndicator(color: Colors.white,)) : const Text(
                                "SAVE",
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
            // Align(
            //   alignment: Alignment.center,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Card(
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(10.0),
            //             side: BorderSide(
            //                 color: Color.fromARGB(255, 46, 46, 46), width: 2),
            //           ),
            //           elevation: 10.0,
            //           child: images == null
            //               ? Image.network(
            //                   "https://cdn-icons-png.flaticon.com/512/2748/2748558.png",
            //                   height: 150,
            //                   width: 150,
            //                   fit: BoxFit.cover,
            //                 )
            //               : Image.file(
            //                   File(images!.path),
            //                   height: 150,
            //                   width: 150,
            //                   fit: BoxFit.cover,
            //                 )),
            //       const SizedBox(
            //         height: 10,
            //       ),
            //       ElevatedButton(
            //           style: ElevatedButton.styleFrom(
            //               backgroundColor: Color.fromARGB(255, 76, 89, 146)),
            //           onPressed: () {
            //             _imageSource = ImageSource.gallery;
            //             chooseImageFrom();
            //           },
            //           child: const Text(
            //             "Select Image",
            //             style: TextStyle(
            //               color: Color.fromARGB(255, 249, 254, 255),
            //               fontWeight: FontWeight.w600,
            //               fontSize: 18,
            //             ),
            //           )),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 5.0),
            SupplierProvider.isLoading
                ? Center(child: CircularProgressIndicator(),)
                : Container(
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
                      child: DataTable(
                        headingRowHeight: 20.0,
                        dataRowHeight: 20.0,
                        showCheckboxColumn: true,
                        border:
                        TableBorder.all(color: Colors.black54, width: 1),
                        columns: const [
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Supplier Id'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Supplier Name'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Contact Person'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Address'))),
                          ),
                          DataColumn(
                            label: Expanded(child: Center(child: Text('Contact Number'))),
                          ),
                          // DataColumn(
                          //   label: Center(child: Text('Image')),
                          // ),
                        ],
                        rows: List.generate(
                          allSuppliersData.length > 100 ? 100 : allSuppliersData.length,
                              (int index) => DataRow(
                            cells: <DataCell>[
                              DataCell(
                                Center(
                                    child: Text(
                                        '${allSuppliersData[index].supplierCode}')),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        '${allSuppliersData[index].supplierName}')),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        '${allSuppliersData[index].contactPerson}')),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        '${allSuppliersData[index].supplierAddress}')),
                              ),
                              DataCell(
                                Center(
                                    child: Text(
                                        '${allSuppliersData[index].supplierMobile}')),
                              ),
                              // DataCell(
                              //   Center(
                              //       child: Container(
                              //           width: 44.0,
                              //           height: 42.0,
                              //           color: Colors.black,
                              //           child: Image.network(
                              //               "http://testapi.happykhata.com/${allSuppliersData[index].imageName}"))),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
            // FutureBuilder(
            //   future: Provider.of<CounterProvider>(context, listen: false).getSupplierDatas(context),
            //   builder: (context, snapshot) {
            //
            //     if(snapshot.hasData){
            //       return ;
            //     }
            //     else if(snapshot.connectionState == ConnectionState.waiting){
            //       return const CircularProgressIndicator();
            //     }
            //     else{
            //       return Container();
            //     }
            //   },)
          ],
        ),
      ),
    );
  }
  emtyMethod() {
    setState(() {
      supplierId = "";
      _supplierNameController.text = "";

      _mobileController.text = "";

      _emailController.text = "";
      _addressController.text = "";
      _ownerNameController.text = "";

      _previousDueController.text = "";
    });
  }

  Future<String>addSupply(context) async {
    String link = "${baseUrl}api/v1/addSupplier";
    FormData formData = FormData.fromMap({
      'data': jsonEncode({
        'Supplier_SlNo': 0,
        'Supplier_Code': supplierId.toString().trim(),
        'Supplier_Name': _supplierNameController.text.toString().trim(),
        'Supplier_Mobile': _mobileController.text.toString().trim(),
        'Supplier_Email': _emailController.text.toString().trim(),
        'Supplier_Address': _addressController.text.toString().trim(),
        'contact_person': _ownerNameController.text.toString().trim(),
        'previous_due': _previousDueController.text.toString().trim()
      }),
      "image": ""
      //"image": await MultipartFile.fromFile(images!.path, filename: "fileName"),
    });
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(link,
          data: formData,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${sharedPreferences.getString("token")}",
          }));
      var item = jsonDecode(response.data);
      print("SUPPLIER DDDDDDDDDDDATA ${item}");
      print("success============> ${item["success"]}");
      print("message =================> ${item["message"]}");
      print("supplierCode================>  ${item["supplierCode"]}");
      if (item["success"] == true) {
        emtyMethod();
        setState(() {
          supplierEntryBtnClk = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 2),
            content: Center(child: Text("${item["message"]}",style: TextStyle(color: Colors.white)))));
       // Navigator.pop(context);
        return "true";
      } else {
        setState(() {
          supplierEntryBtnClk = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 2),
            content: Center(child: Text("${item["message"]}",style: TextStyle(color: Colors.red),))));
        return "false";
      }
    } catch (e) {
      return "false";
    }
  }


  //Get Supplier_Id
  String? supplierId;
  Future<String>getSupplierCode() async {
    String link = "${baseUrl}api/v1/getSupplierId";
    SharedPreferences? sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post(
        link,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${sharedPreferences.getString("token")}",
        }),
      );
      print(response.data);
      var supplierId = jsonDecode(response.data);
      print("SupplierId Code===========> $supplierId");
      return response.data;
    } catch (e) {
      print(e);
    }
    return "";
  }
  bool supplierEntryBtnClk = false;
}
