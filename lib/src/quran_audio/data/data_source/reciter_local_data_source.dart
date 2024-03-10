import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quran_mp3/src/quran_audio/data/models/reciter_model.dart';

abstract class ReciterLocalDataSource {
  Future<List<ReciterInfoModel>> getAllRecitersInfo();
  Future<ReciterDetailModel> getReciterDetail({required int reciterId});
}

class ReciterLocalDataSourceImpl implements ReciterLocalDataSource {
  @override
  Future<List<ReciterInfoModel>> getAllRecitersInfo() async {
    final String data =
        await rootBundle.loadString('assets/data/mp3quran.json');
    final jsonList = json.decode(data) as List;

    return jsonList
        .map((json) => ReciterInfoModel.fromJson(json))
        .toList(growable: false);
  }

  @override
  Future<ReciterDetailModel> getReciterDetail({required int reciterId}) async {
    final data = await rootBundle.loadString('assets/data/mp3quran.json');
    final jsonList = await jsonDecode(data);

    final reciter = jsonList.firstWhere((e) => e['id'] == reciterId);
    final reciterModel = ReciterDetailModel.fromJson(reciter);
    return reciterModel;
  }
}
