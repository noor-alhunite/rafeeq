import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectrafeec1/pages/my_bookings.dart';
import 'package:projectrafeec1/pages/settings.dart';
import '../utilities/appcolor.dart'; // تأكدي من مسار ملف الألوان الخاص بكِ

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // الجزء العلوي: الصورة والاسم
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColor.textappbar, width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFFF5F5F5),
                      child: Icon(Icons.person, size: 60, color: Color(0xFF5D3A76)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "أحمد محمد",
                    style: GoogleFonts.cairo(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "١٢ حجز",
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // قائمة الخيارات (تظهر كما في الصورة المرفقة)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildProfileOption(
                    icon: Icons.calendar_today_outlined,
                    title: "حجوزاتي",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>const MyBookings()),
                      );
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.favorite_border,
                    title: "المفضلة",
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    icon: Icons.credit_card,
                    title: "طرق الدفع",
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    icon: Icons.settings_outlined,
                    title: "الإعدادات",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>const Settings()),
                      );
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.phone_in_talk_outlined,
                    title: "اتصل بنا",
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  // زر تسجيل الخروج بلون مختلف قليلاً
                  _buildProfileOption(
                    icon: Icons.logout,
                    title: "تسجيل الخروج",
                    isLogout: true,
                    onTap: () {
                      // منطق تسجيل الخروج
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // مكوّن الخيار الفردي في القائمة
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(Icons.arrow_back_ios, size: 16, color: Colors.grey[400]),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isLogout ? Colors.redAccent : Colors.black87,
              ),
            ),
            const SizedBox(width: 15),
            Icon(icon, color: isLogout ? Colors.redAccent : AppColor.textappbar),
          ],
        ),
      ),
    );
  }
}