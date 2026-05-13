import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utilities/appcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'log_in.dart';
import 'home.dart'; // تأكدي من استيراد صفحة الهوم هنا

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

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
                const SizedBox(height: 60),
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
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                    "إنشاء حساب جديد",
                    style: GoogleFonts.amiri(
                        color: AppColor.textappbar,
                        fontSize: 32,
                        fontWeight: FontWeight.bold
                    )
                ),
                const SizedBox(height: 30),

                TextFormField(
                  controller: _nameController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                      hintText: "الاسم الكامل",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.person_outline, color: AppColor.textappbar),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'يرجى إدخال الاسم' : null,
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: _emailController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                      hintText: "البريد الإلكتروني",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColor.textappbar),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)
                  ),
                  validator: (value) => (value == null || !value.contains('@')) ? 'بريد إلكتروني غير صالح' : null,
                ),
                const SizedBox(height: 15),

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
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)
                  ),
                  validator: (value) => (value == null || value.length < 6) ? 'كلمة السر قصيرة جداً' : null,
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: _confirmPasswordController,
                  textAlign: TextAlign.right,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                      hintText: "تأكيد كلمة السر",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.lock_reset, color: AppColor.textappbar),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) return 'كلمات السر غير متطابقة';
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(colors: [Color(0xFF800020), Color(0xFF4A0010)])
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.white)),
                          );

                          final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );

                          final String uid = userCredential.user!.uid;

                          await FirebaseFirestore.instance.collection('users').doc(uid).set({
                            'name': _nameController.text.trim(),
                            'email': _emailController.text.trim(),
                            'bookings_count': 0,
                            'image_url': '',
                            'member_since': FieldValue.serverTimestamp(),
                          });

                          await userCredential.user!.updateDisplayName(_nameController.text.trim());

                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("🎉 أهلاً بك في رفيق! تم الدخول بنجاح"),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );

                            // التعديل هنا: الانتقال مباشرة لصفحة الـ Home
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const Home())
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (mounted) Navigator.pop(context);
                          String errorMessage = "حدث خطأ غير متوقع";
                          if (e.code == 'weak-password') {
                            errorMessage = 'كلمة السر ضعيفة جداً';
                          } else if (e.code == 'email-already-in-use') {
                            errorMessage = 'هذا البريد مسجل بالفعل';
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              backgroundColor: AppColor.textappbar,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent
                    ),
                    child: Text(
                        "إنشاء حساب",
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
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                            "سجل دخولك الآن",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF800020))
                        )
                    ),
                    const Text("لديك حساب بالفعل؟"),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}