import 'package:flutter/material.dart';
import 'package:garga/main.dart';
import 'package:garga/models/stats.dart';
import 'package:garga/pages/admin/promo_codes.dart';
import 'package:get/get.dart';
import 'package:garga/controllers/getDataController.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    var dataController = Get.find<GetDataController>();

    // Fetch role synchronously from SharedPreferences
    bool isAdmin = (prefs.getString("role") ?? "merchant") == "admin";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: !isAdmin
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Navigate to the promo codes page
                  Get.to(() => const PromoCodesPage());
                },
                child: const Text("Manage Promo Codes"),
              ),
            ),
      body: GetBuilder<GetDataController>(builder: (controller) {
        String role =
            prefs.getString("role") ?? "merchant"; // Default to merchant

        var stats = dataController.statsResponse?.stats ?? [];

        if (dataController.statsResponse == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Hide "Total Users" if the role is not admin
        if (role != "admin") {
          stats = stats.where((stat) => stat.title != "Total Users").toList();
        }

        return stats.isEmpty
            ? const Center(
                child: Text(
                  "No data available",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two cards per row
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: stats.length,
                  itemBuilder: (context, index) {
                    return _buildStatCard(stats[index], index);
                  },
                ),
              );
      }),
    );
  }

  Widget _buildStatCard(Stat stat, int index) {
    List<Color> colors = [
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.orange.shade100,
      Colors.purple.shade100,
    ];

    List<Color> textColors = [
      Colors.blue.shade900,
      Colors.green.shade900,
      Colors.orange.shade900,
      Colors.purple.shade900,
    ];

    List<IconData> icons = [
      LucideIcons.shoppingCart, // Total Products
      LucideIcons.box, // Total Orders
      LucideIcons.dollarSign, // Monthly Income
      LucideIcons.piggyBank, // Total Income

      LucideIcons.users, // Total Users
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors[index % colors.length],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icons[index % icons.length],
            size: 34,
            color: textColors[index % textColors.length],
          ),
          const SizedBox(height: 12),
          Text(
            stat.title ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColors[index % textColors.length],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            stat.value.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColors[index % textColors.length],
            ),
          ),
        ],
      ),
    );
  }
}
