// Design by - Link-Up Technology Ltd.
// Developed by - Link-Up Technology Ltd.
// Location - Mirpur-10, Dhaka, Bangladesh.
// Website - https://www.linktechbd.com/
// Phone - +8801911978897



import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kbtradlink/screen/auth/login_screen.dart';
import 'package:kbtradlink/screen/home_screen.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {

  var box;
  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    box = await Hive.openBox('profile');
    Future.delayed(const Duration(seconds: 1),() {
      print('State Loaded ${box.get('token')}');

      if (box.get('token') != null) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage(),), (route) => false);
      }
      else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LogInPage(),), (route) => false);
      }
    },);
  }
  @override
  Widget build(BuildContext context) {

    return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.blue,),
        )
    );
  }
}
