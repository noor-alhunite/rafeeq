import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectrafeec1/pages/password_forgot.dart';
import '../utilities/appcolor.dart';
import 'sign_up.dart';
import 'home.dart'; // تأكدي أن اسم الملف هو home.dart واسم الكلاس Home

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  // دالة تسجيل الدخول المطورة عبر Firebase
  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        // إظهار دائرة تحميل (Loading)
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.white)),
        );

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (mounted) {
          Navigator.pop(context); // إغلاق دائرة التحميل

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎉 تم تسجيل الدخول بنجاح، أهلاً بك!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // التعديل هنا: الانتقال لصفحة الهوم وحذف الصفحات السابقة من الذاكرة
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
                (route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) Navigator.pop(context); // إغلاق دائرة التحميل عند الخطأ

        String message = 'حدث خطأ ما، حاول مجدداً';

        if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
          message = 'البريد الإلكتروني أو كلمة السر غير صحيحة';
        } else if (e.code == 'wrong-password') {
          message = 'كلمة السر غير صحيحة، حاول مرة أخرى';
        } else if (e.code == 'invalid-email') {
          message = 'صيغة البريد الإلكتروني غير صحيحة';
        } else if (e.code == 'network-request-failed') {
          message = 'يرجى التحقق من اتصالك بالإنترنت';
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColor.textappbar,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundDark,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 80),

                // الشعار (Logo)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: AppColor.translucentBerry,
                        shape: BoxShape.circle
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                          'assets/logo1.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                Text(
                    "أهلاً بك في رفيق",
                    style: GoogleFonts.amiri(
                        color: AppColor.textappbar,
                        fontSize: 38,
                        fontWeight: FontWeight.bold
                    )
                ),
                const SizedBox(height: 40),

                // حقل البريد الإلكتروني
                TextFormField(
                  controller: _emailController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: "البريد الإلكتروني",
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.email_outlined, color: AppColor.textappbar),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none
                    ),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'يرجى إدخال البريد' : null,
                ),
                const SizedBox(height: 20),

                // حقل كلمة السر
                TextFormField(
                  controller: _passwordController,
                  textAlign: TextAlign.right,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    hintText: "كلمة السر",
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColor.textappbar),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none
                    ),
                  ),
                  validator: (value) => (value == null || value.length < 6) ? 'كلمة السر قصيرة' : null,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PasswordForgot()));
                    },
                    child: Text(
                      "هل نسيت كلمة السر؟",
                      style: GoogleFonts.cairo(
                        color: AppColor.textappbar,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // زر تسجيل الدخول
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                        colors: [Color(0xFF800020), Color(0xFF4A0010)]
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _signIn,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent
                    ),
                    child: Text(
                        "تسجيل الدخول",
                        style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        )
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUp())
                      ),
                      child: const Text(
                          "أنشئ حساباً الآن",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF800020))
                      ),
                    ),
                    const Text("ليس لديك حساب؟"),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}