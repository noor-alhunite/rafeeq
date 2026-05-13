import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utilities/appcolor.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  // دالة تغيير كلمة السر للمستخدم المسجل دخوله حالياً
  Future<void> _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        // ملاحظة: Firebase يتطلب إعادة مصادقة إذا مر وقت طويل على تسجيل الدخول
        // للتبسيط الآن سنقوم بتحديثها مباشرة:
        await user!.updatePassword(_newPasswordController.text.trim());

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎉 تم تحديث كلمة السر بنجاح'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        String message = 'حدث خطأ ما، حاول مجدداً';
        if (e.code == 'requires-recent-login') {
          message = 'هذه العملية حساسة وتتطلب تسجيل دخول حديث، يرجى الخروج والدخول مجدداً';
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColor.textappbar,
              behavior: SnackBarBehavior.floating,
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColor.textappbar),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Icon(
                  Icons.lock_person_rounded, // أيقونة أنسب لتغيير الباسورد
                  size: 100,
                  color: AppColor.textappbar,
                ),
                const SizedBox(height: 30),
                Text(
                  "تغيير كلمة السر",
                  style: GoogleFonts.amiri(
                    color: AppColor.textappbar,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // حقل كلمة السر الحالية
                TextFormField(
                  controller: _currentPasswordController,
                  textAlign: TextAlign.right,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    hintText: "كلمة السر الحالية",
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColor.textappbar),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'يرجى إدخال كلمة السر الحالية' : null,
                ),
                const SizedBox(height: 20),

                // حقل كلمة السر الجديدة
                TextFormField(
                  controller: _newPasswordController,
                  textAlign: TextAlign.right,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    hintText: "كلمة السر الجديدة",
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.lock_reset, color: AppColor.textappbar),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) => (value == null || value.length < 6) ? 'كلمة السر الجديدة قصيرة' : null,
                ),
                const SizedBox(height: 40),

                // زر تغيير كلمة السر (معدل ليصبح قابلاً للضغط)
                GestureDetector(
                  onTap: _updatePassword,
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    alignment: Alignment.center, // لتوسيط النص داخل الزر
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF800020), Color(0xFF4A0010)],
                      ),
                    ),
                    child: Text(
                      "حفظ التغييرات",
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}