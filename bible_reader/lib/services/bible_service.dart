import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/bible_data.dart';

class BibleService {
  Future<List<BibleBook>> loadBible(String languageCode) async {
    String assetFileName;
    if (languageCode == 'zh-Hans') {
      assetFileName = 'bible-zh.json';
    } else if (languageCode == 'zh-Hant') {
      assetFileName = 'bible-zh-hant.json';
    } else { // 'en'
      assetFileName = 'bible-en.json';
    }
    final String response = await rootBundle.loadString('assets/$assetFileName');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => BibleBook.fromJson(json)).toList();
  }
}
