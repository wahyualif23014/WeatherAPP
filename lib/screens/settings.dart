import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widget/settings_item.dart';
import '../widget/animated_backgrounds.dart';
import '../widget/settings_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          const AnimatedBackground(opacity: 0.7),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(), 
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Settings",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const SettingsSection(
                    title: "General",
                    items: [
                      SettingsItem(
                          icon: Icons.person_outline,
                          title: "Profile",
                          onTap: null),
                      SettingsItem(
                          icon: Icons.notifications_outlined,
                          title: "Notifcations",
                          onTap: null),
                      SettingsItem(
                          icon: Icons.language,
                          title: "Language",
                          onTap: null),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SettingsSection(
                    title: "Privacy & Security",
                    items: [
                      SettingsItem(
                          icon: Icons.lock_outline,
                          title: "Account Security",
                          onTap: null),
                      SettingsItem(
                          icon: Icons.fingerprint,
                          title: "Autentications",
                          onTap: null),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SettingsSection(
                    title: "Others",
                    items: [
                      SettingsItem(
                          icon: Icons.help_outline,
                          title: "Help & Support",
                          onTap: null),
                      SettingsItem(
                          icon: Icons.info_outline,
                          title: "About App",
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