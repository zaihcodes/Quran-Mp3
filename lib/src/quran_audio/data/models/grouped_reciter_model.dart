import 'package:quran_mp3/src/quran_audio/domain/entities/grouped_reciter.dart';
import 'package:quran_mp3/src/quran_audio/domain/entities/reciter.dart';

class GroupedReciterModel extends GroupedReciter {
  const GroupedReciterModel({
    required super.name,
    required super.letter,
    required super.rewayas,
    required super.totalRewayas,
  });

  factory GroupedReciterModel.fromReciters(List<Reciter> reciters) {
    if (reciters.isEmpty) {
      throw ArgumentError('Cannot create GroupedReciterModel from empty list');
    }

    final firstReciter = reciters.first;
    return GroupedReciterModel(
      name: firstReciter.name,
      letter: firstReciter.letter,
      rewayas: reciters,
      totalRewayas: reciters.length,
    );
  }

  static List<GroupedReciterModel> groupRecitersByName(List<Reciter> reciters) {
    final Map<String, List<Reciter>> groupedMap = {};

    for (final reciter in reciters) {
      final name = reciter.name;
      if (groupedMap.containsKey(name)) {
        groupedMap[name]!.add(reciter);
      } else {
        groupedMap[name] = [reciter];
      }
    }

    return groupedMap.entries
        .map((entry) => GroupedReciterModel.fromReciters(entry.value))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }
}