import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';

import '../advertisement_management_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "رئيسية"),
      body: Column(
        children: [
          InkWell(
  onTap: () => Get.to(() => AdvertisementManagementScreen()),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Text('إدارة الإعلانات'),
      Icon(Icons.ad_units),
    ],
  ),
),
        ],
      ),
    );
  }
}