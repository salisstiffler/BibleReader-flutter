import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class VersionInfo {
  final String currentVersion;
  final int currentVersionCode;
  final String versionName;
  final int versionCode;
  final String updateInfo;
  final String fileUrl;
  final bool hasUpdate;
  final bool isForceUpdate;
  final String releaseDate;

  VersionInfo({
    required this.currentVersion,
    required this.currentVersionCode,
    required this.versionName,
    required this.versionCode,
    required this.updateInfo,
    required this.fileUrl,
    required this.hasUpdate,
    required this.isForceUpdate,
    required this.releaseDate,
  });

  factory VersionInfo.noUpdate({
    required String currentVersion,
    required int currentVersionCode,
  }) {
    return VersionInfo(
      currentVersion: currentVersion,
      currentVersionCode: currentVersionCode,
      versionName: currentVersion,
      versionCode: currentVersionCode,
      updateInfo: '',
      fileUrl: '',
      hasUpdate: false,
      isForceUpdate: false,
      releaseDate: '',
    );
  }
}

class VersionService {
  // API base URL - modify this to your actual server
  // For Android Emulator: use 10.0.2.2 instead of localhost
  // For Physical Device: use your PC's network IP (e.g., 192.168.1.100)
  static const String _apiBaseUrl = 'https://api.berlin2025.dpdns.org/api';

  // Get current platform (android, ios, windows, macos, linux)
  static String getPlatform() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  // Get version code from PackageInfo buildNumber (e.g., "20260207" for version "1.0.0+20260207")
  static Future<int> getVersionCode() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final buildNumber = packageInfo.buildNumber;
      
      if (kDebugMode) {
        print('[VersionService] PackageInfo - version: ${packageInfo.version}, buildNumber: $buildNumber');
      }
      
      // buildNumber should be the part after '+' in pubspec.yaml version
      // e.g., for "1.0.0+20260207", buildNumber = "20260207"
      return int.tryParse(buildNumber) ?? 1;
    } catch (e) {
      if (kDebugMode) {
        print('[VersionService] Error getting version code: $e');
      }
      return 1;
    }
  }

  // Get current app version
  static Future<String> getCurrentVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      return '1.0.0';
    }
  }

  // Check for updates from server
  static Future<VersionInfo> checkForUpdates() async {
    try {
      final currentVersion = await getCurrentVersion();
      final versionCode = await getVersionCode();
      final platform = getPlatform();

      // Build API URL with parameters
      final url =
          Uri.parse('$_apiBaseUrl/update/check?platform=$platform&currentVersionCode=$versionCode');

      if (kDebugMode) {
        print('[VersionService] Checking updates from: $url');
      }

      // Make API request
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (kDebugMode) {
        print('[VersionService] API Response Status: ${response.statusCode}');
        print('[VersionService] API Response Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (kDebugMode) {
          print('[VersionService] Parsed JSON: $json');
        }

        // If no update available
        if (json['update'] == false || json['update'] == null) {
          if (kDebugMode) {
            print('[VersionService] No update available');
          }
          return VersionInfo.noUpdate(
            currentVersion: currentVersion,
            currentVersionCode: versionCode,
          );
        }

        // Parse update information with new API format
        if (kDebugMode) {
          print('[VersionService] Update available: ${json['versionName']}');
        }

        return VersionInfo(
          currentVersion: currentVersion,
          currentVersionCode: versionCode,
          versionName: json['versionName'] ?? currentVersion,
          versionCode: json['versionCode'] ?? versionCode,
          updateInfo: json['updateInfo'] ?? '',
          fileUrl: json['fileUrl'] ?? '',
          hasUpdate: true,
          isForceUpdate: json['isForceUpdate'] ?? false,
          releaseDate: json['releaseDate'] ?? '',
        );
      } else {
        // If request fails, throw exception to trigger error handling
        if (kDebugMode) {
          print('[VersionService] API Error: Status Code ${response.statusCode}');
        }
        throw Exception('检查更新失败: HTTP ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[VersionService] Exception: $e');
      }
      rethrow; // 重新抛出异常，让调用者处理
    }
  }
}
