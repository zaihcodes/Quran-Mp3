import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_mp3/core/services/theme/app_colors.dart';
import 'package:quran_mp3/src/quran_audio/domain/entities/reciter.dart';
import 'package:quran_mp3/src/quran_audio/presentation/bloc/reciter/reciter_bloc.dart';
import 'package:quran_mp3/src/quran_audio/presentation/screens/reciter_detail_screen.dart';

class RecitersScreen extends StatefulWidget {
  const RecitersScreen({super.key});

  @override
  State<RecitersScreen> createState() => _RecitersScreenState();
}

class _RecitersScreenState extends State<RecitersScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final _scrollController = ScrollController();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: BlocBuilder<ReciterBloc, ReciterState>(
        builder: (context, state) {
          if (state.status == ReciterStateStatus.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          } else if (state.status == ReciterStateStatus.loaded ||
              state.status == ReciterStateStatus.loadedReciter ||
              state.status == ReciterStateStatus.loadingReciter) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: size.height * 0.32,
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
                            theme.colorScheme.primary.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                'إبحت عن',
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'قارئك المفضل',
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  onChanged: (value) {
                                    context.read<ReciterBloc>().add(
                                        FilterRecitersInfo(query: value));
                                  },
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'البحث عن القارئ',
                                    hintStyle: TextStyle(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.5),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search_rounded,
                                      color: theme.colorScheme.primary,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final reciter = state.filtredReciters[index];
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: buildReciterCard(
                              context: context,
                              reciter: reciter,
                              index: index,
                            ),
                          ),
                        );
                      },
                      childCount: state.filtredReciters.length,
                    ),
                  ),
                ),
              ],
            );
          }
          return Center(
            child: Text(
              'No Reciters Found',
              style: theme.textTheme.titleLarge,
            ),
          );
        },
      ),
    );
  }
}

Widget buildReciterCard({
  required BuildContext context,
  required Reciter reciter,
  required int index,
}) {
  final theme = Theme.of(context);
  
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        context.read<ReciterBloc>().add(GetReciterDetail(reciterId: reciter.id));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ReciterDetailScreen(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.08),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_rounded,
                color: theme.colorScheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              reciter.name,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              reciter.rewaya,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );
}
