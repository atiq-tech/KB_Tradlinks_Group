//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:kbtradlink/custom/custom_appbar.dart';
import 'package:kbtradlink/provider/business_monitor_provider.dart';
import 'package:kbtradlink/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

class BusinessMonitor extends StatefulWidget {
  const BusinessMonitor({super.key});

  @override
  State<BusinessMonitor> createState() => _BusinessMonitorState();
}

class _BusinessMonitorState extends State<BusinessMonitor> {

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
  bool isLoading = false;

  @override
  void initState() {
    firstPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndFirstDate = Utils.formatBackEndDate(DateTime.now());
    secondPickedDate = Utils.formatFrontEndDate(DateTime.now());
    backEndSecondDate = Utils.formatBackEndDate(DateTime.now());

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final businessMonitorData = Provider.of<BusinessMonitorProvider>(context).businessMonitorModel;
    return Scaffold(
      appBar: const CustomAppBar(title: "Business Monitor"),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.teal[100],
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      color: const Color.fromARGB(255, 7, 125, 180),
                      width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), 
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
                          setState(() {
                            BusinessMonitorProvider.isLoading = true;
                            Provider.of<BusinessMonitorProvider>(context, listen: false).getBusinessMonitor(backEndFirstDate, backEndSecondDate);
                          });
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
              const SizedBox(height: 20),
              LayoutBuilder(builder:  (context, constraints) {
                if(BusinessMonitorProvider.isLoading){
                  return const CircularProgressIndicator();
                }
                else if(businessMonitorData==null){
                  return const Center(child: Text("No Data Found",style: TextStyle(color: Colors.red)));
                }
                else if(businessMonitorData.topCustomers.isEmpty){
                  return const Center(child: Text("No Data Found",style: TextStyle(color: Colors.red)));
                }
                else if(businessMonitorData.topProducts.isEmpty){
                  return const Center(child: Text("No Data Found",style: TextStyle(color: Colors.red)));
                }
                else if(businessMonitorData.topPaidCustomer.isEmpty){
                  return const Center(child: Text("No Data Found",style: TextStyle(color: Colors.red)));
                }
                return Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          color: Colors.tealAccent,
                          padding: const EdgeInsets.all(5),
                          child: const Text(
                            "Top Sold Products",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      PieChart(
                        // dataMap: Map.fromIterable(
                        //   businessMonitorData!.topProducts.map((e) => e.toMap().keys),
                        //   value: businessMonitorData!.topProducts.map((e) => e.toMap().values.map((e) => (double.tryParse(e.toString()) ?? 0.0)),),
                        //   // value: businessMonitorData!.toMap().values.map((e) => e.toString()),
                        // ),
                        dataMap: businessMonitorData.topProducts.fold<Map<String, double>>({},
                                (map, model) => map..[model.productName] = double.parse(model.soldQuantity)),

                        animationDuration: const Duration(milliseconds: 800),
                        chartLegendSpacing: 20,
                        chartRadius: 150,
                        colorList: List.generate(businessMonitorData.topProducts.length, (index){
                          if(index==0){
                            return const Color(0xFF3366CC);
                          }
                          if(index==1){
                            return const Color(0xFFDC3912);
                          }
                          if(index==2){
                            return const Color(0xFFFF9900);
                          }
                          if(index==3){
                            return const Color(0xFF109618);
                          }
                          return const Color(0xFF990099);

                        }),
                        initialAngleInDegree: 0,
                        chartType: ChartType.disc,
                        ringStrokeWidth: 32,
                        centerText: "",
                        legendOptions: const LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.bottom,
                          showLegends: true,
                          legendShape: BoxShape.circle,
                          legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12
                          ),
                        ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValueBackground: false,
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                          showChartValuesOutside: false,
                          decimalPlaces: 1,
                          chartValueStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12
                          ),
                        ),
                        // gradientList: ---To add gradient colors---
                        // emptyColorGradient: ---Empty Color gradient---
                      ),

                      const SizedBox(height: 20,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          color: Colors.tealAccent,
                          padding: const EdgeInsets.all(5),
                          child: const Text(
                            "Top Customer",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      PieChart(
                        // dataMap: Map.fromIterable(
                        //   businessMonitorData!.topProducts.map((e) => e.toMap().keys),
                        //   value: businessMonitorData!.topProducts.map((e) => e.toMap().values.map((e) => (double.tryParse(e.toString()) ?? 0.0)),),
                        //   // value: businessMonitorData!.toMap().values.map((e) => e.toString()),
                        // ),
                        dataMap: businessMonitorData.topCustomers.fold<Map<String, double>>({},
                                (map, model) => map..[model.customerName] = double.parse(model.amount)),

                        animationDuration: const Duration(milliseconds: 800),
                        chartLegendSpacing: 20,
                        chartRadius: 150,
                        colorList: List.generate(businessMonitorData.topCustomers.length, (index){
                          if(index==0){
                            return const Color(0xFF3366CC);
                          }
                          if(index==1){
                            return const Color(0xFFDC3912);
                          }
                          if(index==2){
                            return const Color(0xFFFF9900);
                          }
                          if(index==3){
                            return const Color(0xFF109618);
                          }
                          return const Color(0xFF990099);

                        }),
                        initialAngleInDegree: 0,
                        chartType: ChartType.disc,
                        ringStrokeWidth: 32,
                        centerText: "",
                        legendOptions: const LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.bottom,
                          showLegends: true,
                          legendShape: BoxShape.circle,
                          legendTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 12
                          ),
                        ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValueBackground: false,
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                          showChartValuesOutside: false,
                          decimalPlaces: 1,
                          chartValueStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 12
                          ),
                        ),
                        // gradientList: ---To add gradient colors---
                        // emptyColorGradient: ---Empty Color gradient---
                      ),

                      const SizedBox(height: 20,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          color: Colors.tealAccent,
                          padding: const EdgeInsets.all(5),
                          child: const Text(
                            "Top Paid Customer",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      PieChart(
                        // dataMap: Map.fromIterable(
                        //   businessMonitorData!.topProducts.map((e) => e.toMap().keys),
                        //   value: businessMonitorData!.topProducts.map((e) => e.toMap().values.map((e) => (double.tryParse(e.toString()) ?? 0.0)),),
                        //   // value: businessMonitorData!.toMap().values.map((e) => e.toString()),
                        // ),
                        dataMap: businessMonitorData.topPaidCustomer.fold<Map<String, double>>({},
                                (map, model) => map..[model.customerName] = double.parse(model.total)),

                        animationDuration: const Duration(milliseconds: 800),
                        chartLegendSpacing: 20,
                        chartRadius: 150,
                        colorList: List.generate(businessMonitorData.topPaidCustomer.length, (index){
                          if(index==0){
                            return const Color(0xFF3366CC);
                          }
                          if(index==1){
                            return const Color(0xFFDC3912);
                          }
                          if(index==2){
                            return const Color(0xFFFF9900);
                          }
                          if(index==3){
                            return const Color(0xFF109618);
                          }
                          return const Color(0xFF990099);

                        }),
                        initialAngleInDegree: 0,
                        chartType: ChartType.disc,
                        ringStrokeWidth: 32,
                        centerText: "",
                        legendOptions: const LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.bottom,
                          showLegends: true,
                          legendShape: BoxShape.circle,
                          legendTextStyle: TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 12),
                        ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValueBackground: false,
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                          showChartValuesOutside: false,
                          decimalPlaces: 1,
                          chartValueStyle: TextStyle(color: Colors.white,fontSize: 12),
                        ),
                        // gradientList: ---To add gradient colors---
                        // emptyColorGradient: ---Empty Color gradient---
                      ),
                    ],
                  );
              },)
            ],
          ),
        ),
      ),
    );
  }
}
