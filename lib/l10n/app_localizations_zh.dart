// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '圣经阅读';

  @override
  String get navRead => '阅读';

  @override
  String get navBookmarks => '书签';

  @override
  String get navNotes => '笔记';

  @override
  String get navSearch => '搜索';

  @override
  String get navSettings => '我的';

  @override
  String get settingsTitle => '个性化设置';

  @override
  String get settingsSubtitle => '打造最适合您的灵修阅读环境';

  @override
  String get settingsUiLanguage => '语言预设';

  @override
  String get settingsVisualStyle => '视觉风格';

  @override
  String get settingsReadingControls => '阅读及朗读';

  @override
  String get settingsFontSize => '字体大小';

  @override
  String get settingsReadingEffect => '阅读模式';

  @override
  String get settingsAnimationEffect => '翻页效果';

  @override
  String get settingsCustomBg => '自定义背景';

  @override
  String get settingsAccentColor => '主题色调';

  @override
  String get settingsSpeechRate => '朗读速率';

  @override
  String get settingsContinuousReading => '沉浸式连续播放';

  @override
  String get settingsContinuousReadingDesc => '朗读完当前经文后自动进入下一节，适合闭目灵修。';

  @override
  String get settingsPauseOnSwitch => '切换章节时暂停';

  @override
  String get settingsPauseOnSwitchDesc => '手动切换章节时自动暂停播放，包括点击上/下一章按钮。';

  @override
  String get settingsThemeLight => '明亮';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsThemeSepia => '护眼';

  @override
  String get settingsFontFamily => '字体样式';

  @override
  String get settingsLineHeight => '行高比例';

  @override
  String get settingsEffectsScroll => '纵向滚动';

  @override
  String get settingsEffectsHorizontal => '横向滑屏';

  @override
  String get settingsEffectsPageFlip => '全屏页码';

  @override
  String get settingsEffectsPaginated => '全屏模式';

  @override
  String get settingsAnimationsNone => '无';

  @override
  String get settingsAnimationsFade => '渐隐';

  @override
  String get settingsAnimationsSlide => '滑屏';

  @override
  String get settingsAnimationsCurl => '仿真';

  @override
  String get settingsFontsSerif => '思源宋体';

  @override
  String get settingsFontsSans => '系统默认';

  @override
  String get settingsFontsKai => '优美楷体';

  @override
  String get settingsFontsRounded => '精致圆体';

  @override
  String get readerDailyWisdom => '今日灵修经文';

  @override
  String get readerAppTitle => '圣经阅读';

  @override
  String get readerMenu => '目录';

  @override
  String readerChapterSelect(Object book, Object chapter) {
    return '$book • 第 $chapter 章';
  }

  @override
  String get readerRangeSelect => '范围选择';

  @override
  String get readerSelectStartEnd => '选择起始和结束节';

  @override
  String readerVerseSingle(Object verse) {
    return '第 $verse 节';
  }

  @override
  String readerVerseRange(Object start, Object end) {
    return '第 $start-$end 节';
  }

  @override
  String get readerBookmark => '收藏';

  @override
  String get readerStop => '停止';

  @override
  String get readerListen => '朗读';

  @override
  String get readerPlayChapter => '播全章';

  @override
  String get readerHighlight => '高亮';

  @override
  String get readerAddNote => '添加笔记...';

  @override
  String get readerReading => '正在朗读';

  @override
  String get readerPrevChapter => '上一章';

  @override
  String get readerNextChapter => '下一章';

  @override
  String get readerFullscreenReader => '进入全屏阅读';

  @override
  String get readerExitFullscreen => '退出全屏';

  @override
  String get readerNotePlaceholder => '在这里写下您的灵修感悟...';

  @override
  String get readerShare => '分享经文';

  @override
  String get readerShareSuccess => '经文和链接已复制到剪贴板!';

  @override
  String get readerDrawerBooks => '目录';

  @override
  String get readerDrawerTitle => '目录';

  @override
  String get readerNote => '笔记';

  @override
  String get commonSave => '保存';

  @override
  String get commonCancel => '取消';

  @override
  String get commonClose => '关闭';

  @override
  String get commonExpand => '显示全文';

  @override
  String get commonCollapse => '收起';

  @override
  String get bookmarksTitle => '经文收藏';

  @override
  String bookmarksCount(Object count) {
    return '已珍藏 $count 条灵粮';
  }

  @override
  String get bookmarksEmpty => '书签栏空空的，开启您的读经之旅吧';

  @override
  String get bookmarksSearchPlaceholder => '搜索收藏的经文...';

  @override
  String get bookmarksEdit => '编辑';

  @override
  String bookmarksSelectedCount(Object count) {
    return '已选择 $count 项';
  }

  @override
  String bookmarksBatchDelete(Object count) {
    return '批量删除 ($count)';
  }

  @override
  String get bookmarksSelectAll => '全选';

  @override
  String get bookmarksReverseSelect => '反选';

  @override
  String bookmarksDeleteConfirm(Object count) {
    return '确定删除选中的 $count 条书签吗?';
  }

  @override
  String get bookmarksCancel => '取消';

  @override
  String get bookmarksConfirm => '确定删除';

  @override
  String get notesTitle => '灵修笔记';

  @override
  String notesCount(Object count) {
    return '已记录 $count 段感悟';
  }

  @override
  String get notesSearchPlaceholder => '搜索您的笔记或感悟...';

  @override
  String get notesEmpty => '笔尖未动,感悟从读经开始';

  @override
  String get notesEdit => '编辑';

  @override
  String notesSelectedCount(Object count) {
    return '已选择 $count 项';
  }

  @override
  String notesBatchDelete(Object count) {
    return '批量删除 ($count)';
  }

  @override
  String get notesSelectAll => '全选';

  @override
  String get notesReverseSelect => '反选';

  @override
  String notesDeleteConfirm(Object count) {
    return '确定删除选中的 $count 条笔记吗?';
  }

  @override
  String get notesCancel => '取消';

  @override
  String get notesConfirm => '确定删除';

  @override
  String get globalSearchTitle => '全局搜索';

  @override
  String get globalSearchSubtitle => '搜寻圣经中的真理与智慧';

  @override
  String get globalSearchPlaceholder => '输入关键字搜索经文内容...';

  @override
  String globalSearchCount(Object count) {
    return '共找到 $count 处经文';
  }

  @override
  String get globalSearchEmpty => '未搜索到相关经文，换个词试试吧';

  @override
  String get globalSearchSearching => '正在查考经卷...';

  @override
  String globalSearchResultFormat(Object book, Object chapter, Object verse) {
    return '$book $chapter:$verse';
  }

  @override
  String get authLoginTitle => '欢迎回来';

  @override
  String get authRegisterTitle => '创建账号';

  @override
  String get authLoginDesc => '登录以在不同设备间同步您的阅读进度和记录';

  @override
  String get authRegisterDesc => '开启云端同步，开启您的灵修之旅';

  @override
  String get authUsernamePlaceholder => '用户名';

  @override
  String get authPasswordPlaceholder => '密码';

  @override
  String get authLoginBtn => '立即登录';

  @override
  String get authRegisterBtn => '注册账号';

  @override
  String get authNoAccount => '还没有账号？';

  @override
  String get authHasAccount => '已有账号？';

  @override
  String get authSwitchRegister => '去注册';

  @override
  String get authSwitchLogin => '去登录';

  @override
  String get authLoggedIn => '账号已同步';

  @override
  String get authLogout => '退出登录';

  @override
  String get authGuestUser => '游客';

  @override
  String get authSyncActive => '云端同步已激活';

  @override
  String get authSyncPrompt => '登录以同步您的数据';

  @override
  String get simplifiedChinese => 'Simplified Chinese';

  @override
  String get traditionalChinese => 'Traditional Chinese';

  @override
  String get english => 'English';

  @override
  String get bookGn => '创世记';

  @override
  String get bookEx => '出埃及记';

  @override
  String get bookLv => '利未记';

  @override
  String get bookNm => '民数记';

  @override
  String get bookDt => '申命记';

  @override
  String get bookJs => '约书亚记';

  @override
  String get bookJud => '士师记';

  @override
  String get bookRt => '路得记';

  @override
  String get book1Sm => '撒母耳记上';

  @override
  String get book2Sm => '撒母耳记下';

  @override
  String get book1kgs => '列王纪上';

  @override
  String get book2kgs => '列王纪下';

  @override
  String get book1Ch => '历代志上';

  @override
  String get book2Ch => '历代志下';

  @override
  String get bookEzr => '以斯拉记';

  @override
  String get bookNe => '尼希米记';

  @override
  String get bookEt => '以斯帖记';

  @override
  String get bookJob => '约伯记';

  @override
  String get bookPs => '诗篇';

  @override
  String get bookPrv => '箴言';

  @override
  String get bookEc => '传道书';

  @override
  String get bookSo => '雅歌';

  @override
  String get bookIs => '以赛亚书';

  @override
  String get bookJr => '耶利米书';

  @override
  String get bookLm => '耶利米哀歌';

  @override
  String get bookEz => '以西结书';

  @override
  String get bookDn => '但以理书';

  @override
  String get bookHo => '何西阿书';

  @override
  String get bookJl => '约珥书';

  @override
  String get bookAm => '阿摩司书';

  @override
  String get bookOb => '俄巴底亚书';

  @override
  String get bookJn => '约拿书';

  @override
  String get bookMi => '弥迦书';

  @override
  String get bookNa => '那鸿书';

  @override
  String get bookHk => '哈巴谷书';

  @override
  String get bookZp => '西番雅书';

  @override
  String get bookHg => '哈该书';

  @override
  String get bookZc => '撒迦利亚书';

  @override
  String get bookMl => '玛拉基书';

  @override
  String get bookMt => '马太福音';

  @override
  String get bookMk => '马可福音';

  @override
  String get bookLk => '路加福音';

  @override
  String get bookJo => '约翰福音';

  @override
  String get bookAct => '使徒行传';

  @override
  String get bookRm => '罗马书';

  @override
  String get book1Co => '哥林多前书';

  @override
  String get book2Co => '哥林多后书';

  @override
  String get bookGl => '加拉太书';

  @override
  String get bookEph => '以弗所书';

  @override
  String get bookPh => '腓立比书';

  @override
  String get bookCl => '歌罗西书';

  @override
  String get book1ts => '帖撒罗尼迦前书';

  @override
  String get book2ts => '帖撒罗尼迦后书';

  @override
  String get book1tm => '提摩太前书';

  @override
  String get book2tm => '提摩太后书';

  @override
  String get bookTt => '提多书';

  @override
  String get bookPhm => '腓利门书';

  @override
  String get bookHb => '希伯来书';

  @override
  String get bookJm => '雅各书';

  @override
  String get book1Pe => '彼得前书';

  @override
  String get book2Pe => '彼得后书';

  @override
  String get book1Jn => '约翰一书';

  @override
  String get book2Jn => '约翰二书';

  @override
  String get book3Jn => '约翰三书';

  @override
  String get bookJd => '犹大书';

  @override
  String get bookRe => '启示录';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get appTitle => '圣经阅读';

  @override
  String get navRead => '阅读';

  @override
  String get navBookmarks => '书签';

  @override
  String get navNotes => '笔记';

  @override
  String get navSearch => '搜索';

  @override
  String get navSettings => '我的';

  @override
  String get settingsTitle => '个性化设置';

  @override
  String get settingsSubtitle => '打造最适合您的灵修阅读环境';

  @override
  String get settingsUiLanguage => '语言预设';

  @override
  String get settingsVisualStyle => '视觉风格';

  @override
  String get settingsReadingControls => '阅读及朗读';

  @override
  String get settingsFontSize => '字体大小';

  @override
  String get settingsReadingEffect => '阅读模式';

  @override
  String get settingsAnimationEffect => '翻页效果';

  @override
  String get settingsCustomBg => '自定义背景';

  @override
  String get settingsAccentColor => '主题色调';

  @override
  String get settingsSpeechRate => '朗读速率';

  @override
  String get settingsContinuousReading => '沉浸式连续播放';

  @override
  String get settingsContinuousReadingDesc => '朗读完当前经文后自动进入下一节，适合闭目灵修。';

  @override
  String get settingsPauseOnSwitch => '切换章节时暂停';

  @override
  String get settingsPauseOnSwitchDesc => '手动切换章节时自动暂停播放，包括点击上/下一章按钮。';

  @override
  String get settingsThemeLight => '明亮';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsThemeSepia => '护眼';

  @override
  String get settingsFontFamily => '字体样式';

  @override
  String get settingsLineHeight => '行高比例';

  @override
  String get settingsEffectsScroll => '纵向滚动';

  @override
  String get settingsEffectsHorizontal => '横向滑屏';

  @override
  String get settingsEffectsPageFlip => '全屏页码';

  @override
  String get settingsEffectsPaginated => '全屏模式';

  @override
  String get settingsAnimationsNone => '无';

  @override
  String get settingsAnimationsFade => '渐隐';

  @override
  String get settingsAnimationsSlide => '滑屏';

  @override
  String get settingsAnimationsCurl => '仿真';

  @override
  String get settingsFontsSerif => '思源宋体';

  @override
  String get settingsFontsSans => '系统默认';

  @override
  String get settingsFontsKai => '优美楷体';

  @override
  String get settingsFontsRounded => '精致圆体';

  @override
  String get readerDailyWisdom => '今日灵修经文';

  @override
  String get readerAppTitle => '圣经阅读';

  @override
  String get readerMenu => '目录';

  @override
  String readerChapterSelect(Object book, Object chapter) {
    return '$book • 第 $chapter 章';
  }

  @override
  String get readerRangeSelect => '范围选择';

  @override
  String get readerSelectStartEnd => '选择起始和结束节';

  @override
  String readerVerseSingle(Object verse) {
    return '第 $verse 节';
  }

  @override
  String readerVerseRange(Object start, Object end) {
    return '第 $start-$end 节';
  }

  @override
  String get readerBookmark => '收藏';

  @override
  String get readerStop => '停止';

  @override
  String get readerListen => '朗读';

  @override
  String get readerPlayChapter => '播全章';

  @override
  String get readerHighlight => '高亮';

  @override
  String get readerAddNote => '添加笔记...';

  @override
  String get readerReading => '正在朗读';

  @override
  String get readerPrevChapter => '上一章';

  @override
  String get readerNextChapter => '下一章';

  @override
  String get readerFullscreenReader => '进入全屏阅读';

  @override
  String get readerExitFullscreen => '退出全屏';

  @override
  String get readerNotePlaceholder => '在这里写下您的灵修感悟...';

  @override
  String get readerShare => '分享经文';

  @override
  String get readerShareSuccess => '经文和链接已复制到剪贴板!';

  @override
  String get readerDrawerBooks => '目录';

  @override
  String get readerDrawerTitle => '目录';

  @override
  String get readerNote => '笔记';

  @override
  String get commonSave => '保存';

  @override
  String get commonCancel => '取消';

  @override
  String get commonClose => '关闭';

  @override
  String get commonExpand => '显示全文';

  @override
  String get commonCollapse => '收起';

  @override
  String get bookmarksTitle => '经文收藏';

  @override
  String bookmarksCount(Object count) {
    return '已珍藏 $count 条灵粮';
  }

  @override
  String get bookmarksEmpty => '书签栏空空的，开启您的读经之旅吧';

  @override
  String get bookmarksSearchPlaceholder => '搜索收藏的经文...';

  @override
  String get bookmarksEdit => '编辑';

  @override
  String bookmarksSelectedCount(Object count) {
    return '已选择 $count 项';
  }

  @override
  String bookmarksBatchDelete(Object count) {
    return '批量删除 ($count)';
  }

  @override
  String get bookmarksSelectAll => '全选';

  @override
  String get bookmarksReverseSelect => '反选';

  @override
  String bookmarksDeleteConfirm(Object count) {
    return '确定删除选中的 $count 条书签吗?';
  }

  @override
  String get bookmarksCancel => '取消';

  @override
  String get bookmarksConfirm => '确定删除';

  @override
  String get notesTitle => '灵修笔记';

  @override
  String notesCount(Object count) {
    return '已记录 $count 段感悟';
  }

  @override
  String get notesSearchPlaceholder => '搜索您的笔记或感悟...';

  @override
  String get notesEmpty => '笔尖未动,感悟从读经开始';

  @override
  String get notesEdit => '编辑';

  @override
  String notesSelectedCount(Object count) {
    return '已选择 $count 项';
  }

  @override
  String notesBatchDelete(Object count) {
    return '批量删除 ($count)';
  }

  @override
  String get notesSelectAll => '全选';

  @override
  String get notesReverseSelect => '反选';

  @override
  String notesDeleteConfirm(Object count) {
    return '确定删除选中的 $count 条笔记吗?';
  }

  @override
  String get notesCancel => '取消';

  @override
  String get notesConfirm => '确定删除';

  @override
  String get globalSearchTitle => '全局搜索';

  @override
  String get globalSearchSubtitle => '搜寻圣经中的真理与智慧';

  @override
  String get globalSearchPlaceholder => '输入关键字搜索经文内容...';

  @override
  String globalSearchCount(Object count) {
    return '共找到 $count 处经文';
  }

  @override
  String get globalSearchEmpty => '未搜索到相关经文，换个词试试吧';

  @override
  String get globalSearchSearching => '正在查考经卷...';

  @override
  String globalSearchResultFormat(Object book, Object chapter, Object verse) {
    return '$book $chapter:$verse';
  }

  @override
  String get authLoginTitle => '欢迎回来';

  @override
  String get authRegisterTitle => '创建账号';

  @override
  String get authLoginDesc => '登录以在不同设备间同步您的阅读进度和记录';

  @override
  String get authRegisterDesc => '开启云端同步，开启您的灵修之旅';

  @override
  String get authUsernamePlaceholder => '用户名';

  @override
  String get authPasswordPlaceholder => '密码';

  @override
  String get authLoginBtn => '立即登录';

  @override
  String get authRegisterBtn => '注册账号';

  @override
  String get authNoAccount => '还没有账号？';

  @override
  String get authHasAccount => '已有账号？';

  @override
  String get authSwitchRegister => '去注册';

  @override
  String get authSwitchLogin => '去登录';

  @override
  String get authLoggedIn => '账号已同步';

  @override
  String get authLogout => '退出登录';

  @override
  String get authGuestUser => '游客';

  @override
  String get authSyncActive => '云端同步已激活';

  @override
  String get authSyncPrompt => '登录以同步您的数据';

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get english => '英语';

  @override
  String get bookGn => '创世记';

  @override
  String get bookEx => '出埃及记';

  @override
  String get bookLv => '利未记';

  @override
  String get bookNm => '民数记';

  @override
  String get bookDt => '申命记';

  @override
  String get bookJs => '约书亚记';

  @override
  String get bookJud => '士师记';

  @override
  String get bookRt => '路得记';

  @override
  String get book1Sm => '撒母耳记上';

  @override
  String get book2Sm => '撒母耳记下';

  @override
  String get book1kgs => '列王纪上';

  @override
  String get book2kgs => '列王纪下';

  @override
  String get book1Ch => '历代志上';

  @override
  String get book2Ch => '历代志下';

  @override
  String get bookEzr => '以斯拉记';

  @override
  String get bookNe => '尼希米记';

  @override
  String get bookEt => '以斯帖记';

  @override
  String get bookJob => '约伯记';

  @override
  String get bookPs => '诗篇';

  @override
  String get bookPrv => '箴言';

  @override
  String get bookEc => '传道书';

  @override
  String get bookSo => '雅歌';

  @override
  String get bookIs => '以赛亚书';

  @override
  String get bookJr => '耶利米书';

  @override
  String get bookLm => '耶利米哀歌';

  @override
  String get bookEz => '以西结书';

  @override
  String get bookDn => '但以理书';

  @override
  String get bookHo => '何西阿书';

  @override
  String get bookJl => '约珥书';

  @override
  String get bookAm => '阿摩司书';

  @override
  String get bookOb => '俄巴底亚书';

  @override
  String get bookJn => '约拿书';

  @override
  String get bookMi => '弥迦书';

  @override
  String get bookNa => '那鸿书';

  @override
  String get bookHk => '哈巴谷书';

  @override
  String get bookZp => '西番雅书';

  @override
  String get bookHg => '哈该书';

  @override
  String get bookZc => '撒迦利亚书';

  @override
  String get bookMl => '玛拉基书';

  @override
  String get bookMt => '马太福音';

  @override
  String get bookMk => '马可福音';

  @override
  String get bookLk => '路加福音';

  @override
  String get bookJo => '约翰福音';

  @override
  String get bookAct => '使徒行传';

  @override
  String get bookRm => '罗马书';

  @override
  String get book1Co => '哥林多前书';

  @override
  String get book2Co => '哥林多后书';

  @override
  String get bookGl => '加拉太书';

  @override
  String get bookEph => '以弗所书';

  @override
  String get bookPh => '腓立比书';

  @override
  String get bookCl => '歌罗西书';

  @override
  String get book1ts => '帖撒罗尼迦前书';

  @override
  String get book2ts => '帖撒罗尼迦后书';

  @override
  String get book1tm => '提摩太前书';

  @override
  String get book2tm => '提摩太后书';

  @override
  String get bookTt => '提多书';

  @override
  String get bookPhm => '腓利门书';

  @override
  String get bookHb => '希伯来书';

  @override
  String get bookJm => '雅各书';

  @override
  String get book1Pe => '彼得前书';

  @override
  String get book2Pe => '彼得后书';

  @override
  String get book1Jn => '约翰一书';

  @override
  String get book2Jn => '约翰二书';

  @override
  String get book3Jn => '约翰三书';

  @override
  String get bookJd => '犹大书';

  @override
  String get bookRe => '启示录';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => '聖經閱讀';

  @override
  String get navRead => '閱讀';

  @override
  String get navBookmarks => '書籤';

  @override
  String get navNotes => '筆記';

  @override
  String get navSearch => '搜索';

  @override
  String get navSettings => '我的';

  @override
  String get settingsTitle => '個性化設置';

  @override
  String get settingsSubtitle => '打造最適合您的靈修閱讀環境';

  @override
  String get settingsUiLanguage => '語言預設';

  @override
  String get settingsVisualStyle => '視覺風格';

  @override
  String get settingsReadingControls => '閱讀及朗讀';

  @override
  String get settingsFontSize => '字體大小';

  @override
  String get settingsReadingEffect => '閱讀模式';

  @override
  String get settingsAnimationEffect => '翻頁效果';

  @override
  String get settingsCustomBg => '自定義背景';

  @override
  String get settingsAccentColor => '主題色調';

  @override
  String get settingsSpeechRate => '朗讀速率';

  @override
  String get settingsContinuousReading => '沉浸式連續播放';

  @override
  String get settingsContinuousReadingDesc => '朗讀完當前經文後自動進入下一節，適合閉目靈修。';

  @override
  String get settingsPauseOnSwitch => '切換章節時暫停';

  @override
  String get settingsPauseOnSwitchDesc => '手動切換章節時自動暫停播放，包括點擊上/下一章按鈕。';

  @override
  String get settingsThemeLight => '明亮';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsThemeSepia => '護眼';

  @override
  String get settingsFontFamily => '字體樣式';

  @override
  String get settingsLineHeight => '行高比例';

  @override
  String get settingsEffectsScroll => '縱向滾動';

  @override
  String get settingsEffectsHorizontal => '橫向滑屏';

  @override
  String get settingsEffectsPageFlip => '全屏頁碼';

  @override
  String get settingsEffectsPaginated => '全屏模式';

  @override
  String get settingsAnimationsNone => '無';

  @override
  String get settingsAnimationsFade => '漸隱';

  @override
  String get settingsAnimationsSlide => '滑屏';

  @override
  String get settingsAnimationsCurl => '仿真';

  @override
  String get settingsFontsSerif => '襯線體 (宣講)';

  @override
  String get settingsFontsSans => '無襯線 (現代)';

  @override
  String get settingsFontsKai => '優美楷體';

  @override
  String get settingsFontsRounded => '精緻圓體';

  @override
  String get readerDailyWisdom => '今日靈修經文';

  @override
  String get readerAppTitle => '聖經閱讀';

  @override
  String get readerMenu => '目錄';

  @override
  String readerChapterSelect(Object book, Object chapter) {
    return '$book • 第 $chapter 章';
  }

  @override
  String get readerRangeSelect => '範圍選擇';

  @override
  String get readerSelectStartEnd => '選擇起始和結束節';

  @override
  String readerVerseSingle(Object verse) {
    return '第 $verse 節';
  }

  @override
  String readerVerseRange(Object start, Object end) {
    return '第 $start-$end 節';
  }

  @override
  String get readerBookmark => '收藏';

  @override
  String get readerStop => '停止';

  @override
  String get readerListen => '朗讀';

  @override
  String get readerPlayChapter => '播全章';

  @override
  String get readerHighlight => '高亮';

  @override
  String get readerAddNote => '添加筆記...';

  @override
  String get readerReading => '正在朗讀';

  @override
  String get readerPrevChapter => '上一章';

  @override
  String get readerNextChapter => '下一章';

  @override
  String get readerFullscreenReader => '進入全屏閱讀';

  @override
  String get readerExitFullscreen => '退出全屏';

  @override
  String get readerNotePlaceholder => '在這裡寫下您的靈修感悟...';

  @override
  String get readerShare => '分享經文';

  @override
  String get readerShareSuccess => '經文和鏈接已複製到剪貼板!';

  @override
  String get readerDrawerBooks => '目錄';

  @override
  String get readerDrawerTitle => '目錄';

  @override
  String get readerNote => '筆記';

  @override
  String get commonSave => '保存';

  @override
  String get commonCancel => '取消';

  @override
  String get commonClose => '關閉';

  @override
  String get commonExpand => '顯示全文';

  @override
  String get commonCollapse => '收起';

  @override
  String get bookmarksTitle => '經文收藏';

  @override
  String bookmarksCount(Object count) {
    return '已珍藏 $count 條靈糧';
  }

  @override
  String get bookmarksEmpty => '書籤欄空空的，開啟您的讀經之旅吧';

  @override
  String get bookmarksSearchPlaceholder => '搜索收藏的經文...';

  @override
  String get bookmarksEdit => '編輯';

  @override
  String bookmarksSelectedCount(Object count) {
    return '已選擇 $count 項';
  }

  @override
  String bookmarksBatchDelete(Object count) {
    return '批量刪除 ($count)';
  }

  @override
  String get bookmarksSelectAll => '全選';

  @override
  String get bookmarksReverseSelect => '反選';

  @override
  String bookmarksDeleteConfirm(Object count) {
    return '確定刪除選中的 $count 條書籤嗎?';
  }

  @override
  String get bookmarksCancel => '取消';

  @override
  String get bookmarksConfirm => '確定刪除';

  @override
  String get notesTitle => '靈修筆記';

  @override
  String notesCount(Object count) {
    return '已記錄 $count 段感悟';
  }

  @override
  String get notesSearchPlaceholder => '搜索您的筆記或感悟...';

  @override
  String get notesEmpty => '筆尖未動,感悟從讀經開始';

  @override
  String get notesEdit => '編輯';

  @override
  String notesSelectedCount(Object count) {
    return '已選擇 $count 項';
  }

  @override
  String notesBatchDelete(Object count) {
    return '批量刪除 ($count)';
  }

  @override
  String get notesSelectAll => '全選';

  @override
  String get notesReverseSelect => '反選';

  @override
  String notesDeleteConfirm(Object count) {
    return '確定刪除選中的 $count 條筆記嗎?';
  }

  @override
  String get notesCancel => '取消';

  @override
  String get notesConfirm => '確定刪除';

  @override
  String get globalSearchTitle => '全局搜索';

  @override
  String get globalSearchSubtitle => '搜尋聖經中的真理與智慧';

  @override
  String get globalSearchPlaceholder => '輸入關鍵字搜索經文內容...';

  @override
  String globalSearchCount(Object count) {
    return '共找到 $count 處經文';
  }

  @override
  String get globalSearchEmpty => '未搜索到相關經文，換個詞試試吧';

  @override
  String get globalSearchSearching => '正在查考經卷...';

  @override
  String globalSearchResultFormat(Object book, Object chapter, Object verse) {
    return '$book $chapter:$verse';
  }

  @override
  String get authLoginTitle => '歡迎回來';

  @override
  String get authRegisterTitle => '創建賬號';

  @override
  String get authLoginDesc => '登錄以在不同設備間同步您的閱讀進度和記錄';

  @override
  String get authRegisterDesc => '開啟雲端同步，開啟您的靈修之旅';

  @override
  String get authUsernamePlaceholder => '用戶名';

  @override
  String get authPasswordPlaceholder => '密碼';

  @override
  String get authLoginBtn => '立即登錄';

  @override
  String get authRegisterBtn => '註冊賬號';

  @override
  String get authNoAccount => '還沒有賬號？';

  @override
  String get authHasAccount => '已有賬號？';

  @override
  String get authSwitchRegister => '去註冊';

  @override
  String get authSwitchLogin => '去登錄';

  @override
  String get authLoggedIn => '賬號已同步';

  @override
  String get authLogout => '退出登錄';

  @override
  String get authGuestUser => '訪客';

  @override
  String get authSyncActive => '雲端同步已激活';

  @override
  String get authSyncPrompt => '登錄以同步您的數據';

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get english => '英語';

  @override
  String get bookGn => '創世記';

  @override
  String get bookEx => '出埃及記';

  @override
  String get bookLv => '利未記';

  @override
  String get bookNm => '民數記';

  @override
  String get bookDt => '申命記';

  @override
  String get bookJs => '約書亞記';

  @override
  String get bookJud => '士師記';

  @override
  String get bookRt => '路得記';

  @override
  String get book1Sm => '撒母耳記上';

  @override
  String get book2Sm => '撒母耳記下';

  @override
  String get book1kgs => '列王紀上';

  @override
  String get book2kgs => '列王紀下';

  @override
  String get book1Ch => '歷代志上';

  @override
  String get book2Ch => '歷代志下';

  @override
  String get bookEzr => '以斯拉記';

  @override
  String get bookNe => '尼希米記';

  @override
  String get bookEt => '以斯帖記';

  @override
  String get bookJob => '約伯記';

  @override
  String get bookPs => '詩篇';

  @override
  String get bookPrv => '箴言';

  @override
  String get bookEc => '傳道書';

  @override
  String get bookSo => '雅歌';

  @override
  String get bookIs => '以賽亞書';

  @override
  String get bookJr => '耶利米書';

  @override
  String get bookLm => '耶利米哀歌';

  @override
  String get bookEz => '以西結書';

  @override
  String get bookDn => '但以理書';

  @override
  String get bookHo => '何西阿書';

  @override
  String get bookJl => '約珥書';

  @override
  String get bookAm => '阿摩司書';

  @override
  String get bookOb => '俄巴底亞書';

  @override
  String get bookJn => '約拿書';

  @override
  String get bookMi => '彌迦書';

  @override
  String get bookNa => '那鴻書';

  @override
  String get bookHk => '哈巴谷書';

  @override
  String get bookZp => '西番雅書';

  @override
  String get bookHg => '哈該書';

  @override
  String get bookZc => '撒迦利亞書';

  @override
  String get bookMl => '瑪拉基書';

  @override
  String get bookMt => '馬太福音';

  @override
  String get bookMk => '馬可福音';

  @override
  String get bookLk => '路加福音';

  @override
  String get bookJo => '約翰福音';

  @override
  String get bookAct => '使徒行傳';

  @override
  String get bookRm => '羅馬書';

  @override
  String get book1Co => '哥林多前書';

  @override
  String get book2Co => '哥林多後書';

  @override
  String get bookGl => '加拉太書';

  @override
  String get bookEph => '以弗所書';

  @override
  String get bookPh => '腓立比書';

  @override
  String get bookCl => '歌羅西書';

  @override
  String get book1ts => '帖撒羅尼迦前書';

  @override
  String get book2ts => '帖撒羅尼迦後書';

  @override
  String get book1tm => '提摩太前書';

  @override
  String get book2tm => '提摩太後書';

  @override
  String get bookTt => '提多書';

  @override
  String get bookPhm => '腓利門書';

  @override
  String get bookHb => '希伯來書';

  @override
  String get bookJm => '雅各書';

  @override
  String get book1Pe => '彼得前書';

  @override
  String get book2Pe => '彼得後書';

  @override
  String get book1Jn => '約翰一書';

  @override
  String get book2Jn => '約翰二書';

  @override
  String get book3Jn => '約翰三書';

  @override
  String get bookJd => '猶大書';

  @override
  String get bookRe => '啟示錄';
}
