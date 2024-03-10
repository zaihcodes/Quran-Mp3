import 'package:quran_mp3/src/quran_audio/domain/entities/reciter.dart';

abstract class ReciterRepository {
  Future<List<Reciter>> getAllRecitersInfo();
  Future<Reciter> getReciterDetail({required int reciterId});
}
