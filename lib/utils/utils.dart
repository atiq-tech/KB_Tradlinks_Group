import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class Utils{

  static showSpinKitLoad(){
    return SpinKitDoubleBounce(
      itemBuilder: (context, index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.grey : Colors.white,
          ),
        );
      },
      size: 40,
    );
  }

  static void closeKeyBoard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static String formatFrontEndDate(var date) {
    late DateTime dateTime;
    if (date is String) {
      dateTime = DateTime.parse(date);
    } else {
      dateTime = date;
    }

    return DateFormat('dd-MM-yyyy').format(dateTime);
    // return DateFormat('yyyy-MM-dd').format(dateTime);
  }
  static String formatBackEndDate(var date) {
    late DateTime dateTime;
    if (date is String) {
      dateTime = DateTime.parse(date);
    } else {
      dateTime = date;
    }

    return DateFormat('y-MM-dd').format(dateTime);
    // return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  //............ Toast Message ............
  static void toastMsg(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static void errorSnackBar(BuildContext context, String errorMsg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          content: Text(errorMsg, style: const TextStyle(color: Colors.red)),
        ),
      );
  }

  static void showSnackBar(BuildContext context, String msg,
      [Color textColor = Colors.black]) {
    final snackBar =
    SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
        content: Text(msg, style: TextStyle(color: textColor)));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showSnackBarWithAction(
      BuildContext context, String msg, VoidCallback onPress,{String actionText = 'Active',Color textColor = Colors.black,}) {
    final snackBar = SnackBar(
      content: Text(msg, style: TextStyle(color: textColor)),
      action: SnackBarAction(
        label: actionText,
        textColor: Colors.white,
        onPressed: onPress,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showMotionToast(
    BuildContext context, {
    required String title,
    required String description,
    IconData icon = Icons.info,
    Color? primaryColor,
    Color? secondaryColor,
    Alignment toastAlignment = Alignment.topCenter,
    AnimationType animationType = AnimationType.slideInFromRight,
    double? height,
    double? width,
    Duration duration = const Duration(seconds: 3),
  }) {
    MotionToast(
      icon: icon,
      primaryColor: primaryColor ?? const Color.fromARGB(255, 2, 77, 117),
      secondaryColor: secondaryColor ??Color.fromARGB(255, 0, 255, 34),
      title: Text(title,style: const TextStyle(color: Color.fromARGB(255, 0, 255, 34), fontWeight: FontWeight.bold)),
      description: Text(description,style: const TextStyle(color: Colors.white)),
      toastAlignment: toastAlignment,
      animationType: animationType,
      height: height ?? 80,
      width: width ?? 300,
      displayBorder: false,
      animationCurve: Curves.easeOutBack,
      animationDuration: const Duration(milliseconds: 1000),
      toastDuration: duration,
    ).show(context);
  }

}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String capitalizeByWord() {
    if (trim().isEmpty) {
      return "";
    }
    return split(" ")
        .map((element) =>
    "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}")
        .join(" ");
  }
}
