import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utilities/appcolor.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 10, // مساحة صغيرة فوق التبويبات
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColor.textappbar,
          indicatorWeight: 3,
          labelColor: AppColor.textappbar,
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16),
          tabs: const [
            Tab(text: "أماكن فردية"),
            Tab(text: "رحلات جماعية"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const Center(child: Text("قريباً: أماكن فردية")), // محتوى تجريبي
          _buildGroupTripsSection(), // قسم الرحلات الجماعية كما في الصورة
        ],
      ),
    );
  }

  // --- قسم الرحلات الجماعية ---
  Widget _buildGroupTripsSection() {
    return Column(
      children: [
        // شريط التصنيفات (رحلة يومية، نهاية الأسبوع، تخييم)
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 10),
          color: Colors.white,
          child: ListView(
            scrollDirection: Axis.horizontal,
            reverse: true, // لتبدأ القائمة من اليمين
            children: [
              _buildFilterChip("رحلة يومية", isSelected: true),
              _buildFilterChip("نهاية الأسبوع"),
              _buildFilterChip("تخييم"),
            ],
          ),
        ),
        // قائمة الرحلات
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(15),
            children: [
              _buildTripCard(
                title: "رحلة إلى البحر الميت",
                date: "الجمعة 25 مارس",
                time: "8:00 صباحاً",
                location: "مجمع السيارات الشمالي",
                price: "25 دينار",
                bookedPercentage: 0.75,
                seatsLeft: 5,
                imagePath: 'assets/dead_sea.jpg', // استبدليها بمسار الصورة الحقيقي
              ),
              _buildTripCard(
                title: "رحلة إلى البتراء",
                date: "السبت 26 مارس",
                time: "7:00 صباحاً",
                location: "مجمع العبدلي",
                price: "35 دينار",
                bookedPercentage: 0.40,
                seatsLeft: 8,
                imagePath: 'assets/petra.jpg',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- مكون التصنيفات (Filter Chip) ---
  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) {},
        selectedColor: AppColor.textappbar,
        labelStyle: GoogleFonts.cairo(
          color: isSelected ? Colors.white : AppColor.textappbar,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.white,
        shape: StadiumBorder(side: BorderSide(color: AppColor.textappbar)),
      ),
    );
  }

  // --- مكون بطاقة الرحلة (Trip Card) ---
  Widget _buildTripCard({
    required String title,
    required String date,
    required String time,
    required String location,
    required String price,
    required double bookedPercentage,
    required int seatsLeft,
    required String imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          // الجزء العلوي: الصورة مع ملصق المقاعد المتبقية
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[300], // لون مؤقت
                  child: const Center(child: Icon(Icons.image, size: 50, color: Colors.white)),
                  // Image.asset(imagePath, fit: BoxFit.cover), // استخدمي هذا عند توفر الصور
                ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "$seatsLeft مقاعد متبقية",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          // الجزء السفلي: التفاصيل
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title, style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildInfoRow(date, Icons.calendar_today_outlined),
                _buildInfoRow(time, Icons.access_time),
                _buildInfoRow(location, Icons.location_on_outlined),
                const SizedBox(height: 15),
                Text(price, style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.textappbar)),
                const SizedBox(height: 10),
                // الخدمات (تكييف، واي فاي، إلخ)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildFeatureIcon(Icons.person, "مرشد سياحي"),
                    _buildFeatureIcon(Icons.wifi, "واي فاي"),
                    _buildFeatureIcon(Icons.ac_unit, "تكييف"),
                  ],
                ),
                const SizedBox(height: 15),
                // شريط نسبة الحجز
                LinearProgressIndicator(
                  value: bookedPercentage,
                  backgroundColor: Colors.grey[200],
                  color: AppColor.textappbar,
                  minHeight: 8,
                ),
                const SizedBox(height: 20),
                // زر الحجز
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.textappbar,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text("احجز الآن", style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // مكوّن مساعد لصفوف المعلومات
  Widget _buildInfoRow(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          const SizedBox(width: 8),
          Icon(icon, size: 16, color: Colors.grey[600]),
        ],
      ),
    );
  }

  // مكوّن مساعد لأيقونات الخدمات
  Widget _buildFeatureIcon(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(width: 4),
          Icon(icon, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}