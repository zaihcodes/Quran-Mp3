part of 'reciter_bloc.dart';

abstract class ReciterEvent {
  const ReciterEvent();
}

class GetAllRecitersInfo extends ReciterEvent {}

class GetGroupedReciters extends ReciterEvent {}

class GetReciterDetail extends ReciterEvent {
  final int reciterId;
  const GetReciterDetail({required this.reciterId});
}

class FilterRecitersInfo extends ReciterEvent {
  final String query;
  const FilterRecitersInfo({required this.query});
}

class FilterGroupedReciters extends ReciterEvent {
  final String query;
  const FilterGroupedReciters({required this.query});
}
