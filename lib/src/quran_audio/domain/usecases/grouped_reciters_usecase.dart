import 'package:quran_mp3/core/error/exceptions.dart';
import 'package:quran_mp3/src/quran_audio/data/models/grouped_reciter_model.dart';
import 'package:quran_mp3/src/quran_audio/domain/repositories/reciter_repository.dart';

class GroupedRecitersUsecase {
  final ReciterRepository reciterRepository;

  const GroupedRecitersUsecase({required this.reciterRepository});

  Future<List<GroupedReciterModel>> call() async {
    try {
      final reciters = await reciterRepository.getAllRecitersInfo();

      if (reciters.isEmpty) {
        throw const DataNotFoundException(
          'لا توجد قراء متاحة',
          'reciters',
          code: 'NO_RECITERS_FOUND',
        );
      }

      final groupedReciters = GroupedReciterModel.groupRecitersByName(reciters);

      if (groupedReciters.isEmpty) {
        throw const DataNotFoundException(
          'فشل في تجميع بيانات القراء',
          'grouped_reciters',
          code: 'GROUPING_FAILED',
        );
      }

      return groupedReciters;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UseCaseException(
        'خطأ غير متوقع في جلب القراء المجمعة',
        'grouped_reciters_usecase',
        code: 'GROUPED_RECITERS_UNEXPECTED_ERROR',
        originalError: e,
      );
    }
  }
}