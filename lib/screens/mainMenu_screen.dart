import 'package:flutter/material.dart';
import '../widget/menu_card.dart';
import '../theme/appcolor.dart';
import 'package:flutter/services.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _parallaxController;
  late ScrollController _scrollController;

  late List<AnimationController> _cardControllers;
  late List<Animation<double>> _cardAnimations;
  late List<Animation<Offset>> _slideAnimations;

  double _scrollOffset = 0.0;

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
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _parallaxController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _scrollController =
        ScrollController()..addListener(() {
          setState(() {
            _scrollOffset = _scrollController.offset;
          });
        });

    _cardControllers = List.generate(
      menuItems.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 600 + (index * 100)),
        vsync: this,
      ),
    );

    _cardAnimations =
        _cardControllers.map((controller) {
          return Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
          );
        }).toList();

    _slideAnimations =
        _cardControllers.map((controller) {
          return Tween<Offset>(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
          );
        }).toList();

    _startAnimations();
  }

  void _startAnimations() async {
    _fadeController.forward();
    _parallaxController.repeat();

    for (int i = 0; i < _cardControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: i * 150));
      if (mounted) {
        _cardControllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _parallaxController.dispose();
    _scrollController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryDark,
              AppColors.primaryDark.withOpacity(0.8),
              const Color(0xFF1a237e),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            _buildAnimatedBackground(),

            
            SafeArea(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader()),

                  SliverPadding(
                    padding: const EdgeInsets.all(24.0),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.1,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildAnimatedMenuCard(index),
                        childCount: menuItems.length,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 50)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _parallaxController,
      builder: (context, child) {
        return Stack(
          children: [
            ...List.generate(6, (index) {
              final offset =
                  (_parallaxController.value * 360 + index * 60) % 360;
              final x =
                  MediaQuery.of(context).size.width *
                  (0.1 + 0.8 * ((offset / 360) % 1));
              final y =
                  MediaQuery.of(context).size.height *
                  (0.1 + 0.6 * ((offset / 180) % 1));

              return Positioned(
                left: x - _scrollOffset * 0.1,
                top: y - _scrollOffset * 0.05,
                child: Container(
                  width: 4 + (index % 3) * 2,
                  height: 4 + (index % 3) * 2,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1 + (index % 3) * 0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),

            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.5,
                  colors: [Colors.white.withOpacity(0.05), Colors.transparent],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeController,
      child: Transform.translate(
        offset: Offset(0, -_scrollOffset * 0.3),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome text with shimmer effect
              ShaderMask(
                shaderCallback:
                    (bounds) => LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.8),
                        Colors.white,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                      transform: GradientRotation(
                        _parallaxController.value * 6.28,
                      ),
                    ).createShader(bounds),
                child: const Text(
                  'Menu Utama',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Pilih layanan yang Anda butuhkan',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 20),

              // Decorative line
              Container(
                height: 3,
                width: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Colors.transparent],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedMenuCard(int index) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _cardAnimations[index],
        child: Transform.scale(
          scale: 1.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Glass morphism background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                  ),

                  // Menu card content
                  MenuCard(
                    title: menuItems[index]['title'],
                    icon: menuItems[index]['icon'],
                    onTap: () {
                      // Add haptic feedback
                      HapticFeedback.lightImpact();

                      // Add scale animation on tap
                      _cardControllers[index].reverse().then((_) {
                        _cardControllers[index].forward();
                      });

                      Navigator.pushNamed(context, menuItems[index]['route']);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
