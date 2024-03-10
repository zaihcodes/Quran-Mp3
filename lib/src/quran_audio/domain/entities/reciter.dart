import 'package:quran_mp3/src/quran_audio/domain/entities/surah_audio.dart';

class Reciter {
  final int id;
  final String name;
  final String server;
  final String rewaya;
  final String letter;
  final String count;
  final String suras;
  final List<SurahAudio>? audio;

  const Reciter({
    required this.id,
    required this.name,
    required this.server,
    required this.rewaya,
    required this.letter,
    required this.count,
    required this.suras,
    this.audio,
  });
}
