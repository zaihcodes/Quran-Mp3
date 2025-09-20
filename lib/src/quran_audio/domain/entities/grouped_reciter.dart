import 'package:quran_mp3/src/quran_audio/domain/entities/reciter.dart';

class GroupedReciter {
  final String name;
  final String letter;
  final List<Reciter> rewayas;
  final int totalRewayas;

  const GroupedReciter({
    required this.name,
    required this.letter,
    required this.rewayas,
    required this.totalRewayas,
  });

  String get mainRewaya => rewayas.isNotEmpty ? rewayas.first.rewaya : '';

  bool get hasMultipleRewayas => rewayas.length > 1;

  String get displayText => hasMultipleRewayas
      ? '$name ($totalRewayas روايات)'
      : '$name - $mainRewaya';
}