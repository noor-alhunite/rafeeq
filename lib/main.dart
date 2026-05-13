import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projectrafeec1/pages/change_password.dart';
import 'package:projectrafeec1/pages/home.dart';
import 'package:projectrafeec1/pages/log_in.dart';
import 'package:projectrafeec1/pages/my_bookings.dart';
import 'package:projectrafeec1/pages/profile_screen.dart';
import 'package:projectrafeec1/pages/services_page.dart';
import 'package:projectrafeec1/pages/settings.dart';
import 'package:projectrafeec1/pages/sign_up.dart';
import 'package:projectrafeec1/pages/splash_screen.dart';
import 'package:projectrafeec1/pages/trips_page.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Device.height = MediaQuery
    //    .of(context)
    //     .size
    //     .height;
    // Device.width = MediaQuery
    //      .of(context)
    //     .size
    //     .width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
     // home:Home(),
     // home: LogIn(),
     home:SplashScreen(),
     // home:SignUp(),
      // home: Settings(),
     // home: ChangePassword(),
     // home: ServicesPage(),
     // home: MyBookings(),
      //home: TripsPage(),
      //home: ProfileScreen(),
    );
  }
}


