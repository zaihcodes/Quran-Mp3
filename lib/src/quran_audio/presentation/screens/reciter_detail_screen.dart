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

class _ReciterDetailScreenState extends State<ReciterDetailScreen> {
  final AudioPlayerService _audioPlayerService = AudioPlayerService();

  @override
  void dispose() {
    _audioPlayerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: BlocBuilder<ReciterBloc, ReciterState>(
        builder: (context, state) {
          if (state.status == ReciterStateStatus.loadingReciter) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            );
          } else if (state.status == ReciterStateStatus.loadedReciter) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                  margin: const EdgeInsets.only(bottom: 15),
                  color: theme.colorScheme.secondary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                      Text(
                        state.selectedReciter!.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: theme.colorScheme.onSecondary, fontSize: 20),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.selectedReciter!.audio!.length,
                    itemBuilder: (context, index) {
                      final surah = state.selectedReciter!.audio![index];
                      return AudioPlayerWidget(surah: surah);
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: Text('Reciter Details'),
          );
        },
      ),
    );
  }
}
