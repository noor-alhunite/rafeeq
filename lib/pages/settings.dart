import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utilities/appcolor.dart';
import 'change_password.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundDark,
      appBar: AppBar(
        title: Text(
          "الإعدادات",
          style: GoogleFonts.amiri(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.textappbar,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildSectionTitle("إعدادات الحساب"),
              _buildSettingsCard([
                _buildSettingsItem(
                  icon: Icons.person_outline,
                  title: "تعديل الملف الشخصي",
                  onTap: () {
                    // يمكن هنا إضافة صفحة تعديل الاسم لاحقاً
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.lock_outline,
                  title: "تغيير كلمة السر",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>const ChangePassword()),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 25),
              _buildSectionTitle("التطبيق"),
              _buildSettingsCard([
                _buildSettingsItem(
                  icon: Icons.language,
                  title: "تغيير اللغة",
                  trailing: const Text(
                    "العربية",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  onTap: () {
                    _showLanguageDialog(context);
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.notifications_none,
                  title: "التنبيهات",
                  trailing: Switch(
                    value: true,
                    onChanged: (val) {},
                    activeColor: AppColor.textappbar,
                  ),
                  onTap: () {},
                ),
              ]),
              const SizedBox(height: 25),
              _buildSectionTitle("الدعم والمساعدة"),
              _buildSettingsCard([
                _buildSettingsItem(
                  icon: Icons.info_outline,
                  title: "عن رفيق",
                  onTap: () {},
                ),
                _buildSettingsItem(
                  icon: Icons.contact_support_outlined,
                  title: "اتصل بنا",
                  onTap: () {},
                ),
              ]),
              const SizedBox(height: 40),
              // زر تسجيل الخروج
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    // منطق تسجيل الخروج هنا
                  },
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: Text(
                    "تسجيل الخروج",
                    style: GoogleFonts.cairo(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // مكوّن لعنوان القسم
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.cairo(
          color: AppColor.textappbar,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  // مكوّن البطاقة التي تحتوي على الخيارات
  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // مكوّن الخيار الفردي داخل البطاقة
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColor.textappbar),
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: GoogleFonts.cairo(fontSize: 16, color: AppColor.textbody2),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }

  // نافذة اختيار اللغة
  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 200,
          child: Column(
            children: [
              Text(
                "اختر اللغة",
                style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text("العربية", textAlign: TextAlign.center),
                onTap: () => Navigator.pop(context),
              ),
              const Divider(),
              ListTile(
                title: const Text("English", textAlign: TextAlign.center),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}