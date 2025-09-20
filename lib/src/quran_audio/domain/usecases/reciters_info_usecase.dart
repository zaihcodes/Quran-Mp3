import 'package:quran_mp3/src/quran_audio/domain/entities/reciter.dart';
import 'package:quran_mp3/src/quran_audio/domain/repositories/reciter_repository.dart';
import 'package:quran_mp3/core/error/exceptions.dart';

class RecitersInfoUsecase {
  final ReciterRepository reciterRepository;
  const RecitersInfoUsecase({required this.reciterRepository});

  Future<List<Reciter>> call() async {
    try {
      final reciters = await reciterRepository.getAllRecitersInfo();

      if (reciters.isEmpty) {
        throw const DataNotFoundException(
          'No reciters found',
          'reciters',
          code: 'NO_RECITERS_FOUND',
        );
      }

      return reciters;
    } on AppException {
      rethrow; // Re-throw our custom exceptions
    } catch (e) {
      throw UseCaseException(
        'Failed to get reciters information: ${e.toString()}',
        'RecitersInfoUsecase',
        code: 'USECASE_ERROR',
        originalError: e,
      );
    }
  }
}
