import 'package:quran_mp3/src/quran_audio/data/data_source/reciter_local_data_source.dart';
import 'package:quran_mp3/src/quran_audio/domain/entities/reciter.dart';
import 'package:quran_mp3/src/quran_audio/domain/repositories/reciter_repository.dart';

class ReciterRepositoryImpl implements ReciterRepository {
  final ReciterLocalDataSource reciterLocalDataSource;
  const ReciterRepositoryImpl({required this.reciterLocalDataSource});

  @override
  Future<List<Reciter>> getAllRecitersInfo() async {
    return await reciterLocalDataSource.getAllRecitersInfo();
  }

  @override
  Future<Reciter> getReciterDetail({required int reciterId}) async {
    return await reciterLocalDataSource.getReciterDetail(reciterId: reciterId);
  }
}
