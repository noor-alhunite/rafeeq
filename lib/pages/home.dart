import 'package:flutter/material.dart';
import '../utilities/appcolor.dart';
import 'package:google_fonts/google_fonts.dart';

// استيراد الصفحات
import 'profile_screen.dart';
import 'my_bookings.dart';
import 'services_page.dart';
import 'trips_page.dart';
import 'settings.dart';
import 'notifications_page.dart'; // الإضافة الجديدة: استيراد صفحة التنبيهات

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  int selectedindex = 4; // نبدأ من الصفحة الرئيسية

  // متغيرات محدد المواصفات الذكي
  double _currentValue = 50;
  double _currentValue1 = 90;
  String selectedCategory = "عائلة";
  String selectedCategory2 = "مطعم";
  String selectedDistance = "قريب";

  // قائمة الصفحات للتبديل بينها
  final List<Widget> _pages = [
    const ProfileScreen(),
    const MyBookings(),
    const ServicesPage(),
    const TripsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundDark,
      // عرض المحتوى بناءً على الصفحة المختارة
      body: selectedindex == 4 ? _buildHomeContent() : _pages[selectedindex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedindex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedItemColor: AppColor.textappbar,
        selectedLabelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.cairo(fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "حسابي"),
          BottomNavigationBarItem(icon: Icon(Icons.event_note_rounded), label: "حجوزاتي"),
          BottomNavigationBarItem(icon: Icon(Icons.home_repair_service_rounded), label: "الخدمات"),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: "الرحلات"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
        ],
        onTap: (val) {
          setState(() {
            selectedindex = val;
          });
        },
      ),
    );
  }

  // --- محتوى الصفحة الرئيسية ---
  Widget _buildHomeContent() {
    return Column(
      children: [
        _buildCustomAppBar(),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "وين بدك تروح اليوم؟",
                      style: GoogleFonts.amiri(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // كرت تحديد الميزانية والمسافة
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColor.translucentBerry.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: AppColor.translucentBerry),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildLocationButton(),
                        const SizedBox(height: 25),
                        _buildSliderSection("الميزانية", "دينار", _currentValue, 0, 1000, (val) {
                          setState(() => _currentValue = val);
                        }),
                        const SizedBox(height: 15),
                        _buildSliderSection("المسافة", "كم", _currentValue1, 0, 200, (val) {
                          setState(() => _currentValue1 = val);
                        }),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            _buildDistanceTab("بعيد"),
                            _buildDistanceTab("متوسط"),
                            _buildDistanceTab("قريب"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                  _buildSectionTitle("نوع المناسبة"),
                  const SizedBox(height: 15),
                  _buildHorizontalCategories(isEvent: true),

                  const SizedBox(height: 25),
                  _buildSectionTitle("نوع المكان"),
                  const SizedBox(height: 15),
                  _buildHorizontalCategories(isEvent: false),

                  const SizedBox(height: 40),
                  _buildSuggestButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- الـ AppBar المحدث مع ربط الجرس ---
  Widget _buildCustomAppBar() {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 10, left: 20, right: 20),
      color: AppColor.backgroundDark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildAppBarIcon(Icons.search, () {
                // منطق البحث
              }),
              const SizedBox(width: 10),

              // تم الربط هنا بصفحة التنبيهات
              _buildAppBarIcon(Icons.notifications_none_rounded, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsPage()),
                );
              }),
            ],
          ),
          Text("رفيق", style: GoogleFonts.lateef(fontSize: 45, color: AppColor.textappbar)),
          _buildAppBarIcon(Icons.list_sharp, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Settings()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAppBarIcon(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: IconButton(
          icon: Icon(icon, color: AppColor.textappbar, size: 22),
          onPressed: onTap
      ),
    );
  }

  // --- بقية المكونات المساعدة ---
  Widget _buildLocationButton() {
    return Container(
      width: 180,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.textappbar),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("استخدم موقعي", style: GoogleFonts.cairo(color: AppColor.textappbar, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Icon(Icons.my_location, color: AppColor.textappbar, size: 20),
        ],
      ),
    );
  }

  Widget _buildSliderSection(String title, String unit, double value, double min, double max, Function(double) onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColor.textappbar)),
              child: Text("${value.round()} $unit", style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            Text(title, style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: AppColor.textappbar,
          inactiveColor: AppColor.textappbar.withOpacity(0.2),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDistanceTab(String label) {
    bool isSelected = selectedDistance == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedDistance = label),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? AppColor.textappbar : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.textappbar),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.cairo(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(title, style: GoogleFonts.amiri(fontSize: 28, fontWeight: FontWeight.bold, color: AppColor.textappbar)),
    );
  }

  Widget _buildHorizontalCategories({required bool isEvent}) {
    List<Map<String, String>> data = isEvent
        ? [{"t": "عائلة", "e": "👨‍👩‍👧‍👦"}, {"t": "أصدقاء", "e": "👥"}, {"t": "رومانسي", "e": "💖"}, {"t": "منفرد", "e": "🚶"}, {"t": "عمل", "e": "💼"}]
        : [{"t": "مطعم", "e": "🍽️"}, {"t": "مقهى", "e": "☕️"}, {"t": "حديقة", "e": "🌳"}, {"t": "شاطىء", "e": "🏖️"}, {"t": "منتجع", "e": "🏨"}];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: data.map((item) => _buildCategoryCard(item["t"]!, item["e"]!, isEvent)).toList(),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String emoji, bool isEvent) {
    bool isSelected = isEvent ? selectedCategory == title : selectedCategory2 == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isEvent) selectedCategory = title; else selectedCategory2 = title;
        });
      },
      child: Container(
        width: 85, height: 95,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.textappbar : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 5),
            Text(title, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColor.textappbar)),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestButton() {
    return InkWell(
      onTap: () {
        // منطق الاقتراحات من Firestore
      },
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(colors: [AppColor.textappbar, Color(0xFF4A0010)]),
          boxShadow: [BoxShadow(color: AppColor.textappbar.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFFD4AF37)),
              const SizedBox(width: 12),
              Text("اقترح مكاناً", style: GoogleFonts.amiri(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}