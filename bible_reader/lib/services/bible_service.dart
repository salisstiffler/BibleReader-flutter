import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/bible_data.dart';

class BibleService {
  Future<List<BibleBook>> loadBible(String languageCode) async {
    final String response = await rootBundle.loadString('assets/bible-$languageCode.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => BibleBook.fromJson(json)).toList();
  }
}
