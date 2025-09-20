import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quran_mp3/core/services/theme/app_colors_modern.dart';
import 'package:quran_mp3/core/widgets/glass_card.dart';
import 'package:quran_mp3/core/widgets/animated_widgets.dart';

class ModernAudioPlayer extends StatefulWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final Duration currentPosition;
  final Duration totalDuration;
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback? onPlayPause;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final Function(Duration)? onSeek;
  final bool showVisualizer;

  const ModernAudioPlayer({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    required this.currentPosition,
    required this.totalDuration,
    required this.isPlaying,
    this.isLoading = false,
    this.onPlayPause,
    this.onNext,
    this.onPrevious,
    this.onSeek,
    this.showVisualizer = true,
  });

  @override
  State<ModernAudioPlayer> createState() => _ModernAudioPlayerState();
}

class _ModernAudioPlayerState extends State<ModernAudioPlayer>
    with TickerProviderStateMixin {
  late AnimationController _visualizerController;
  late AnimationController _playButtonController;
  late AnimationController _pulseController;
  late Animation<double> _playButtonAnimation;
  late Animation<double> _pulseAnimation;

  bool _isDragging = false;
  double _dragValue = 0.0;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _visualizerController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _playButtonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _playButtonController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isPlaying) {
      _visualizerController.repeat();
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ModernAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _visualizerController.repeat();
        _pulseController.repeat(reverse: true);
        _playButtonController.forward();
      } else {
        _visualizerController.stop();
        _pulseController.stop();
        _playButtonController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _visualizerController.dispose();
    _playButtonController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      child: FloatingGlassCard(
        borderRadius: 32,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAlbumArt(),
            const SizedBox(height: 24),
            _buildTrackInfo(),
            const SizedBox(height: 20),
            if (widget.showVisualizer) _buildVisualizer(),
            if (widget.showVisualizer) const SizedBox(height: 20),
            _buildProgressBar(),
            const SizedBox(height: 24),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumArt() {
    return Center(
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isPlaying ? _pulseAnimation.value : 1.0,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: ModernAppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: ModernAppColors.primaryDeep.withValues(alpha: 0.4),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: ModernAppColors.accent.withValues(alpha: 0.2),
                    blurRadius: 50,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: widget.imageUrl != null
                  ? ClipOval(
                      child: Image.network(
                        widget.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDefaultArtwork(),
                      ),
                    )
                  : _buildDefaultArtwork(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDefaultArtwork() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: ModernAppColors.primaryGradient,
      ),
      child: const Icon(
        Icons.audiotrack_rounded,
        size: 80,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTrackInfo() {
    return Column(
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: ModernAppColors.textPrimary,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          widget.subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ModernAppColors.textSecondary,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildVisualizer() {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(30, (index) {
          return AnimatedBuilder(
            animation: _visualizerController,
            builder: (context, child) {
              final height = widget.isPlaying
                  ? 4 +
                      (sin(((_visualizerController.value * 2 * pi) + (index * 0.3)) % (2 * pi)) *
                          20) +
                      (Random(index).nextDouble() * 15)
                  : 4.0;

              return Container(
                width: 3,
                height: height,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      ModernAppColors.accent,
                      ModernAppColors.accentLight,
                      Colors.white,
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = widget.totalDuration.inMilliseconds > 0
        ? (_isDragging ? _dragValue : widget.currentPosition.inMilliseconds) /
            widget.totalDuration.inMilliseconds
        : 0.0;

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            thumbShape: _CustomThumbShape(),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            activeTrackColor: ModernAppColors.accent,
            inactiveTrackColor: ModernAppColors.backgroundTertiary,
            thumbColor: ModernAppColors.accent,
            overlayColor: ModernAppColors.accentWithOpacity20,
          ),
          child: Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: (value) {
              setState(() {
                _isDragging = true;
                _dragValue = value * widget.totalDuration.inMilliseconds;
              });
            },
            onChangeEnd: (value) {
              setState(() => _isDragging = false);
              final newPosition = Duration(
                milliseconds: (value * widget.totalDuration.inMilliseconds).round(),
              );
              widget.onSeek?.call(newPosition);
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDuration(_isDragging
                  ? Duration(milliseconds: _dragValue.round())
                  : widget.currentPosition),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ModernAppColors.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _formatDuration(widget.totalDuration),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ModernAppColors.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Previous button
        _buildControlButton(
          icon: Icons.skip_previous_rounded,
          onPressed: widget.onPrevious,
          size: 40,
        ),

        // Play/Pause button
        GlowingButton(
          glowColor: ModernAppColors.accent,
          glowRadius: 25,
          onPressed: widget.onPlayPause,
          child: AnimatedBuilder(
            animation: _playButtonAnimation,
            builder: (context, child) {
              return Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: ModernAppColors.accentGradient,
                  boxShadow: [
                    BoxShadow(
                      color: ModernAppColors.accent.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: widget.isLoading
                    ? const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : Icon(
                        widget.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
              );
            },
          ),
        ),

        // Next button
        _buildControlButton(
          icon: Icons.skip_next_rounded,
          onPressed: widget.onNext,
          size: 40,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    VoidCallback? onPressed,
    double size = 40,
  }) {
    return GlassCard(
      borderRadius: size / 2,
      padding: EdgeInsets.all(size * 0.3),
      onTap: onPressed,
      child: Icon(
        icon,
        color: ModernAppColors.textPrimary,
        size: size * 0.6,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class _CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(20, 20);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Outer circle (glow)
    final Paint glowPaint = Paint()
      ..color = ModernAppColors.accent.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 12, glowPaint);

    // Inner circle (thumb)
    final Paint thumbPaint = Paint()
      ..shader = ModernAppColors.accentGradient.createShader(
        Rect.fromCircle(center: center, radius: 8),
      )
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 8, thumbPaint);

    // Border
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, 8, borderPaint);
  }
}