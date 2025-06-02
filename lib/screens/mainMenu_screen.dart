import 'package:flutter/material.dart';
import '../widget/menu_card.dart';
import '../theme/appcolor.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  final List<Map<String, dynamic>> menuItems = const [
    {'title': 'Cuaca Sekarang', 'icon': Icons.wb_sunny, 'route': '/home'},
    {
      'title': 'Prakiraan Mingguan',
      'icon': Icons.calendar_today,
      'route': '/forecast',
    },
    {'title': 'Peta Cuaca', 'icon': Icons.map_outlined, 'route': '/map'},
    {
      'title': 'Lokasi Favorit',
      'icon': Icons.star_outline,
      'route': '/favorits',
    },
    {'title': 'Pengaturan', 'icon': Icons.settings, 'route': '/settings'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Menu Utama',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children:
                      menuItems.map((item) {
                        return MenuCard(
                          title: item['title'],
                          icon: item['icon'],
                          onTap: () {
                            Navigator.pushNamed(context, item['route']);
                          },
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
