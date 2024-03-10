import 'package:quran_mp3/src/quran_audio/data/models/surah_audio_model.dart';
import 'package:quran_mp3/src/quran_audio/domain/entities/reciter.dart';

class ReciterDetailModel extends Reciter {
  // @override
  @override
  final List<SurahAudioModel> audio;
  ReciterDetailModel({
    required id,
    required name,
    required server,
    required rewaya,
    required letter,
    required count,
    required suras,
    required this.audio,
  }) : super(
          id: id,
          name: name,
          server: server,
          rewaya: rewaya,
          letter: letter,
          count: count,
          suras: suras,
          // audio: audio,
        );
  factory ReciterDetailModel.fromJson(Map<String, dynamic> json) {
    return ReciterDetailModel(
      id: json['id'],
      name: json['name'],
      server: json['server'],
      rewaya: json['rewaya'],
      letter: json['letter'],
      count: json['count'],
      suras: json['suras'],
      audio: (json['audio'] as List)
          .map((json) => SurahAudioModel.fromJson(json))
          .toList(),
    );
  }
}

class ReciterInfoModel extends Reciter {
  // @override
  @override
  // final List<SurahAudioModel> audio;
  ReciterInfoModel({
    required id,
    required name,
    required server,
    required rewaya,
    required letter,
    required count,
    required suras,
    // required this.audio,
  }) : super(
          id: id,
          name: name,
          server: server,
          rewaya: rewaya,
          letter: letter,
          count: count,
          suras: suras,
          // audio: audio,
        );
  factory ReciterInfoModel.fromJson(Map<String, dynamic> json) {
    return ReciterInfoModel(
      id: json['id'],
      name: json['name'],
      server: json['server'],
      rewaya: json['rewaya'],
      letter: json['letter'],
      count: json['count'],
      suras: json['suras'],
      // audio: (json['audio'] as List)
      //     .map((json) => SurahAudioModel.fromJson(json))
      //     .toList(),
    );
  }
}
