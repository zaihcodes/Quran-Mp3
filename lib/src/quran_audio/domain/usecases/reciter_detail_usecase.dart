import 'package:quran_mp3/src/quran_audio/domain/entities/reciter.dart';
import 'package:quran_mp3/src/quran_audio/domain/repositories/reciter_repository.dart';

class ReciterDetailUsecase {
  final ReciterRepository reciterRepository;
  const ReciterDetailUsecase({required this.reciterRepository});

  Future<Reciter> call({required int reciterId}) async {
    return await reciterRepository.getReciterDetail(reciterId: reciterId);
  }
}
