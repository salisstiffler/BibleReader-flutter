# 深度链接 (DeepLink) 配置说明

## 概述
此应用已配置支持深度链接，允许用户通过特定的URL链接直接打开应用中的特定书籍、章节和节经文。

## 配置详情

### iOS 配置（Info.plist）
已添加URL Scheme `bible-reader`，允许用户通过以下格式打开应用：
```
bible-reader://open?bookIndex=0&chapterIndex=4&verseNum=1
```

### Android 配置（AndroidManifest.xml）
已添加Intent Filter支持深度链接：
```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data
        android:scheme="bible-reader"
        android:host="open"/>
</intent-filter>
```

## 使用方法

### 1. 在网页中创建深度链接

#### iOS 用户
```html
<a href="bible-reader://open?bookIndex=0&chapterIndex=4&verseNum=1">
  打开圣经（iOS）
</a>
```

#### Android 用户（推荐使用Intent URI）
```html
<a href="intent://open?bookIndex=0&chapterIndex=4&verseNum=1#Intent;scheme=bible-reader;package=com.berlin.bible_reader;end">
  打开圣经（Android）
</a>
```

#### 兼容两个平台
```html
<a href="javascript:openBibleApp(0, 4, 1)">
  打开圣经
</a>

<script>
function openBibleApp(bookIndex, chapterIndex, verseNum) {
  // Android Intent URI
  const intentUri = `intent://open?bookIndex=${bookIndex}&chapterIndex=${chapterIndex}${verseNum ? `&verseNum=${verseNum}` : ''}#Intent;scheme=bible-reader;package=com.berlin.bible_reader;end`;
  // iOS URL Scheme
  const iosUri = `bible-reader://open?bookIndex=${bookIndex}&chapterIndex=${chapterIndex}${verseNum ? `&verseNum=${verseNum}` : ''}`;
  
  // 尝试Android Intent
  try {
    window.location.href = intentUri;
    setTimeout(() => {
      // 如果Intent失败，尝试iOS
      window.location.href = iosUri;
    }, 500);
  } catch (e) {
    window.location.href = iosUri;
  }
}
</script>
```

### 2. 在 Dart 应用中生成深度链接

```dart
import 'package:bible_reader/services/deeplink_service.dart';

// 生成 URI 对象
final uri = DeepLinkService.generateDeepLink(
  bookIndex: 0,      // 创世记
  chapterIndex: 4,   // 第5章
  verseNum: 1,       // 第1节
);
print(uri.toString()); // bible-reader://open?bookIndex=0&chapterIndex=4&verseNum=1

// 生成 Android Intent URI（用于分享）
final intentUri = DeepLinkService.generateIntentUri(
  bookIndex: 0,
  chapterIndex: 4,
  verseNum: 1,
);
print(intentUri); // intent://open?bookIndex=0&chapterIndex=4&verseNum=1#Intent;...
```

## 参数说明

| 参数 | 类型 | 必需 | 说明 |
|------|------|------|------|
| bookIndex | int | 是 | 书的索引（0-65，对应旧约和新约的66卷书） |
| chapterIndex | int | 是 | 章的索引（0-based，例如 0 表示第1章） |
| verseNum | int | 否 | 节的序号（1-based，例如 1 表示第1节，可选） |

## 书籍索引参考

### 旧约（0-38）
| 索引 | 书名 | 说明 |
|------|------|------|
| 0 | 创世记 | Genesis |
| 1 | 出埃及记 | Exodus |
| 2 | 利未记 | Leviticus |
| 3 | 民数记 | Numbers |
| 4 | 申命记 | Deuteronomy |
| 5 | 约书亚记 | Joshua |
| 6 | 士师记 | Judges |
| 7 | 路得记 | Ruth |
| 8 | 撒母耳记上 | 1 Samuel |
| 9 | 撒母耳记下 | 2 Samuel |
| 10 | 列王纪上 | 1 Kings |
| 11 | 列王纪下 | 2 Kings |

### 新约（39-65）
| 索引 | 书名 | 说明 |
|------|------|------|
| 39 | 马太福音 | Matthew |
| 40 | 马可福音 | Mark |
| 41 | 路加福音 | Luke |
| 42 | 约翰福音 | John |
| 43 | 使徒行传 | Acts |

## 工作流程

1. **用户点击网页链接** → 包含深度链接 URI
2. **操作系统打开应用** → 将 URI 传递给应用
3. **iOS AppDelegate** → 调用 `application(_:open:options:)` 方法
4. **Android MainActivity** → 接收 Intent 数据
5. **DeepLinkService** → 通过 MethodChannel 接收 URI
6. **应用内导航** → DeepLinkService 监听流，触发导航
7. **ReaderPage** → 显示指定的书籍、章节和节经文

## 测试深度链接

### iOS
在 Xcode 控制台中测试：
```bash
xcrun simctl openurl booted "bible-reader://open?bookIndex=0&chapterIndex=0&verseNum=1"
```

### Android
在 ADB 中测试：
```bash
adb shell am start -W -a android.intent.action.VIEW -d "bible-reader://open?bookIndex=0&chapterIndex=0&verseNum=1" com.berlin.bible_reader
```

## 注意事项

1. **验证参数** - 确保 bookIndex 和 chapterIndex 在有效范围内
2. **处理边界情况** - 某些书籍的章数不同，应用会自动处理无效的章节索引
3. **国际化** - deeplink 参数使用数字，不受语言设置影响
4. **安全性** - 应用已配置 Intent Filter 以防止其他应用篡改

## 相关文件

- `lib/services/deeplink_service.dart` - DeepLink 服务实现
- `lib/main.dart` - 应用入口，处理 deeplink 监听
- `ios/Runner/Info.plist` - iOS URL Scheme 配置
- `ios/Runner/AppDelegate.swift` - iOS URL 处理
- `android/app/src/main/AndroidManifest.xml` - Android Intent Filter 配置
