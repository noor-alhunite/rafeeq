import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utilities/appcolor.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCarType = "سيدان"; // لتخزين السيارة المختارة

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
        elevation: 2,
        shadowColor: Colors.black12,
        title: Text(
          "خدمات رفيق",
          style: GoogleFonts.amiri(color: AppColor.textappbar, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColor.textappbar,
          indicatorWeight: 3,
          labelColor: AppColor.textappbar,
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16),
          tabs: const [
            Tab(text: "ركوب إلى المكان"),
            Tab(text: "استئجار سيارة"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRideSection(),
          _buildRentalSection(),
        ],
      ),
    );
  }

  // --- قسم طلب التوصيل ---
  Widget _buildRideSection() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildLocationInput(
          label: "من أين؟",
          hint: "موقعك الحالي",
          icon: Icons.my_location,
          isCurrentLocation: true,
        ),
        const SizedBox(height: 15),
        _buildLocationInput(
          label: "إلى أين؟",
          hint: "وجهتك المقصودة",
          icon: Icons.location_on,
          isCurrentLocation: false,
        ),
        const SizedBox(height: 30),
        Text(
          "الفئات المتاحة",
          textAlign: TextAlign.right,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 18, color: AppColor.textappbar),
        ),
        const SizedBox(height: 15),
        _buildCarOption(
          id: "سيدان",
          title: "سيدان اقتصادية",
          desc: "4 ركاب • موفرة",
          price: "8.50 JOD",
          icon: Icons.directions_car_filled,
        ),
        _buildCarOption(
          id: "SUV",
          title: "SUV عائلية",
          desc: "6 ركاب • مريحة",
          price: "12.00 JOD",
          icon: Icons.directions_car,
        ),
        _buildCarOption(
          id: "فان",
          title: "حافلة صغيرة (Van)",
          desc: "8 ركاب • رحلات جماعية",
          price: "18.00 JOD",
          icon: Icons.airport_shuttle,
        ),
        const SizedBox(height: 30),
        _buildMainButton("تأكيد طلب الركوب", () {
          // منطق الطلب
        }),
      ],
    );
  }

  // --- قسم استئجار السيارات ---
  Widget _buildRentalSection() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildRentalCard(
          name: "تويوتا كورولا 2025",
          specs: "أوتوماتيك • 5 مقاعد",
          price: "35 JOD",
          color: Colors.blueAccent,
        ),
        _buildRentalCard(
          name: "هونداي توسان 2025",
          specs: "دفع رباعي • عائلية",
          price: "50 JOD",
          color: Colors.orangeAccent,
        ),
        _buildRentalCard(
          name: "مرسيدس C-Class",
          specs: "فاخرة • خدمات VIP",
          price: "90 JOD",
          color: Colors.black87,
        ),
      ],
    );
  }

  // --- مكونات واجهة المستخدم (Widgets) ---

  Widget _buildLocationInput({required String label, required String hint, required IconData icon, bool isCurrentLocation = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[700])),
        const SizedBox(height: 8),
        TextField(
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: isCurrentLocation ? Icon(Icons.gps_fixed, color: AppColor.textappbar, size: 20) : null,
            suffixIcon: Icon(icon, color: AppColor.textappbar),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[100]!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarOption({required String id, required String title, required String desc, required String price, required IconData icon}) {
    bool isSelected = _selectedCarType == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedCarType = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColor.textappbar : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Text(price, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: AppColor.textappbar)),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(desc, style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(width: 15),
            Icon(icon, size: 35, color: isSelected ? AppColor.textappbar : Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildRentalCard({required String name, required String specs, required String price, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Center(child: Icon(Icons.directions_car_filled, size: 80, color: color)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.textappbar,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("احجز الآن", style: GoogleFonts.cairo(color: Colors.white)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(name, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(specs, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
                    Text("$price / يومياً", style: GoogleFonts.cairo(color: AppColor.textappbar, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(colors: [Color(0xFF800020), Color(0xFF4A0010)]),
        boxShadow: [BoxShadow(color: const Color(0xFF800020).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
        child: Text(text, style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}