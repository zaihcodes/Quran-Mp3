import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_mp3/core/services/injection_dep/injection_containers.dart'
    as di;
import 'package:quran_mp3/core/services/theme/app_colors_modern.dart';
import 'package:quran_mp3/core/widgets/glass_card.dart';
import 'package:quran_mp3/core/widgets/animated_widgets.dart';
import 'package:quran_mp3/src/quran_audio/domain/entities/grouped_reciter.dart';
import 'package:quran_mp3/src/quran_audio/domain/entities/reciter.dart';
import 'package:quran_mp3/src/quran_audio/presentation/bloc/reciter/reciter_bloc.dart';
import 'package:quran_mp3/src/quran_audio/presentation/screens/reciter_detail_screen.dart';

class ModernRewayaSelectionScreen extends StatefulWidget {
  final GroupedReciter groupedReciter;

  const ModernRewayaSelectionScreen({
    super.key,
    required this.groupedReciter,
  });

  @override
  State<ModernRewayaSelectionScreen> createState() =>
      _ModernRewayaSelectionScreenState();
}

class _ModernRewayaSelectionScreenState
    extends State<ModernRewayaSelectionScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _heroController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _heroAnimation;

  final _scrollController = ScrollController();
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );

    _heroController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_backgroundController);

    _heroAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroController,
      curve: Curves.easeOutCubic,
    ));

    _backgroundController.repeat();
    _heroController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _heroController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ModernAppColors.backgroundPrimary,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Animated background
          _buildAnimatedBackground(),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ModernAppColors.primaryDeep.withValues(alpha: 0.1),
                  Colors.transparent,
                  ModernAppColors.accent.withValues(alpha: 0.05),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Main content
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildHeroHeader(size),
              _buildRewayasList(),
            ],
          ),

          // Custom back button
          _buildCustomBackButton(),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.5 + (_backgroundAnimation.value * 0.5),
              colors: [
                ModernAppColors.accentWithOpacity10,
                ModernAppColors.primaryWithOpacity10,
                ModernAppColors.backgroundPrimary,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomBackButton() {
    return SafeArea(
      child: Positioned(
        top: 16,
        left: 16,
        child: FadeInSlideUp(
          child: GlassCard(
            borderRadius: 16,
            padding: const EdgeInsets.all(12),
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ModernAppColors.textPrimary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader(Size size) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: size.height * 0.35.h,
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: ModernAppColors.primaryGradient,
              ),
            ),

            // Floating elements
            _buildFloatingElements(),

            // Main content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Animated avatar
                    AnimatedBuilder(
                      animation: _heroAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 0.5 + (_heroAnimation.value * 0.5),
                          child: Transform.rotate(
                            angle: _heroAnimation.value * 0.2,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: ModernAppColors.accentGradient,
                                boxShadow: [
                                  BoxShadow(
                                    color: ModernAppColors.accent
                                        .withValues(alpha: 0.5),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  widget.groupedReciter.letter,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 48,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Name with typing effect
                    FadeInSlideUp(
                      delay: const Duration(milliseconds: 400),
                      child: Text(
                        widget.groupedReciter.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Subtitle
                    FadeInSlideUp(
                      delay: const Duration(milliseconds: 600),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white.withValues(alpha: 0.2),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'اختر الرواية المفضلة',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.95),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingElements() {
    return Stack(
      children: [
        Positioned(
          top: 60,
          right: 20,
          child: BouncingWidget(
            duration: const Duration(milliseconds: 2000),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 140,
          left: 30,
          child: BouncingWidget(
            delay: const Duration(milliseconds: 800),
            duration: const Duration(milliseconds: 1800),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ModernAppColors.accent.withValues(alpha: 0.15),
                border: Border.all(
                  color: ModernAppColors.accent.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 50,
          child: BouncingWidget(
            delay: const Duration(milliseconds: 1200),
            duration: const Duration(milliseconds: 2200),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRewayasList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final reciter = widget.groupedReciter.rewayas[index];
            return FadeInSlideUp(
              delay: Duration(milliseconds: 200 * (index + 1)),
              child: _buildModernRewayaCard(reciter, index),
            );
          },
          childCount: widget.groupedReciter.rewayas.length,
        ),
      ),
    );
  }

  Widget _buildModernRewayaCard(Reciter reciter, int index) {
    final isSelected = _selectedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _selectedIndex = index),
        onTapUp: (_) => _handleRewayaTap(reciter),
        onTapCancel: () => setState(() => _selectedIndex = null),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..scale(isSelected ? 0.98 : 1.0),
          child: GlassCard(
            borderRadius: 24,
            padding: const EdgeInsets.all(20),
            backgroundColor: isSelected
                ? ModernAppColors.accentWithOpacity10
                : Colors.white.withValues(alpha: 0.9),
            border: Border.all(
              color: isSelected
                  ? ModernAppColors.accent.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? ModernAppColors.accent.withValues(alpha: 0.2)
                    : ModernAppColors.shadowLight,
                blurRadius: isSelected ? 25 : 15,
                offset: const Offset(0, 10),
                spreadRadius: isSelected ? 2 : -2,
              ),
            ],
            child: Row(
              children: [
                // Number indicator with animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isSelected
                        ? ModernAppColors.accentGradient
                        : LinearGradient(
                            colors: [
                              ModernAppColors.primaryDeep
                                  .withValues(alpha: 0.8),
                              ModernAppColors.primaryMedium
                                  .withValues(alpha: 0.6),
                            ],
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: (isSelected
                                ? ModernAppColors.accent
                                : ModernAppColors.primaryDeep)
                            .withValues(alpha: 0.4),
                        blurRadius: isSelected ? 20 : 10,
                        spreadRadius: isSelected ? 2 : 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: isSelected ? 22 : 18,
                          ),
                      child: Text('${index + 1}'),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? ModernAppColors.accent
                                      : ModernAppColors.textPrimary,
                                  fontSize: isSelected ? 18 : 16,
                                ),
                        child: Text(reciter.rewaya),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: isSelected
                                ? [
                                    ModernAppColors.accent
                                        .withValues(alpha: 0.2),
                                    ModernAppColors.accentLight
                                        .withValues(alpha: 0.1),
                                  ]
                                : [
                                    ModernAppColors.primaryWithOpacity20,
                                    ModernAppColors.primaryWithOpacity10,
                                  ],
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.audiotrack_rounded,
                              size: 14,
                              color: isSelected
                                  ? ModernAppColors.accent
                                  : ModernAppColors.primaryDeep,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${reciter.count} سورة',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: isSelected
                                        ? ModernAppColors.accent
                                        : ModernAppColors.primaryDeep,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow with pulse animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? ModernAppColors.accent.withValues(alpha: 0.2)
                        : ModernAppColors.primaryWithOpacity10,
                  ),
                  child: Center(
                    child: AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: isSelected ? 0.5 : 0,
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: isSelected
                            ? ModernAppColors.accent
                            : ModernAppColors.primaryDeep,
                        size: isSelected ? 24 : 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRewayaTap(Reciter reciter) {
    // Add haptic feedback
    // HapticFeedback.lightImpact();

    // Navigate with smooth transition
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
          create: (context) => di.sl<ReciterBloc>()
            ..add(GetReciterDetail(reciterId: reciter.id)),
          child: ReciterDetailScreen(reciter: reciter),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;

          final tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          final offsetAnimation = animation.drive(tween);
          final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeIn),
          );

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    ).then((_) {
      // Reset selection when returning
      setState(() => _selectedIndex = null);
    });
  }
}
