// settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widget/settings_item.dart';
import '../widget/animated_backgrounds.dart';
import '../widget/settings_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // Latar belakang beranimasi
          const AnimatedBackground(opacity: 0.6),

          // Konten utama dengan scroll
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(), // Efek iOS-like
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pengaturan",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const SettingsSection(
                    title: "Umum",
                    items: [
                      SettingsItem(
                          icon: Icons.person_outline,
                          title: "Profil",
                          onTap: null),
                      SettingsItem(
                          icon: Icons.notifications_outlined,
                          title: "Notifikasi",
                          onTap: null),
                      SettingsItem(
                          icon: Icons.language,
                          title: "Bahasa",
                          onTap: null),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SettingsSection(
                    title: "Privasi & Keamanan",
                    items: [
                      SettingsItem(
                          icon: Icons.lock_outline,
                          title: "Keamanan Akun",
                          onTap: null),
                      SettingsItem(
                          icon: Icons.fingerprint,
                          title: "Autentikasi",
                          onTap: null),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SettingsSection(
                    title: "Lainnya",
                    items: [
                      SettingsItem(
                          icon: Icons.help_outline,
                          title: "Bantuan",
                          onTap: null),
                      SettingsItem(
                          icon: Icons.info_outline,
                          title: "Tentang Aplikasi",
                          onTap: null),
                    ],
                  ),
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: Navigator.of(context).pop,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}