import 'package:flutter/material.dart';

class AllTextStyle {
  static TextStyle searchTypeTxtStyle = const TextStyle(
    fontSize: 14.0,
    color: Color(0xFF424242),
    fontWeight: FontWeight.w400,
  );

  ///table headline
  static TextStyle tableHeadTextStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  ///Product name
  static  TextStyle productNameTextStyle =  TextStyle(
    color: Colors.grey.shade300,
    fontWeight: FontWeight.w500,
    fontSize: 12
  );

  ///table headline
  static TextStyle cashStatementHeadingTextStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xff707488),
  );

  static TextStyle attendTrueTextStyle = const TextStyle(
      fontSize: 14,
      color: Colors.teal,
      fontWeight: FontWeight.w600,
    );

  static TextStyle attendDateTextStyle = const TextStyle(
    fontSize: 14,
    color: Color(0xFF1271B0),
    fontWeight: FontWeight.bold,
  );

  ///no found/records
  static TextStyle nofoundTextStyle = const TextStyle(
    color: Colors.red,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  ///subTotal
  static const TextStyle subTotalTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );

  ///date style
  static TextStyle dateFormatStyle = TextStyle(
      fontSize: 13,
      color: Colors.grey.shade800,
      fontWeight: FontWeight.w400
  );

  ///subTotal Value
  static  TextStyle menuHeadTextStyle = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  static  TextStyle profileTextStyle = const TextStyle(
      color: Colors.blueGrey,
      fontSize: 14,
      fontWeight: FontWeight.w500
  );

  ///==module Head style==
  static  TextStyle moduleHeadTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold
  );

  ///save button style
  static TextStyle saveButtonTextStyle = const TextStyle(
      letterSpacing: 1.0,
      color: Colors.white,
      fontWeight: FontWeight.w500
  );

  ///textField head style
  static  TextStyle textFieldHeadStyle = TextStyle(color: Colors.grey.shade800);

  ///dropDownlist Style
  static  TextStyle dropDownlistStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Colors.grey.shade700);

  ///dropDownlist Style
  static  TextStyle textValueStyle = const TextStyle(fontSize: 12.5, color: Color.fromARGB(255, 126, 125, 125));
 ///dropDownlist Style
  static  TextStyle blackStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.black);
}

/// decoration
class ContDecoration{
  static  BoxDecoration contDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.grey, width: 0.5),
    borderRadius: BorderRadius.circular(5.0),
  );
}

/// textField inputborder
class TextFieldInputBorder{
  static OutlineInputBorder focusEnabledBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.grey, width: 0.5),
    borderRadius: BorderRadius.circular(5.0),
  );
}

getTextstyle(){
  return TextStyle(
      backgroundColor:  Colors.blue[100],
      color: Colors.black,
      decoration: TextDecoration.underline,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w500,
      fontSize: 16
  );
}

getHLTextstyle() {
  return  TextStyle(
      color: Colors.deepPurple.shade900,
      fontWeight: FontWeight.w800,
      fontSize: 16
  );
}
SizedBox sizedBoxH = const SizedBox(height: 10.0);
SizedBox sizedBoxW = const SizedBox(width: 10.0);

 ///===Warning Dialog===
showWarningDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('⚠️ Warning'),
        content: const Text(
          "It is not authorized for you to access this page!",
          style: TextStyle(fontSize: 16.5),
        ),
        actions: <Widget>[
          Container(
            height: 30,
            decoration:BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(color: Colors.black,fontSize: 10)),
            ),
          ),
        ],
      );
    },
  );
}
///====gridview
SliverGridDelegateWithFixedCrossAxisCount customGridDelegate({
  int crossAxisCount = 3,
  double mainAxisSpacing = 10.0,
  double crossAxisSpacing = 6.0,
  double mainAxisExtent = 105.0,
}) {
  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: crossAxisCount,
    mainAxisSpacing: mainAxisSpacing,
    crossAxisSpacing: crossAxisSpacing,
    mainAxisExtent: mainAxisExtent,
  );
}
///===customImageHPC=customImgHPC
Widget customImgHPC(String imagePath, {double height = 45, double width = 45}) {
  return Image(
    image: AssetImage(imagePath),
    height: height,
    width: width,
  );
}
///===customTextHPageCardTitle=customTHPCT
Widget customTextHPCT(String text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 10.5,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );
}

///===top data title style
Widget customStaticTextWidget({
  required String text,
  Color textColor = Colors.yellow,
  double fontSize = 12,
  FontWeight fontWeight = FontWeight.bold,
  TextAlign textAlign = TextAlign.center,
}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      color: textColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
  );
}

Widget customMultilineTextWidget({
  required String text,
  Color textColor = Colors.yellow,
  double fontSize = 12,
  FontWeight fontWeight = FontWeight.bold,
  TextAlign textAlign = TextAlign.center,
  int maxLines = 2,
  TextOverflow overflow = TextOverflow.ellipsis,
}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      color: textColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
    maxLines: maxLines,
    overflow: overflow,
  );
}
///======tob Value
Widget customTopValueText({
  required String data,
  Color textColor = Colors.yellow,
  double fontSize = 12,
  FontWeight fontWeight = FontWeight.bold,
  TextAlign textAlign = TextAlign.center,
  int maxLines = 2,
  TextOverflow overflow = TextOverflow.ellipsis,
}) {
  return Text(
    data.isNotEmpty ? double.parse(data).toStringAsFixed(0) : '0',
    textAlign: textAlign,
    style: TextStyle(
      color: textColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
    maxLines: maxLines,
    overflow: overflow,
  );
}

DataColumn customDataColumn(String label) {
  return DataColumn(
    label: Expanded(
      child: Center(
        child: Text(
          label,
          style: AllTextStyle.tableHeadTextStyle,
        ),
      ),
    ),
  );
}
