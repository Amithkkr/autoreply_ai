// ignore_for_file: avoid_classes_with_only_static_members

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DocumentPicker {
  /// Pick document
  /// [allowMultiple] pick multiple files
  /// [extension] filter file type by providing file extension
  /// [fileType] provide file type for pick particular media type
  static Future<List<PlatformFile>?> pickDocument({
    bool allowMultiple = false,
    String? extension,
    FileType fileType = FileType.any,
  }) async {
    try {
      // file_picker rejects FileType.custom without non-empty allowedExtensions
      // (Android: PlatformException "Unsupported filter... use FileType.any").
      final List<String>? allowedExtensions =
          (extension?.isNotEmpty ?? false)
              ? extension!.replaceAll(' ', '').split(',')
              : null;
      final bool customNeedsExtensions = fileType == FileType.custom &&
          (allowedExtensions == null || allowedExtensions.isEmpty);
      final FileType effectiveType =
          customNeedsExtensions ? FileType.any : fileType;

      return (await FilePicker.platform.pickFiles(
        type: effectiveType,
        allowMultiple: allowMultiple,
        allowedExtensions: effectiveType == FileType.custom
            ? allowedExtensions
            : null,
      ))
          ?.files;
    } on PlatformException catch (e, st) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: st);
    } catch (ex, st) {
      debugPrint(ex.toString());
      debugPrintStack(stackTrace: st);
    }
    return null;
  }
}
