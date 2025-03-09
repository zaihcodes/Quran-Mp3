import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_mp3/core/services/theme/app_colors.dart';
import 'package:quran_mp3/src/quran_audio/presentation/bloc/reciter/reciter_bloc.dart';
import 'package:quran_mp3/core/services/audio_player_service.dart';
import 'package:quran_mp3/src/quran_audio/presentation/widgets/single_audio_widget.dart';

class ReciterDetailScreen extends StatefulWidget {
  const ReciterDetailScreen({super.key});

  @override
  State<ReciterDetailScreen> createState() => _ReciterDetailScreenState();
}

class _ReciterDetailScreenState extends State<ReciterDetailScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final _scrollController = ScrollController();
  bool _showElevation = false;

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

    _scrollController.addListener(_onScroll);
    _controller.forward();
  }

  void _onScroll() {
    if (_scrollController.offset > 0 && !_showElevation) {
      setState(() => _showElevation = true);
    } else if (_scrollController.offset <= 0 && _showElevation) {
      setState(() => _showElevation = false);
    }
  }

  @override
  void dispose() {
    _audioPlayerService.dispose();
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
          if (state.status == ReciterStateStatus.loadingReciter) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          } else if (state.status == ReciterStateStatus.loadedReciter) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: size.height * 0.25,
                  floating: true,
                  pinned: true,
                  elevation: _showElevation ? 4 : 0,
                  backgroundColor: theme.colorScheme.surface,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: theme.colorScheme.onSurface,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.1),
                            theme.colorScheme.surface,
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 32),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.shadow
                                        .withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                size: 40,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.selectedReciter!.name,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.selectedReciter!.rewaya,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Row(
                      children: [
                        Text(
                          'السور',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${state.selectedReciter!.audio!.length}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final surah = state.selectedReciter!.audio![index];
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: AudioPlayerWidget(surah: surah),
                        );
                      },
                      childCount: state.selectedReciter!.audio!.length,
                    ),
                  ),
                ),
              ],
            );
          }
          return Center(
            child: Text(
              'No Reciter Details Available',
              style: theme.textTheme.titleMedium,
            ),
          );
        },
      ),
    );
  }
}
