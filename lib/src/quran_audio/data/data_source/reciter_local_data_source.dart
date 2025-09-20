import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quran_mp3/src/quran_audio/data/models/reciter_model.dart';
import 'package:quran_mp3/core/error/exceptions.dart';

abstract class ReciterLocalDataSource {
  Future<List<ReciterInfoModel>> getAllRecitersInfo();
  Future<ReciterDetailModel> getReciterDetail({required int reciterId});
}

class ReciterLocalDataSourceImpl implements ReciterLocalDataSource {
  @override
  Future<List<ReciterInfoModel>> getAllRecitersInfo() async {
    try {
      const assetPath = 'assets/data/mp3quran.json';
      final String data = await rootBundle.loadString(assetPath);

      if (data.isEmpty) {
        throw const AssetLoadingException(
          'JSON file is empty',
          'assets/data/mp3quran.json',
          code: 'EMPTY_ASSET',
        );
      }

      final jsonList = json.decode(data);

      if (jsonList is! List) {
        throw const JsonParsingException(
          'Expected JSON array but got different type',
          code: 'INVALID_JSON_TYPE',
        );
      }

      if (jsonList.isEmpty) {
        throw const DataNotFoundException(
          'No reciters data found in JSON file',
          'reciters',
          code: 'NO_RECITERS_DATA',
        );
      }

      return jsonList
          .map((json) {
            try {
              return ReciterInfoModel.fromJson(json);
            } catch (e) {
              throw JsonParsingException(
                'Failed to parse reciter data: ${e.toString()}',
                code: 'RECITER_PARSE_ERROR',
                originalError: e,
              );
            }
          })
          .toList(growable: false);
    } on AssetLoadingException {
      rethrow; // Re-throw our custom exceptions
    } on JsonParsingException {
      rethrow; // Re-throw our custom exceptions
    } on DataNotFoundException {
      rethrow; // Re-throw our custom exceptions
    } on FormatException catch (e) {
      throw JsonParsingException(
        'Invalid JSON format in reciters data: ${e.message}',
        code: 'JSON_FORMAT_ERROR',
        originalError: e,
      );
    } catch (e) {
      throw DataNotFoundException(
        'Unexpected error while loading reciters data: ${e.toString()}',
        'reciters',
        code: 'UNEXPECTED_ERROR',
        originalError: e,
      );
    }
  }

  @override
  Future<ReciterDetailModel> getReciterDetail({required int reciterId}) async {
    try {
      const assetPath = 'assets/data/mp3quran.json';
      final String data = await rootBundle.loadString(assetPath);

      if (data.isEmpty) {
        throw const AssetLoadingException(
          'JSON file is empty',
          'assets/data/mp3quran.json',
          code: 'EMPTY_ASSET',
        );
      }

      final jsonList = json.decode(data);

      if (jsonList is! List) {
        throw const JsonParsingException(
          'Expected JSON array but got different type',
          code: 'INVALID_JSON_TYPE',
        );
      }

      // Find the reciter with the given ID
      final reciterJson = jsonList.firstWhere(
        (e) => e is Map<String, dynamic> && e['id'] == reciterId,
        orElse: () => null,
      );

      if (reciterJson == null) {
        throw DataNotFoundException(
          'Reciter with ID $reciterId not found',
          'reciter',
          identifier: reciterId.toString(),
          code: 'RECITER_NOT_FOUND',
        );
      }

      try {
        final reciterModel = ReciterDetailModel.fromJson(reciterJson);
        return reciterModel;
      } catch (e) {
        throw JsonParsingException(
          'Failed to parse reciter detail data for ID $reciterId: ${e.toString()}',
          code: 'RECITER_DETAIL_PARSE_ERROR',
          originalError: e,
        );
      }
    } on AssetLoadingException {
      rethrow; // Re-throw our custom exceptions
    } on JsonParsingException {
      rethrow; // Re-throw our custom exceptions
    } on DataNotFoundException {
      rethrow; // Re-throw our custom exceptions
    } on FormatException catch (e) {
      throw JsonParsingException(
        'Invalid JSON format in reciter detail data: ${e.message}',
        code: 'JSON_FORMAT_ERROR',
        originalError: e,
      );
    } catch (e) {
      if (e is AppException) {
        rethrow; // Re-throw our custom exceptions
      }
      throw DataNotFoundException(
        'Unexpected error while loading reciter detail data: ${e.toString()}',
        'reciter',
        identifier: reciterId.toString(),
        code: 'UNEXPECTED_ERROR',
        originalError: e,
      );
    }
  }
}
