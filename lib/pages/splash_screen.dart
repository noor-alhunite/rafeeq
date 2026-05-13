import 'dart:async';
import 'package:flutter/material.dart';
import '../utilities/appcolor.dart'; // استيراد ملف الألوان
import 'log_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // الانتقال لصفحة تسجيل الدخول بعد 3 ثوانٍ
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LogIn()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // استخدام اللون العنابي الباهت (Translucent Berry) للخلفية كما طلبت
      backgroundColor: AppColor.translucentBerry,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10), // إطار خفيف حول اللوغو
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2), // لمسة بياض شفافة جداً خلف الدائرة
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(200), // جعل الصورة دائرية تماماً
            child: Image.asset(
              'assets/logo1.png', // تأكد من وجود logo1.png في مجلد assets
              width: MediaQuery.of(context).size.width * 0.6, // حجم متناسق في المنتصف
              height: MediaQuery.of(context).size.width * 0.6,
              fit: BoxFit.cover, // لضمان ملء الدائرة باللوغو بشكل كامل
            ),
          ),
        ),
      ),
    );
  }
}
