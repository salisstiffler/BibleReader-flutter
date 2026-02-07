// Deeplink 使用示例

// 1. 直接使用 Dart 生成深度链接 URI
import 'package:bible_reader/services/deeplink_service.dart';

// 生成深度链接
final uri = DeepLinkService.generateDeepLink(
  bookIndex: 0,      // 创世记
  chapterIndex: 4,   // 第5章
  verseNum: 1,       // 第1节
);
// 结果: bible-reader://open?bookIndex=0&chapterIndex=4&verseNum=1

// 2. 生成用于 Android 的 Intent URI（用于分享）
final intentUri = DeepLinkService.generateIntentUri(
  bookIndex: 0,
  chapterIndex: 4,
  verseNum: 1,
);
// 结果: intent://open?bookIndex=0&chapterIndex=4&verseNum=1#Intent;scheme=bible-reader;package=com.berlin.bible_reader;end

// 3. 在网页中使用深度链接
// 创建一个链接供用户点击：
// <a href="intent://open?bookIndex=0&chapterIndex=4&verseNum=1#Intent;scheme=bible-reader;package=com.berlin.bible_reader;end">
//   打开圣经应用
// </a>

// 4. 应用内监听深度链接
// DeepLinkService 会自动监听来自 iOS AppDelegate 和 Android Intent 的深度链接
// 当收到深度链接时，会自动触发 deepLinkStream，应用会导航到相应的位置

// 5. 参数说明
// - bookIndex: 书的索引（0-65）
// - chapterIndex: 章的索引（0-based）
// - verseNum: 节的序号（1-based，可选）

// 6. 支持的书籍索引（常见）：
// 0:  创世记 (Genesis)
// 1:  出埃及记 (Exodus)
// 2:  利未记 (Leviticus)
// 3:  民数记 (Numbers)
// 4:  申命记 (Deuteronomy)
// 5:  约书亚记 (Joshua)
// 6:  士师记 (Judges)
// 7:  路得记 (Ruth)
// 8:  撒母耳记上 (1 Samuel)
// 9:  撒母耳记下 (2 Samuel)
// 10: 列王纪上 (1 Kings)
// 11: 列王纪下 (2 Kings)
// ... 以此类推
