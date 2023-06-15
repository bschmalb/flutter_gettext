#include "include/flutter_gettext/flutter_gettext_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_gettext_plugin.h"

void FlutterGettextPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_gettext::FlutterGettextPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
