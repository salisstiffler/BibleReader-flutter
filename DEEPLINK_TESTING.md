# 深度链接测试指南

## 快速测试方法

### iOS 测试

#### 使用 Xcode 的 Scheme 测试
1. 打开 `ios/Runner.xcworkspace`
2. 选择 Runner 项目 → Targets → Runner → Edit Scheme
3. 在 "Run" 选项卡中，找到 "Pre-actions" 或 "Arguments"
4. 或者直接在 Xcode 控制台运行：
```bash
xcrun simctl openurl booted "bible-reader://open?bookIndex=0&chapterIndex=0&verseNum=1"
```

#### 使用 Safari 测试（模拟器）
1. 在 Safari 地址栏输入：
```
bible-reader://open?bookIndex=0&chapterIndex=4&verseNum=1
```
2. 点击回车，应该会打开应用并跳转到创世记 第5章 第1节

### Android 测试

#### 使用 ADB 命令
```bash
adb shell am start -W -a android.intent.action.VIEW \
  -d "bible-reader://open?bookIndex=0&chapterIndex=4&verseNum=1" \
  com.berlin.bible_reader
```

#### 使用 Intent URI
```bash
adb shell am start -W -a android.intent.action.VIEW \
  -d "intent://open?bookIndex=0&chapterIndex=4&verseNum=1#Intent;scheme=bible-reader;package=com.berlin.bible_reader;end" \
  com.berlin.bible_reader
```

## 参数示例

### 示例 1：打开创世记第5章第1节
```
bible-reader://open?bookIndex=0&chapterIndex=4&verseNum=1
```

### 示例 2：打开马太福音第1章（不指定节）
```
bible-reader://open?bookIndex=39&chapterIndex=0
```

### 示例 3：打开约翰福音第3章第16节
```
bible-reader://open?bookIndex=42&chapterIndex=2&verseNum=16
```

## 常见书籍索引

| 索引 | 书名 | 最大章数 |
|------|------|--------|
| 0 | 创世记 | 50 |
| 1 | 出埃及记 | 40 |
| 39 | 马太福音 | 28 |
| 40 | 马可福音 | 16 |
| 41 | 路加福音 | 24 |
| 42 | 约翰福音 | 21 |
| 43 | 使徒行传 | 28 |

## 故障排除

### 问题：应用打开但没有跳转
**可能原因：**
- bookIndex 或 chapterIndex 无效
- AppProvider 还未完全加载
- MethodChannel 通信失败

**解决方案：**
1. 检查 logcat（Android）或 Xcode 控制台（iOS）中的日志
2. 验证参数值是否在有效范围内
3. 尝试重新启动应用

### 问题：应用卡在启动画面
**可能原因：**
- DeepLink 处理阻塞了主线程

**解决方案：**
1. 检查是否有未正确处理的异步操作
2. 查看 Flutter 分析日志

### 问题：iOS 上没有响应
**可能原因：**
- URL Scheme 没有在 Info.plist 中正确配置
- AppDelegate 没有正确处理 URL

**解决方案：**
1. 确认 Info.plist 中有 `CFBundleURLSchemes` 配置
2. 检查 AppDelegate.swift 中的 `getInitialDeepLink` 实现

## 调试技巧

### 添加日志输出
在 `lib/main.dart` 中的 `_handleDeepLink` 方法中添加日志：
```dart
print('DeepLink received: bookIndex=${deepLinkData.bookIndex}, '
      'chapterIndex=${deepLinkData.chapterIndex}, '
      'verseNum=${deepLinkData.verseNum}');
```

### 检查 MethodChannel 通信
在 iOS AppDelegate.swift 中：
```swift
print("Initial deeplink: \(self.initialDeepLink ?? "none")")
```

在 Android MainActivity.kt 中：
```kotlin
Log.d("MainActivity", "Initial deeplink: $initialDeepLink")
```

## 网页集成示例

```html
<!-- 生成动态链接 -->
<script>
function openBibleApp(bookIndex, chapterIndex, verseNum) {
  const deepLink = `bible-reader://open?bookIndex=${bookIndex}&chapterIndex=${chapterIndex}${verseNum ? `&verseNum=${verseNum}` : ''}`;
  
  // Android Intent URI
  const intentUri = `intent://open?bookIndex=${bookIndex}&chapterIndex=${chapterIndex}${verseNum ? `&verseNum=${verseNum}` : ''}#Intent;scheme=bible-reader;package=com.berlin.bible_reader;end`;
  
  // 尝试使用对应的 URL Scheme
  if (navigator.userAgent.toLowerCase().indexOf('android') > -1) {
    window.location.href = intentUri;
  } else {
    window.location.href = deepLink;
  }
}
</script>

<!-- 使用链接 -->
<a href="javascript:openBibleApp(0, 4, 1)">打开创世记第5章第1节</a>
```
