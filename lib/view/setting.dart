import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:praktikum_1/widget/navigation.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0.0,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/photo-1534528741775-53994a69daeb.webp"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      "Arwin Marinta",
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                    )
                  ],
                ),
                const SizedBox(height: 40.0),
                Column(
                  children: [
                    GestureDetector(
                      onTap: null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: Colors.grey[200],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Pengaturan"),
                            Icon(Bootstrap.chevron_right, size: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: Colors.grey[200],
                        ),
                        child: const Text("Pengaturan"),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: Colors.grey[200],
                        ),
                        child: const Text("Pengaturan"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: 2,
        onItemTapped: (int index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/cart');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }
}