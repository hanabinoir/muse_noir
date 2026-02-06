import 'dart:io';
import 'package:muse_noir/core/constants/app_constants.dart';

/// Utility for file operations
class FileUtils {
  FileUtils._();

  /// Check if file has supported audio format
  static bool isSupportedAudioFile(String filePath) {
    final extension = _getFileExtension(filePath);
    return AppConstants.supportedAudioFormats.contains(extension.toLowerCase());
  }

  /// Get file extension including the dot
  /// Example: "/path/to/file.mp3" -> ".mp3"
  static String _getFileExtension(String filePath) {
    final lastDot = filePath.lastIndexOf('.');
    if (lastDot == -1) return '';
    return filePath.substring(lastDot);
  }

  /// Get file name without extension
  /// Example: "/path/to/file.mp3" -> "file"
  static String getFileNameWithoutExtension(String filePath) {
    final fileName = getFileName(filePath);
    final lastDot = fileName.lastIndexOf('.');
    if (lastDot == -1) return fileName;
    return fileName.substring(0, lastDot);
  }

  /// Get file name from path
  /// Example: "/path/to/file.mp3" -> "file.mp3"
  static String getFileName(String filePath) {
    return filePath.split(Platform.pathSeparator).last;
  }

  /// Get directory path from file path
  /// Example: "/path/to/file.mp3" -> "/path/to"
  static String getDirectoryPath(String filePath) {
    final lastSeparator = filePath.lastIndexOf(Platform.pathSeparator);
    if (lastSeparator == -1) return '';
    return filePath.substring(0, lastSeparator);
  }

  /// Check if file exists
  static Future<bool> fileExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Get file size in bytes
  static Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      return await file.length();
    } catch (e) {
      return 0;
    }
  }

  /// Format bytes to human-readable size
  /// Example: 1024 -> "1.0 KB"
  static String formatFileSize(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    double size = bytes.toDouble();
    int suffixIndex = 0;

    while (size >= 1024 && suffixIndex < suffixes.length - 1) {
      size /= 1024;
      suffixIndex++;
    }

    return '${size.toStringAsFixed(1)} ${suffixes[suffixIndex]}';
  }
}

