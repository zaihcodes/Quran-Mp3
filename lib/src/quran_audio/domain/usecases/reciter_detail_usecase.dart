import 'package:quran_mp3/src/quran_audio/domain/entities/reciter.dart';
import 'package:quran_mp3/src/quran_audio/domain/repositories/reciter_repository.dart';
import 'package:quran_mp3/core/error/exceptions.dart';

class ReciterDetailUsecase {
  final ReciterRepository reciterRepository;
  const ReciterDetailUsecase({required this.reciterRepository});

  Future<Reciter> call({required int reciterId}) async {
    try {
      if (reciterId <= 0) {
        throw DataNotFoundException(
          'Invalid reciter ID: $reciterId',
          'reciter',
          identifier: reciterId.toString(),
          code: 'INVALID_RECITER_ID',
        );
      }

      final reciter = await reciterRepository.getReciterDetail(reciterId: reciterId);
      return reciter;
    } on AppException {
      rethrow; // Re-throw our custom exceptions
    } catch (e) {
      throw UseCaseException(
        'Failed to get reciter detail for ID $reciterId: ${e.toString()}',
        'ReciterDetailUsecase',
        code: 'USECASE_ERROR',
        originalError: e,
      );
    }
  }
}
