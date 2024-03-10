import 'package:quran_mp3/src/quran_audio/domain/entities/reciter.dart';
import 'package:quran_mp3/src/quran_audio/domain/repositories/reciter_repository.dart';

class RecitersInfoUsecase {
  final ReciterRepository reciterRepository;
  const RecitersInfoUsecase({required this.reciterRepository});

  Future<List<Reciter>> call() async {
    return await reciterRepository.getAllRecitersInfo();
  }
}
