// import 'package:audioplayers/audioplayers.dart';

import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  Future<void> play(String url) async {
    await _audioPlayer.setUrl(url);
    _audioPlayer.play();
    isPlaying = true;
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    isPlaying = false;
  }

  Future<void> resume() async {
    await _audioPlayer.play();
    isPlaying = true;
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    isPlaying = false;
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
