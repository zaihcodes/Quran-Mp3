import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_mp3/core/services/injection_dep/injection_containers.dart' as di;
import 'package:quran_mp3/src/quran_audio/domain/entities/grouped_reciter.dart';
import 'package:quran_mp3/src/quran_audio/presentation/bloc/reciter/reciter_bloc.dart';
import 'package:quran_mp3/src/quran_audio/presentation/screens/rewaya_selection_screen.dart';
import 'package:quran_mp3/src/quran_audio/presentation/screens/reciter_detail_screen.dart';
import 'package:quran_mp3/src/quran_audio/presentation/widgets/error_widget.dart';

class GroupedRecitersScreen extends StatefulWidget {
  const GroupedRecitersScreen({super.key});

  @override
  State<GroupedRecitersScreen> createState() => _GroupedRecitersScreenState();
}

class _GroupedRecitersScreenState extends State<GroupedRecitersScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: BlocListener<ReciterBloc, ReciterState>(
          listener: (context, state) {
            if (state.status == ReciterStateStatus.error &&
                state.errorCode == 'FILTER_GROUPED_ERROR') {
              ErrorSnackBar.show(context, state.errorMessage ?? 'حدث خطأ أثناء البحث');
            }
          },
          child: BlocBuilder<ReciterBloc, ReciterState>(
            builder: (context, state) {
              if (state.status == ReciterStateStatus.loadingGrouped) {
                return Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                );
              } else if (state.status == ReciterStateStatus.error) {
                return DataErrorWidget(
                  errorMessage: state.errorMessage,
                  onRetry: () {
                    context.read<ReciterBloc>().add(GetGroupedReciters());
                  },
                );
              } else if (state.status == ReciterStateStatus.loadedGrouped) {
                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    _buildSliverAppBar(context, size, theme),
                    _buildSearchBar(context, theme),
                    _buildGroupedRecitersList(context, state.filteredGroupedReciters, theme),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Size size, ThemeData theme) {
    return SliverAppBar(
      expandedHeight: size.height * 0.25,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: theme.colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.onPrimary.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'القراء',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'اختر القارئ المفضل لديك',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, ThemeData theme) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (query) {
            context.read<ReciterBloc>().add(FilterGroupedReciters(query: query));
          },
          decoration: InputDecoration(
            hintText: 'البحث عن القراء...',
            prefixIcon: Icon(
              Icons.search,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    onPressed: () {
                      _searchController.clear();
                      context.read<ReciterBloc>().add(const FilterGroupedReciters(query: ''));
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupedRecitersList(BuildContext context, List<GroupedReciter> groupedReciters, ThemeData theme) {
    if (groupedReciters.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.search_off,
                size: 80,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'لم يتم العثور على قراء',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'حاول البحث بطريقة مختلفة',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final groupedReciter = groupedReciters[index];
          return _buildGroupedReciterCard(context, groupedReciter, index, theme);
        },
        childCount: groupedReciters.length,
      ),
    );
  }

  Widget _buildGroupedReciterCard(BuildContext context, GroupedReciter groupedReciter, int index, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 0,
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _handleReciterTap(context, groupedReciter),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.surface,
                  theme.colorScheme.surface.withValues(alpha: 0.5),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withValues(alpha: 0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      groupedReciter.letter,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groupedReciter.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            groupedReciter.hasMultipleRewayas ? Icons.library_books : Icons.audiotrack,
                            size: 16,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            groupedReciter.hasMultipleRewayas
                                ? '${groupedReciter.totalRewayas} روايات'
                                : groupedReciter.mainRewaya,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  groupedReciter.hasMultipleRewayas ? Icons.arrow_forward_ios : Icons.play_arrow,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleReciterTap(BuildContext context, GroupedReciter groupedReciter) {
    if (groupedReciter.hasMultipleRewayas) {
      // Navigate to rewaya selection screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RewayaSelectionScreen(groupedReciter: groupedReciter),
        ),
      );
    } else {
      // Navigate directly to reciter detail with single rewaya
      final reciter = groupedReciter.rewayas.first;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => di.sl<ReciterBloc>()
              ..add(GetReciterDetail(reciterId: reciter.id)),
            child: ReciterDetailScreen(reciter: reciter),
          ),
        ),
      );
    }
  }
}