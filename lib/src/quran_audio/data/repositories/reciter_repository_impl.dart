import 'package:quran_mp3/src/quran_audio/data/data_source/reciter_local_data_source.dart';
import 'package:quran_mp3/src/quran_audio/domain/entities/reciter.dart';
import 'package:quran_mp3/src/quran_audio/domain/repositories/reciter_repository.dart';
import 'package:quran_mp3/core/error/exceptions.dart';

class ReciterRepositoryImpl implements ReciterRepository {
  final ReciterLocalDataSource reciterLocalDataSource;
  const ReciterRepositoryImpl({required this.reciterLocalDataSource});

  @override
  Future<List<Reciter>> getAllRecitersInfo() async {
    try {
      return await reciterLocalDataSource.getAllRecitersInfo();
    } on AppException {
      rethrow; // Re-throw our custom exceptions
    } catch (e) {
      throw RepositoryException(
        'Failed to get all reciters info: ${e.toString()}',
        'getAllRecitersInfo',
        code: 'REPOSITORY_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<Reciter> getReciterDetail({required int reciterId}) async {
    try {
      return await reciterLocalDataSource.getReciterDetail(reciterId: reciterId);
    } on AppException {
      rethrow; // Re-throw our custom exceptions
    } catch (e) {
      throw RepositoryException(
        'Failed to get reciter detail for ID $reciterId: ${e.toString()}',
        'getReciterDetail',
        code: 'REPOSITORY_ERROR',
        originalError: e,
      );
    }
  }
}
