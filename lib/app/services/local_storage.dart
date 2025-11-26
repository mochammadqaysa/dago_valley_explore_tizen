import 'dart:convert';
import 'dart:io';
import 'package:dago_valley_explore/domain/entities/brochure.dart';
import 'package:dago_valley_explore/domain/entities/event.dart';
import 'package:dago_valley_explore/domain/entities/housing.dart';
import 'package:dago_valley_explore/domain/entities/kpr_calculator.dart';
import 'package:dago_valley_explore/domain/entities/promo.dart';
import 'package:dago_valley_explore/domain/entities/site_plan.dart';
import 'package:dago_valley_explore/domain/entities/version.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _Key {
  user,
  promos,
  housing,
  events,
  siteplans,
  kprCalculators,
  brochures,
  versions,
  lastUpdate,
}

class LocalStorageService extends GetxService {
  SharedPreferences? _sharedPreferences;

  Future<LocalStorageService> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }

  // ========== User Management ==========
  User? get user {
    final rawJson = _sharedPreferences?.getString(_Key.user.toString());
    if (rawJson == null) return null;
    Map<String, dynamic> map = jsonDecode(rawJson);
    return User.fromJson(map);
  }

  set user(User? value) {
    if (value != null) {
      _sharedPreferences?.setString(
        _Key.user.toString(),
        json.encode(value.toJson()),
      );
    } else {
      _sharedPreferences?.remove(_Key.user.toString());
    }
  }

  // ========== Housing Management ==========
  Housing? get housings {
    final rawJson = _sharedPreferences?.getString(_Key.housing.toString());
    if (rawJson == null) return null;

    try {
      Map<String, dynamic> list = jsonDecode(rawJson);
      return Housing.fromJson(list);
    } catch (e) {
      print('Error parsing housings: $e');
      return null;
    }
  }

  set housings(Housing? value) {
    if (value != null) {
      _sharedPreferences?.setString(
        _Key.housing.toString(),
        json.encode(value.toJson()),
      );
    } else {
      _sharedPreferences?.remove(_Key.housing.toString());
    }
  }

  // ========== Promo Management ==========
  List<Promo>? get promos {
    final rawJson = _sharedPreferences?.getString(_Key.promos.toString());
    if (rawJson == null) return null;

    try {
      List<dynamic> list = jsonDecode(rawJson);
      return list
          .map((e) => Promo.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error parsing promos: $e');
      return null;
    }
  }

  set promos(List<Promo>? value) {
    if (value != null) {
      _sharedPreferences?.setString(
        _Key.promos.toString(),
        json.encode(value.map((e) => e.toJson()).toList()),
      );
    } else {
      _sharedPreferences?.remove(_Key.promos.toString());
    }
  }

  // ========== Event Management ==========
  List<Event>? get events {
    final rawJson = _sharedPreferences?.getString(_Key.events.toString());
    if (rawJson == null) return null;

    try {
      List<dynamic> list = jsonDecode(rawJson);
      return list
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error parsing events: $e');
      return null;
    }
  }

  set events(List<Event>? value) {
    if (value != null) {
      _sharedPreferences?.setString(
        _Key.events.toString(),
        json.encode(value.map((e) => e.toJson()).toList()),
      );
    } else {
      _sharedPreferences?.remove(_Key.events.toString());
    }
  }

  // ========== Siteplan Management ==========
  List<SitePlan>? get siteplans {
    final rawJson = _sharedPreferences?.getString(_Key.siteplans.toString());
    if (rawJson == null) return null;

    try {
      List<dynamic> list = jsonDecode(rawJson);
      return list
          .map((e) => SitePlan.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error parsing events: $e');
      return null;
    }
  }

  set siteplans(List<SitePlan>? value) {
    if (value != null) {
      _sharedPreferences?.setString(
        _Key.siteplans.toString(),
        json.encode(value.map((e) => e.toJson()).toList()),
      );
    } else {
      _sharedPreferences?.remove(_Key.siteplans.toString());
    }
  }

  // ========== KPR Calculator Management ==========
  List<KprCalculator>? get kprCalculators {
    final rawJson = _sharedPreferences?.getString(
      _Key.kprCalculators.toString(),
    );
    if (rawJson == null) return null;

    try {
      List<dynamic> list = jsonDecode(rawJson);
      return list
          .map((e) => KprCalculator.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error parsing kpr calculators: $e');
      return null;
    }
  }

  set kprCalculators(List<KprCalculator>? value) {
    if (value != null) {
      _sharedPreferences?.setString(
        _Key.kprCalculators.toString(),
        json.encode(value.map((e) => e.toJson()).toList()),
      );
    } else {
      _sharedPreferences?.remove(_Key.kprCalculators.toString());
    }
  }

  // ========== Brochure Management ==========
  List<Brochure>? get brochures {
    final rawJson = _sharedPreferences?.getString(_Key.brochures.toString());
    if (rawJson == null) return null;

    try {
      List<dynamic> list = jsonDecode(rawJson);
      return list
          .map((e) => Brochure.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error parsing brochures: $e');
      return null;
    }
  }

  set brochures(List<Brochure>? value) {
    if (value != null) {
      _sharedPreferences?.setString(
        _Key.brochures.toString(),
        json.encode(value.map((e) => e.toJson()).toList()),
      );
    } else {
      _sharedPreferences?.remove(_Key.events.toString());
    }
  }

  // ========== Version Management ==========
  Version? get versions {
    final rawJson = _sharedPreferences?.getString(_Key.versions.toString());
    if (rawJson == null) return null;

    try {
      Map<String, dynamic> map = jsonDecode(rawJson);
      return Version.fromJson(map);
    } catch (e) {
      print('Error parsing versions: $e');
      return null;
    }
  }

  set versions(Version? value) {
    if (value != null) {
      _sharedPreferences?.setString(
        _Key.versions.toString(),
        json.encode(value.toJson()),
      );
    } else {
      _sharedPreferences?.remove(_Key.versions.toString());
    }
  }

  // ========== Last Update Timestamp ==========
  DateTime? get lastUpdate {
    final timestamp = _sharedPreferences?.getInt(_Key.lastUpdate.toString());
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  set lastUpdate(DateTime? value) {
    if (value != null) {
      _sharedPreferences?.setInt(
        _Key.lastUpdate.toString(),
        value.millisecondsSinceEpoch,
      );
    } else {
      _sharedPreferences?.remove(_Key.lastUpdate.toString());
    }
  }

  // ========== Video Cache Management ==========

  /// Get cached video file path
  Future<String> getCachedVideoPath(String url) async {
    final directory = await getApplicationSupportDirectory();
    final filename = _getFilenameFromUrl(url);
    return '${directory.path}/videos/$filename';
  }

  /// Save video to local storage
  Future<File> saveVideoToLocal(String url, List<int> bytes) async {
    final directory = await getApplicationSupportDirectory();
    final videoDir = Directory('${directory.path}/videos');
    print('Video directory path: ${videoDir.path}');

    if (!await videoDir.exists()) {
      await videoDir.create(recursive: true);
      print('✅ Video directory created');
    }

    final filename = _getFilenameFromUrl(url);
    final file = File('${videoDir.path}/$filename');

    final savedFile = await file.writeAsBytes(bytes);
    final sizeMB = (bytes.length / 1024 / 1024).toStringAsFixed(2);
    print('✅ Video saved: ${file.path} ($sizeMB MB)');

    return savedFile;
  }

  /// Get local video file if exists
  Future<File?> getLocalVideo(String url) async {
    try {
      final path = await getCachedVideoPath(url);
      final file = File(path);
      if (await file.exists()) {
        final sizeMB = ((await file.length()) / 1024 / 1024).toStringAsFixed(2);
        print('✅ Video found in cache: ${file.path} ($sizeMB MB)');
        return file;
      }
    } catch (e) {
      print('❌ Error getting local video: $e');
    }
    return null;
  }

  /// Check if video exists in cache
  Future<bool> isVideoCached(String url) async {
    final file = await getLocalVideo(url);
    return file != null;
  }

  /// Get total size of cached videos in MB
  Future<double> getVideosCacheSize() async {
    try {
      final directory = await getApplicationSupportDirectory();
      final videoDir = Directory('${directory.path}/videos');

      if (!await videoDir.exists()) {
        return 0.0;
      }

      int totalBytes = 0;
      await for (var entity in videoDir.list(recursive: true)) {
        if (entity is File) {
          totalBytes += await entity.length();
        }
      }

      return totalBytes / 1024 / 1024; // Convert to MB
    } catch (e) {
      print('❌ Error calculating video cache size: $e');
      return 0.0;
    }
  }

  /// Clear video cache
  Future<void> clearVideoCache() async {
    try {
      final directory = await getApplicationSupportDirectory();
      final videoDir = Directory('${directory.path}/videos');

      if (await videoDir.exists()) {
        await videoDir.delete(recursive: true);
        print('✅ Video cache cleared');
      }
    } catch (e) {
      print('❌ Error clearing video cache: $e');
    }
  }

  /// Delete specific video from cache
  Future<bool> deleteVideoFromCache(String url) async {
    try {
      final file = await getLocalVideo(url);
      if (file != null && await file.exists()) {
        await file.delete();
        print('✅ Video deleted from cache: $url');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Error deleting video from cache: $e');
      return false;
    }
  }

  // ========== Image Cache Management ==========

  Future<String> getCachedImagePath(String url) async {
    final directory = await getApplicationSupportDirectory();
    final filename = _getFilenameFromUrl(url);
    return '${directory.path}/images/$filename';
  }

  Future<File> saveImageToLocal(String url, List<int> bytes) async {
    final directory = await getApplicationSupportDirectory();
    final imageDir = Directory('${directory.path}/images');
    print('Image directory path: ${imageDir.path}');

    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    final filename = _getFilenameFromUrl(url);
    final file = File('${imageDir.path}/$filename');
    return await file.writeAsBytes(bytes);
  }

  Future<File?> getLocalImage(String url) async {
    try {
      final path = await getCachedImagePath(url);
      final file = File(path);
      if (await file.exists()) {
        return file;
      }
    } catch (e) {
      print('Error getting local image: $e');
    }
    return null;
  }

  /// Check if image exists in cache
  Future<bool> isImageCached(String url) async {
    final file = await getLocalImage(url);
    return file != null;
  }

  /// Get total size of cached images in MB
  Future<double> getImagesCacheSize() async {
    try {
      final directory = await getApplicationSupportDirectory();
      final imageDir = Directory('${directory.path}/images');

      if (!await imageDir.exists()) {
        return 0.0;
      }

      int totalBytes = 0;
      await for (var entity in imageDir.list(recursive: true)) {
        if (entity is File) {
          totalBytes += await entity.length();
        }
      }

      return totalBytes / 1024 / 1024; // Convert to MB
    } catch (e) {
      print('❌ Error calculating image cache size: $e');
      return 0.0;
    }
  }

  /// Clear image cache
  Future<void> clearImageCache() async {
    try {
      final directory = await getApplicationSupportDirectory();
      final imageDir = Directory('${directory.path}/images');

      if (await imageDir.exists()) {
        await imageDir.delete(recursive: true);
        print('✅ Image cache cleared');
      }
    } catch (e) {
      print('❌ Error clearing image cache: $e');
    }
  }

  // ========== Helper Methods ==========

  /// Extract filename from URL, handling query parameters and special characters
  String _getFilenameFromUrl(String url) {
    // Remove query parameters
    final urlWithoutParams = url.split('?').first;

    // Get filename
    String filename = urlWithoutParams.split('/').last;

    // Sanitize filename (remove special characters except dots and dashes)
    filename = filename.replaceAll(RegExp(r'[^\w\s\-\.]'), '_');

    return filename;
  }

  /// Get total cache size (images + videos) in MB
  Future<double> getTotalCacheSize() async {
    final imageSize = await getImagesCacheSize();
    final videoSize = await getVideosCacheSize();
    return imageSize + videoSize;
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStatistics() async {
    try {
      final directory = await getApplicationSupportDirectory();
      final imageDir = Directory('${directory.path}/images');
      final videoDir = Directory('${directory.path}/videos');

      int imageCount = 0;
      int videoCount = 0;
      int imageBytes = 0;
      int videoBytes = 0;

      if (await imageDir.exists()) {
        await for (var entity in imageDir.list()) {
          if (entity is File) {
            imageCount++;
            imageBytes += await entity.length();
          }
        }
      }

      if (await videoDir.exists()) {
        await for (var entity in videoDir.list()) {
          if (entity is File) {
            videoCount++;
            videoBytes += await entity.length();
          }
        }
      }

      return {
        'imageCount': imageCount,
        'videoCount': videoCount,
        'imageSizeMB': (imageBytes / 1024 / 1024),
        'videoSizeMB': (videoBytes / 1024 / 1024),
        'totalSizeMB': ((imageBytes + videoBytes) / 1024 / 1024),
      };
    } catch (e) {
      print('❌ Error getting cache statistics: $e');
      return {
        'imageCount': 0,
        'videoCount': 0,
        'imageSizeMB': 0.0,
        'videoSizeMB': 0.0,
        'totalSizeMB': 0.0,
      };
    }
  }

  // ========== Clear All Cache ==========

  Future<void> clearCache() async {
    // Clear SharedPreferences data
    promos = null;
    events = null;
    kprCalculators = null;
    versions = null;
    lastUpdate = null;

    // Clear image cache
    await clearImageCache();

    // Clear video cache
    await clearVideoCache();

    print('✅ All cache cleared');
  }
}
