import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quran_mp3/src/quran_audio/domain/entities/reciter.dart';
import 'package:quran_mp3/src/quran_audio/domain/usecases/reciter_detail_usecase.dart';
import 'package:quran_mp3/src/quran_audio/domain/usecases/reciters_info_usecase.dart';
import 'package:quran_mp3/core/error/exceptions.dart';

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
    emit(state.copyWith(
      status: ReciterStateStatus.loading,
      clearError: true, // Clear any previous errors
    ));

    try {
      final recitersInfo = await recitersInfoUsecase();
      emit(state.copyWith(
        status: ReciterStateStatus.loaded,
        reciters: recitersInfo,
        filtredReciters: recitersInfo,
        clearError: true, // Clear any previous errors
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        status: ReciterStateStatus.error,
        errorMessage: _getUserFriendlyErrorMessage(e),
        errorCode: e.code,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ReciterStateStatus.error,
        errorMessage: 'حدث خطأ غير متوقع أثناء تحميل القراء',
        errorCode: 'UNEXPECTED_ERROR',
      ));
    }
  }

  void _filterRecitersInfo(
      FilterRecitersInfo event, Emitter<ReciterState> emit) async {
    try {
      // Only filter if we have reciters loaded
      if (state.reciters.isEmpty) {
        emit(state.copyWith(
          status: ReciterStateStatus.error,
          errorMessage: 'لا توجد بيانات للقراء للبحث فيها',
          errorCode: 'NO_DATA_TO_FILTER',
        ));
        return;
      }

      final query = event.query.trim().toLowerCase();

      if (query.isEmpty) {
        // If query is empty, show all reciters
        emit(state.copyWith(
          status: ReciterStateStatus.loaded,
          filtredReciters: state.reciters,
          clearError: true,
        ));
      } else {
        // Filter reciters based on query
        final filteredReciters = state.reciters
            .where((r) => r.name.toLowerCase().contains(query))
            .toList();

        emit(state.copyWith(
          status: ReciterStateStatus.loaded,
          filtredReciters: filteredReciters,
          clearError: true,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ReciterStateStatus.error,
        errorMessage: 'حدث خطأ أثناء البحث في القراء',
        errorCode: 'FILTER_ERROR',
      ));
    }
  }

  void _getReciterDetail(
      GetReciterDetail event, Emitter<ReciterState> emit) async {
    emit(state.copyWith(
      status: ReciterStateStatus.loadingReciter,
      clearError: true, // Clear any previous errors
    ));

    try {
      final reciterDetail = await reciterDetailUsecase(reciterId: event.reciterId);
      emit(state.copyWith(
        status: ReciterStateStatus.loadedReciter,
        selectedReciter: reciterDetail,
        clearError: true, // Clear any previous errors
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        status: ReciterStateStatus.error,
        errorMessage: _getUserFriendlyErrorMessage(e),
        errorCode: e.code,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ReciterStateStatus.error,
        errorMessage: 'حدث خطأ غير متوقع أثناء تحميل تفاصيل القارئ',
        errorCode: 'UNEXPECTED_ERROR',
      ));
    }
  }

  /// Converts technical error messages to user-friendly Arabic messages
  String _getUserFriendlyErrorMessage(AppException exception) {
    switch (exception.runtimeType) {
      case AssetLoadingException:
        return 'فشل في تحميل بيانات القراء. تأكد من اتصالك بالإنترنت وحاول مرة أخرى.';
      case JsonParsingException:
        return 'حدث خطأ في تحليل بيانات القراء. يرجى المحاولة مرة أخرى.';
      case DataNotFoundException:
        final dataException = exception as DataNotFoundException;
        if (dataException.dataType == 'reciter') {
          return 'القارئ المطلوب غير موجود.';
        }
        return 'لم يتم العثور على بيانات القراء.';
      case NetworkException:
        return 'خطأ في الشبكة. تأكد من اتصالك بالإنترنت وحاول مرة أخرى.';
      case RepositoryException:
      case UseCaseException:
        return 'حدث خطأ أثناء تحميل البيانات. يرجى المحاولة مرة أخرى.';
      default:
        return exception.message.isNotEmpty
            ? exception.message
            : 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
    }
  }
}
