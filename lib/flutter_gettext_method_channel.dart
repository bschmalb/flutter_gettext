import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gettext/flutter_gettext_platform_interface.dart';

/// An implementation of [FlutterGettextPlatform] that uses method channels.
class MethodChannelFlutterGettext extends FlutterGettextPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_gettext');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
