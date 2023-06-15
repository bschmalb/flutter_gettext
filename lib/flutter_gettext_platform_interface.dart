import 'package:flutter_gettext/flutter_gettext_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterGettextPlatform extends PlatformInterface {
  /// Constructs a FlutterGettextPlatform.
  FlutterGettextPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterGettextPlatform _instance = MethodChannelFlutterGettext();

  /// The default instance of [FlutterGettextPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterGettext].
  static FlutterGettextPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterGettextPlatform] when
  /// they register themselves.
  static set instance(FlutterGettextPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
