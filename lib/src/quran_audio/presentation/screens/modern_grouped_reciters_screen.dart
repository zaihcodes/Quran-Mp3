import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_mp3/core/services/injection_dep/injection_containers.dart'
    as di;
import 'package:quran_mp3/core/services/theme/app_colors_modern.dart';
import 'package:quran_mp3/core/widgets/glass_card.dart';
import 'package:quran_mp3/core/widgets/animated_widgets.dart';
import 'package:quran_mp3/src/quran_audio/domain/entities/grouped_reciter.dart';
import 'package:quran_mp3/src/quran_audio/presentation/bloc/reciter/reciter_bloc.dart';
import 'package:quran_mp3/src/quran_audio/presentation/screens/modern_rewaya_selection_screen.dart';
import 'package:quran_mp3/src/quran_audio/presentation/screens/reciter_detail_screen.dart';
import 'package:quran_mp3/src/quran_audio/presentation/widgets/error_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModernGroupedRecitersScreen extends StatefulWidget {
  const ModernGroupedRecitersScreen({super.key});

  @override
  State<ModernGroupedRecitersScreen> createState() =>
      _ModernGroupedRecitersScreenState();
}

class _ModernGroupedRecitersScreenState
    extends State<ModernGroupedRecitersScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_backgroundController);

    _backgroundController.repeat();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Hide/show search based on scroll position
    if (_scrollController.offset > 100 && !_isSearchVisible) {
      setState(() => _isSearchVisible = true);
    } else if (_scrollController.offset <= 100 && _isSearchVisible) {
      setState(() => _isSearchVisible = false);
    }
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
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

          // Main content
          BlocListener<ReciterBloc, ReciterState>(
            listener: (context, state) {
              if (state.status == ReciterStateStatus.error &&
                  state.errorCode == 'FILTER_GROUPED_ERROR') {
                _showErrorSnackBar(state.errorMessage ?? 'حدث خطأ أثناء البحث');
              }
            },
            child: BlocBuilder<ReciterBloc, ReciterState>(
              builder: (context, state) {
                return CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildModernAppBar(size),
                    _buildSearchSection(),
                    _buildContent(state),
                  ],
                );
              },
            ),
          ),

          // Floating search overlay
          if (_isSearchVisible) _buildFloatingSearch(),
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
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform:
                  GradientRotation(_backgroundAnimation.value * 2 * 3.14159),
              colors: [
                ModernAppColors.backgroundPrimary,
                ModernAppColors.backgroundSecondary,
                ModernAppColors.primaryWithOpacity10,
                ModernAppColors.accentWithOpacity10,
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernAppBar(Size size) {
    return SliverAppBar(
      expandedHeight: size.height * 0.35.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: ModernAppColors.primaryGradient,
          ),
          child: Stack(
            children: [
              // Floating orbs
              _buildFloatingOrbs(),

              // Main content
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      // App icon with glow effect
                      ScaleInAnimation(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: ModernAppColors.accentGradient,
                            boxShadow: [
                              BoxShadow(
                                color: ModernAppColors.accent
                                    .withValues(alpha: 0.4),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.headphones,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Title with typing animation effect
                      FadeInSlideUp(
                        delay: const Duration(milliseconds: 300),
                        child: Text(
                          'القرآن الكريم',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
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
                        delay: const Duration(milliseconds: 500),
                        child: Text(
                          'استمع للقرآن الكريم بأصوات أجمل القراء',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }

  Widget _buildFloatingOrbs() {
    return Stack(
      children: [
        Positioned(
          top: 50,
          right: 30,
          child: BouncingWidget(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 120,
          left: 40,
          child: BouncingWidget(
            delay: const Duration(milliseconds: 500),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ModernAppColors.accent.withValues(alpha: 0.2),
                border: Border.all(
                  color: ModernAppColors.accent.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          right: 60,
          child: BouncingWidget(
            delay: const Duration(milliseconds: 1000),
            child: Container(
              width: 80,
              height: 80,
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
      ],
    );
  }

  Widget _buildSearchSection() {
    return SliverToBoxAdapter(
      child: FadeInSlideUp(
        delay: const Duration(milliseconds: 700),
        child: Container(
          margin: const EdgeInsets.all(24),
          child: GlassCard(
            borderRadius: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                context
                    .read<ReciterBloc>()
                    .add(FilterGroupedReciters(query: query));
              },
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: ModernAppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'ابحث عن القراء...',
                hintStyle: const TextStyle(
                  color: ModernAppColors.textTertiary,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: ModernAppColors.accentGradient,
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: ModernAppColors.textTertiary,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          context
                              .read<ReciterBloc>()
                              .add(const FilterGroupedReciters(query: ''));
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ReciterState state) {
    if (state.status == ReciterStateStatus.loadingGrouped) {
      return _buildLoadingState();
    } else if (state.status == ReciterStateStatus.error) {
      return _buildErrorState(state);
    } else if (state.status == ReciterStateStatus.loadedGrouped) {
      return _buildRecitersList(state.filteredGroupedReciters);
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  Widget _buildLoadingState() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: List.generate(6, (index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: const ShimmerLoading(
                width: double.infinity,
                height: 100,
                borderRadius: 20,
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildErrorState(ReciterState state) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(24),
        child: DataErrorWidget(
          errorMessage: state.errorMessage,
          onRetry: () {
            context.read<ReciterBloc>().add(GetGroupedReciters());
          },
        ),
      ),
    );
  }

  Widget _buildRecitersList(List<GroupedReciter> groupedReciters) {
    if (groupedReciters.isEmpty) {
      return _buildEmptyState();
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final groupedReciter = groupedReciters[index];
            return FadeInSlideUp(
              delay: Duration(milliseconds: 100 * (index % 6)),
              child: _buildModernReciterCard(groupedReciter, index),
            );
          },
          childCount: groupedReciters.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          children: [
            ScaleInAnimation(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: ModernAppColors.glassGradient,
                  border: Border.all(
                    color: ModernAppColors.primaryWithOpacity20,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.search_off,
                  size: 60,
                  color: ModernAppColors.textTertiary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'لم يتم العثور على قراء',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ModernAppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'حاول البحث بطريقة مختلفة',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: ModernAppColors.textTertiary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernReciterCard(GroupedReciter groupedReciter, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: GradientCard(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ModernAppColors.cardBackground,
            ModernAppColors.cardBackgroundSoft,
            ModernAppColors.primaryWithOpacity10,
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
        borderRadius: 24,
        padding: const EdgeInsets.all(20),
        onTap: () => _handleReciterTap(groupedReciter),
        boxShadow: [
          const BoxShadow(
            color: ModernAppColors.shadowLight,
            blurRadius: 20,
            offset: Offset(0, 10),
            spreadRadius: -5,
          ),
          BoxShadow(
            color: ModernAppColors.primaryWithOpacity10,
            blurRadius: 40,
            offset: const Offset(0, 20),
            spreadRadius: -10,
          ),
        ],
        child: Row(
          children: [
            // Avatar with gradient and glow
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: groupedReciter.hasMultipleRewayas
                    ? ModernAppColors.accentGradient
                    : ModernAppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: (groupedReciter.hasMultipleRewayas
                            ? ModernAppColors.accent
                            : ModernAppColors.primaryDeep)
                        .withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  groupedReciter.letter,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                ),
              ),
            ),

            const SizedBox(width: 20),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    groupedReciter.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: ModernAppColors.textPrimary,
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: groupedReciter.hasMultipleRewayas
                            ? [
                                ModernAppColors.accent.withValues(alpha: 0.2),
                                ModernAppColors.accentLight
                                    .withValues(alpha: 0.1),
                              ]
                            : [
                                ModernAppColors.sage.withValues(alpha: 0.2),
                                ModernAppColors.mint.withValues(alpha: 0.1),
                              ],
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          groupedReciter.hasMultipleRewayas
                              ? Icons.library_books_rounded
                              : Icons.audiotrack_rounded,
                          size: 16,
                          color: groupedReciter.hasMultipleRewayas
                              ? ModernAppColors.accent
                              : ModernAppColors.sage,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          groupedReciter.hasMultipleRewayas
                              ? '${groupedReciter.totalRewayas} روايات'
                              : groupedReciter.mainRewaya,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: groupedReciter.hasMultipleRewayas
                                        ? ModernAppColors.accent
                                        : ModernAppColors.sage,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Arrow with animation
            PulseAnimation(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: groupedReciter.hasMultipleRewayas
                      ? ModernAppColors.accentWithOpacity20
                      : ModernAppColors.primaryWithOpacity20,
                ),
                child: Icon(
                  groupedReciter.hasMultipleRewayas
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.play_arrow_rounded,
                  color: groupedReciter.hasMultipleRewayas
                      ? ModernAppColors.accent
                      : ModernAppColors.primaryDeep,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingSearch() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 60,
      left: 24,
      right: 24,
      child: FloatingGlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              color: ModernAppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  context
                      .read<ReciterBloc>()
                      .add(FilterGroupedReciters(query: query));
                },
                decoration: const InputDecoration(
                  hintText: 'البحث السريع...',
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: const TextStyle(
                  fontSize: 14,
                  color: ModernAppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleReciterTap(GroupedReciter groupedReciter) {
    if (groupedReciter.hasMultipleRewayas) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ModernRewayaSelectionScreen(groupedReciter: groupedReciter),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } else {
      final reciter = groupedReciter.rewayas.first;
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
            create: (context) => di.sl<ReciterBloc>()
              ..add(GetReciterDetail(reciterId: reciter.id)),
            child: ReciterDetailScreen(reciter: reciter),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ModernAppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
