import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utilities/appcolor.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      backgroundColor: AppColor.backgroundDark,
      appBar: AppBar(
        title: Text(
          "التنبيهات",
          style: GoogleFonts.amiri(
            color: AppColor.textappbar,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColor.textappbar),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // جلب الحجوزات النشطة للمستخدم الحالي
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: currentUserId)
            .where('is_active', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColor.textappbar));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;

              return _buildNotificationCard(
                title: "تذكير بموعد: ${data['title']}",
                body: "موعدك القادم في تاريخ ${data['date']} الساعة ${data['time']}. نتمنى لك رحلة سعيدة!",
                time: "الآن",
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard({required String title, required String body, required String time}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.textappbar.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(time, style: GoogleFonts.cairo(color: AppColor.textappbar, fontSize: 10)),
              ),
              const Icon(Icons.notifications_active, color: Colors.orangeAccent, size: 22),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 5),
          Text(
            body,
            style: GoogleFonts.cairo(color: Colors.black54, fontSize: 13, height: 1.5),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_outlined, size: 100, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 20),
          Text(
            "لا يوجد تنبيهات قادمة",
            style: GoogleFonts.cairo(color: Colors.grey, fontSize: 18),
          ),
          Text(
            "حجوزاتك الجديدة ستظهر هنا",
            style: GoogleFonts.cairo(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}