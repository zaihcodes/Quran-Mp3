import 'package:quran_mp3/src/quran_audio/domain/entities/surah_audio.dart';

class SurahAudioModel extends SurahAudio {
  SurahAudioModel(
      {required super.id,
      required super.name,
      required super.englishName,
      required super.translation,
      required super.descent,
      required super.descentEnglish,
      required super.link});

  factory SurahAudioModel.fromJson(Map<String, dynamic> json) {
    return SurahAudioModel(
        id: json['id'],
        name: json['name'],
        englishName: json['english_name'],
        translation: json['translation'],
        descent: json['descent'],
        descentEnglish: json['descent_english'],
        link: json['link']);
  }
}
