import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kbtradlink/utils/const_page.dart';
import 'package:kbtradlink/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});
  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SharedPreferences? sharedPreferences;

  fetchLogin() async {
    String link = "${baseUrl}api/v1/login";
    try {
      final formData = FormData.fromMap({
        "username": _usernameController.text,
        "password": _passwordController.text
      });
      final response = await Dio().post(link, data: formData);
      var item = jsonDecode(response.data);
      print('sgjliklsdfg $item');
      // if (item["message"] == "User login successfully") {
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (context) => HomePage()));
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       backgroundColor: Color.fromARGB(255, 7, 125, 180),
      //       duration: Duration(seconds: 1),
      //       content: Center(child: Text("Login successfull"))));
      // }
      print("sdfgsdgsdgsdf ${item["message"]}");
      if (item["status"] == true) {
        sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences?.setString('token', "${item["token"]}");
        var box = Hive.box('profile');
        box.put('name', "${item["data"]["name"]}");
        box.put('token', "${item["token"]}");
        box.put('branchName', "${item["data"]["branch_name"]}");

        print('asdgasdgsdg${sharedPreferences?.getString('token')}');
        GetStorage().write("token", "${item["token"]}");
        GetStorage().write("id", "${item["data"]["id"]}");
        GetStorage().write("name", "${item["data"]["name"]}");
        GetStorage().write("usertype", "${item["data"]["usertype"]}");
        GetStorage().write("image_name", "${item["data"]["image_name"]}");
        GetStorage().write("branch", "${item["data"]["branch"]}");
        GetStorage().write("branch_name", "${item["data"]["branch_name"]}");
        setState(() {
          isLogInBtnClk = false;
        });
        _usernameController.text = "";
        _passwordController.text = "";
        print("token : ${GetStorage().read("token")}");
        print("id : ${GetStorage().read("id")}");
        print("name : ${GetStorage().read("name")}");
        print("usertype : ${GetStorage().read("usertype")}");
        print("image_name : ${GetStorage().read("image_name")}");
        print("branch : ${GetStorage().read("branch")}");
        print("branchName : ${GetStorage().read("branch_name")}");

        print("name : ${GetStorage().read("name")}");

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            content: Center(child: Text("${item["message"]}",style: const TextStyle(color: Colors.white),))));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage()));

      }else{
        setState(() {
          isLogInBtnClk = false;
          isError=true;
        });
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     backgroundColor: Colors.black,
        //     duration: const Duration(seconds: 3),
        //     content: Center(child: Text("${item["message"]}",style: const TextStyle(color: Colors.red),))));
      }
    } catch (e) {
      print("eoor messange $e");
      setState(() {
        isLogInBtnClk = false;
        isError=true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 5),
          content: Center(child: Text(e.toString(),style: const TextStyle(color: Colors.red),))));
    }
  }

  String? user_name;
  bool _isObscure = true;
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: InkWell(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            color: const Color.fromARGB(255, 6, 126, 196),
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 11, 7, 248),
                          // borderRadius: BorderRadius.circular(5.0),
                          // border: Border.all(
                          //     color:  Colors.white,
                          //     width: 2.0),

                        ),
                        child: const Center(
                          child: Text(
                            "Business Management Apps",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22.0,
                                color: Colors.white),
                          ),
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 22,
                    ),

                    Container(
                      height: 240,
                      width: 240,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                              color: const Color.fromARGB(255, 11, 7, 248),
                              width: 5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // changes the position of the shadow
                            ),
                          ],
                          image: const DecorationImage(image: AssetImage("images/app_image.png"),fit: BoxFit.fill,)
                      ),
                      //child: Image.asset("images/happykhata.png",fit: BoxFit.fill,),
                      // backgroundImage: NetworkImage(GetStorage()
                      //             .read("token") ==
                      //         null
                      //     ? "images/happykhata.png"
                      //     : "images/happykhata.png"),
                      //http://happykhata.com/uploads/users/${GetStorage().read("image_name")}
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      // height: 26.0,
                      // width: MediaQuery.of(context).size.width,
                      // decoration: BoxDecoration(
                      //   color:  Colors.deepPurple,
                      //   // border: Border.all(
                      //   //     color:  Colors.white,
                      //   //     width: 1.0),
                      //
                      // ),
                        child: const Center(
                          child: Text(
                            "KB Tradelinks Group",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 25.0,
                                color: Colors.white),
                          ),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 300.0,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 45.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                                color: const Color.fromARGB(255, 11, 7, 248),
                                width: 3.2)),
                        child: Column(
                          children: [
                            TextFormField(
                              // validator: (value) => value!.isEmpty
                              //     ? 'user cannot be blank'
                              //     : null,
                              controller: _usernameController,
                              decoration:  const InputDecoration(
                                label: Text("User Name"),
                                hintText: "User Name",
                                errorStyle: TextStyle(fontSize: 0.0),
                                hintStyle: TextStyle(fontSize: 18.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color:
                                      Color.fromARGB(255, 155, 152, 152)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color:
                                      Color.fromARGB(255, 185, 185, 185)),
                                ),
                              ),
                              onTap: () async {},
                            ),
                            const SizedBox(height: 15.0),
                            TextFormField(
                              obscureText: _isObscure,
                              // validator: (value) => value!.isEmpty
                              //     ? 'Password cannot be blank'
                              //     : null,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(_isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                ),
                                suffixIconColor: Colors.grey,
                                errorStyle: const TextStyle(fontSize: 0.0),
                                label: const Text("Password"),
                                hintText: "Password",
                                hintStyle: const TextStyle(fontSize: 18.0),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color:
                                      Color.fromARGB(255, 155, 152, 152)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color:
                                      Color.fromARGB(255, 185, 185, 185)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Visibility(
                              visible: isError,
                              child: const Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    Text("Invalid User name or Password",style: TextStyle(color: Colors.red,fontSize: 16),),
                                    SizedBox(height: 20.0),
                                  ],
                                ),
                              ),
                            ),
                            ///
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  setState(() {
                                    isLogInBtnClk = true;
                                  });
                                  if (_formkey.currentState!.validate()) {
                                    fetchLogin();
                                  } else {
                                    setState(() {
                                      isError=false;
                                      isLogInBtnClk = false;
                                    });
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //     const SnackBar(
                                    //         duration: Duration(seconds: 3),
                                    //         content: Center(child: Text("Fill all the field"))));
                                  }
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
                                },
                                child: Container(
                                  height: 40.0,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 88, 204, 91),
                                        width: 2.0),
                                    color: const Color.fromARGB(255, 5, 114, 165),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                      child: isLogInBtnClk
                                          ? const SizedBox(height: 20,width:20,child: CircularProgressIndicator(color: Colors.white,)) : const Text(
                                        "LOG IN",
                                        style: TextStyle(
                                            letterSpacing: 1.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      )),

                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomSheet:  Container(
            height: 26.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color:  Colors.deepPurple,
              // border: Border.all(
              //     color:  Colors.white,
              //     width: 1.0),
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
              child: Padding(
                padding: const EdgeInsets.only(left: 70),
                child: Row(
                  children: [
                    const Text("Developed by", style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0),),
                    const SizedBox(width: 5,),
                    RichText(
                        text: TextSpan(
                            text: "Link-Up Technology Ltd.",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.0),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch("https://linktechbd.com/#");
                              })),
                  ],
                ),
              ),
              // const Text(
              //   "Developed By Link-Up Technology",
              //   style: TextStyle(
              //       fontWeight: FontWeight.w500,
              //       fontSize: 14.0,
              //       color: Colors.white),
              // ),
            )),
      ),
    );
  }

  bool isLogInBtnClk = false;
  bool isError=false;
}
