import 'dart:async';
import 'package:flutter/services.dart';

typedef DeepLinkCallback = void Function(DeepLinkData deepLinkData);

class DeepLinkData {
  final int? bookIndex;
  final int? chapterIndex;
  final int? verseNum;

  DeepLinkData({
    this.bookIndex,
    this.chapterIndex,
    this.verseNum,
  });

  factory DeepLinkData.fromUri(Uri uri) {
    int? bookIndex, chapterIndex, verseNum;

    if (uri.scheme == 'bible-reader') {
        // Parse query parameters
        bookIndex = uri.queryParameters['bookIndex'] != null
            ? int.parse(uri.queryParameters['bookIndex']!)
            : null;
        chapterIndex = uri.queryParameters['chapterIndex'] != null
            ? int.parse(uri.queryParameters['chapterIndex']!)
            : null;
        verseNum = uri.queryParameters['verseNum'] != null
            ? int.parse(uri.queryParameters['verseNum']!)
            : null;
      }

    return DeepLinkData(
      bookIndex: bookIndex,
      chapterIndex: chapterIndex,
      verseNum: verseNum,
    );
  }

  @override
  String toString() =>
      'DeepLinkData(bookIndex: $bookIndex, chapterIndex: $chapterIndex, verseNum: $verseNum)';
}

class DeepLinkService {
  static const platform = MethodChannel('com.berlin.bible_reader/deeplink');
  static final DeepLinkService _instance = DeepLinkService._internal();

  final StreamController<DeepLinkData> _deepLinkStreamController =
      StreamController<DeepLinkData>.broadcast();

  Stream<DeepLinkData> get deepLinkStream => _deepLinkStreamController.stream;

  DeepLinkService._internal() {
    platform.setMethodCallHandler(_handleMethodCall);
  }

  factory DeepLinkService() {
    return _instance;
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onDeepLink') {
      final String url = call.arguments as String;
      final Uri uri = Uri.parse(url);
      final deepLinkData = DeepLinkData.fromUri(uri);
      _deepLinkStreamController.add(deepLinkData);
    }
  }

  /// Generate a deep link URI for the given parameters
  static Uri generateDeepLink({
    required int bookIndex,
    required int chapterIndex,
    int? verseNum,
  }) {
    return Uri(
      scheme: 'bible-reader',
      host: 'open',
      queryParameters: {
        'bookIndex': bookIndex.toString(),
        'chapterIndex': chapterIndex.toString(),
        if (verseNum != null) 'verseNum': verseNum.toString(),
      },
    );
  }

  /// Generate the intent URI for Android sharing
  static String generateIntentUri({
    required int bookIndex,
    required int chapterIndex,
    int? verseNum,
  }) {
    final uri = generateDeepLink(
      bookIndex: bookIndex,
      chapterIndex: chapterIndex,
      verseNum: verseNum,
    );
    
    final queryString = uri.query;
    return 'intent://open?$queryString#Intent;scheme=bible-reader;package=com.berlin.bible_reader;end';
  }

  void dispose() {
    _deepLinkStreamController.close();
  }
}
