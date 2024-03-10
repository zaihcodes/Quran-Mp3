import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quran_mp3/src/quran_audio/domain/entities/reciter.dart';
import 'package:quran_mp3/src/quran_audio/domain/usecases/reciter_detail_usecase.dart';
import 'package:quran_mp3/src/quran_audio/domain/usecases/reciters_info_usecase.dart';

part 'reciter_event.dart';
part 'reciter_state.dart';

class ReciterBloc extends Bloc<ReciterEvent, ReciterState> {
  final RecitersInfoUsecase recitersInfoUsecase;
  final ReciterDetailUsecase reciterDetailUsecase;

  ReciterBloc(
      {required this.reciterDetailUsecase, required this.recitersInfoUsecase})
      : super(const ReciterState(status: ReciterStateStatus.initial)) {
    on<GetAllRecitersInfo>(_getAllRecitersInfo);
    on<FilterRecitersInfo>(_filterRecitersInfo);
    on<GetReciterDetail>(_getReciterDetail);
  }

  void _getAllRecitersInfo(
      GetAllRecitersInfo event, Emitter<ReciterState> emit) async {
    emit(state.copyWith(status: ReciterStateStatus.loading));
    final recitersInfo = await recitersInfoUsecase();
    emit(state.copyWith(
        status: ReciterStateStatus.loaded,
        reciters: recitersInfo,
        filtredReciters: recitersInfo));
  }

  void _filterRecitersInfo(
      FilterRecitersInfo event, Emitter<ReciterState> emit) async {
    // emit(state.copyWith(status: ReciterStateStatus.loading));
    // final recitersInfo = await recitersInfoUsecase();
    emit(state.copyWith(
        status: ReciterStateStatus.loaded,
        filtredReciters: state.reciters
            .where((r) => r.name.contains(event.query))
            .toList()));
  }

  void _getReciterDetail(
      GetReciterDetail event, Emitter<ReciterState> emit) async {
    emit(state.copyWith(status: ReciterStateStatus.loadingReciter));
    final reciterDetail =
        await reciterDetailUsecase(reciterId: event.reciterId);
    emit(state.copyWith(
        status: ReciterStateStatus.loadedReciter,
        selectedReciter: reciterDetail));
  }
}
