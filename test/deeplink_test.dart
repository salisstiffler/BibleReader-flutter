import 'package:flutter_test/flutter_test.dart';
import 'package:bible_reader/services/deeplink_service.dart';

void main() {
  group('DeepLinkService', () {
    test('generateDeepLink creates correct URI', () {
      final uri = DeepLinkService.generateDeepLink(
        bookIndex: 0,
        chapterIndex: 4,
        verseNum: 1,
      );

      expect(uri.scheme, 'bible-reader');
      expect(uri.host, 'open');
      expect(uri.queryParameters['bookIndex'], '0');
      expect(uri.queryParameters['chapterIndex'], '4');
      expect(uri.queryParameters['verseNum'], '1');
    });

    test('generateDeepLink without verseNum', () {
      final uri = DeepLinkService.generateDeepLink(
        bookIndex: 0,
        chapterIndex: 4,
      );

      expect(uri.scheme, 'bible-reader');
      expect(uri.host, 'open');
      expect(uri.queryParameters['bookIndex'], '0');
      expect(uri.queryParameters['chapterIndex'], '4');
      expect(uri.queryParameters.containsKey('verseNum'), false);
    });

    test('generateIntentUri creates correct Android intent', () {
      final intentUri = DeepLinkService.generateIntentUri(
        bookIndex: 0,
        chapterIndex: 4,
        verseNum: 1,
      );

      expect(intentUri, contains('intent://open'));
      expect(intentUri, contains('bookIndex=0'));
      expect(intentUri, contains('chapterIndex=4'));
      expect(intentUri, contains('verseNum=1'));
      expect(intentUri, contains('scheme=bible-reader'));
      expect(intentUri, contains('package=com.berlin.bible_reader'));
    });

    test('DeepLinkData.fromUri parses correctly', () {
      final uri = Uri.parse('bible-reader://open?bookIndex=0&chapterIndex=4&verseNum=1');
      final data = DeepLinkData.fromUri(uri);

      expect(data.bookIndex, 0);
      expect(data.chapterIndex, 4);
      expect(data.verseNum, 1);
    });

    test('DeepLinkData.fromUri without verseNum', () {
      final uri = Uri.parse('bible-reader://open?bookIndex=2&chapterIndex=10');
      final data = DeepLinkData.fromUri(uri);

      expect(data.bookIndex, 2);
      expect(data.chapterIndex, 10);
      expect(data.verseNum, null);
    });
  });
}
