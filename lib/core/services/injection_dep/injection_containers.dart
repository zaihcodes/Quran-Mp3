import 'package:get_it/get_it.dart';
import 'package:quran_mp3/src/quran_audio/data/data_source/reciter_local_data_source.dart';
import 'package:quran_mp3/src/quran_audio/data/repositories/reciter_repository_impl.dart';
import 'package:quran_mp3/src/quran_audio/domain/repositories/reciter_repository.dart';
import 'package:quran_mp3/src/quran_audio/domain/usecases/reciter_detail_usecase.dart';
import 'package:quran_mp3/src/quran_audio/domain/usecases/reciters_info_usecase.dart';
import 'package:quran_mp3/src/quran_audio/presentation/bloc/player/player_bloc.dart';
import 'package:quran_mp3/src/quran_audio/presentation/bloc/reciter/reciter_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
      () => ReciterBloc(reciterDetailUsecase: sl(), recitersInfoUsecase: sl()));
  // Usecases
  sl.registerLazySingleton(() => ReciterDetailUsecase(reciterRepository: sl()));
  sl.registerLazySingleton(() => RecitersInfoUsecase(reciterRepository: sl()));

  // Repository
  sl.registerLazySingleton<ReciterRepository>(
      () => ReciterRepositoryImpl(reciterLocalDataSource: sl()));

  // Data Source
  sl.registerLazySingleton<ReciterLocalDataSource>(
      () => ReciterLocalDataSourceImpl());

  // Audio
  sl.registerFactory(() => AudioBloc(audioList: sl()));
}
