import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utilities/appcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // إضافة الفايرستور
import 'package:firebase_auth/firebase_auth.dart'; // إضافة مكتبة المستخدم

class MyBookings extends StatefulWidget {
  const MyBookings({super.key});

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

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
        title: Text(
          "رحلاتي وحجوزاتي",
          style: GoogleFonts.amiri(
            color: AppColor.textappbar,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColor.textappbar,
          labelColor: AppColor.textappbar,
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "الرحلات القادمة"),
            Tab(text: "السابقة"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingsStream(isActive: true), // جلب الحجوزات النشطة
          _buildBookingsStream(isActive: false), // جلب الحجوزات المكتملة/الملغية
        ],
      ),
    );
  }

  // دالة لجلب البيانات حياً من Firestore
  Widget _buildBookingsStream({required bool isActive}) {
    return StreamBuilder<QuerySnapshot>(
      // فلترة الحجوزات حسب UserId وحسب الحالة (نشط أم لا)
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: currentUserId)
          .where('is_active', isEqualTo: isActive)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              isActive ? "لا توجد رحلات قادمة" : "لا توجد حجوزات سابقة",
              style: GoogleFonts.cairo(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;

            // تحديد اللون بناءً على الحالة المخزنة
            Color statusColor = Colors.green;
            if (data['status'] == 'قيد الانتظار') statusColor = Colors.orange;
            if (data['status'] == 'ملغي') statusColor = Colors.red;
            if (data['status'] == 'جاري التوصيل') statusColor = Colors.blue;

            return _buildBookingCard(
              title: data['title'] ?? 'بدون عنوان',
              date: data['date'] ?? '',
              time: data['time'] ?? '',
              status: data['status'] ?? '',
              icon: _getIconForType(data['type']), // اختيار الأيقونة حسب نوع الخدمة
              color: statusColor,
            );
          },
        );
      },
    );
  }

  // دالة لاختيار الأيقونة المناسبة
  IconData _getIconForType(String? type) {
    switch (type) {
      case 'restaurant': return Icons.restaurant;
      case 'ride': return Icons.local_taxi;
      case 'rental': return Icons.car_rental;
      default: return Icons.bookmark;
    }
  }

  Widget _buildBookingCard({
    required String title,
    required String date,
    required String time,
    required String status,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.backgroundDark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColor.textappbar, size: 30),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(time, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(width: 5),
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 10),
                      Text(date, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(width: 5),
                      const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: GoogleFonts.cairo(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}