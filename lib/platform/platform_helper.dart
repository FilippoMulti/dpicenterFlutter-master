import 'package:flutter/foundation.dart';

/*final isAndroidMobile =
    kIsWeb && (defaultTargetPlatform == TargetPlatform.android);
final isIOSMobile = kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS);
final isAndroid = (defaultTargetPlatform == TargetPlatform.android);
final isWindowsBrowser = (defaultTargetPlatform == TargetPlatform.windows);*/
final isAndroidMobile =
    kIsWeb && (defaultTargetPlatform == TargetPlatform.android);
final isIOSMobile = kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS);
final isAndroid =
    kIsWeb == false && (defaultTargetPlatform == TargetPlatform.android);

final isWindowsBrowser =
    kIsWeb && (defaultTargetPlatform == TargetPlatform.windows);
final isWindows =
    kIsWeb == false && (defaultTargetPlatform == TargetPlatform.windows);
final isIOS = kIsWeb == false && (defaultTargetPlatform == TargetPlatform.iOS);
final isLinux =
    kIsWeb == false && (defaultTargetPlatform == TargetPlatform.linux);
final isLinuxBrowser =
    kIsWeb && (defaultTargetPlatform == TargetPlatform.linux);
final isMacBrowser = kIsWeb && (defaultTargetPlatform == TargetPlatform.macOS);
final isMac = (defaultTargetPlatform == TargetPlatform.macOS);

final bool isDesktop = (isWindows || isMac || isLinux);
final bool isMobile = (isAndroid || isAndroidMobile || isIOS || isIOSMobile);
final bool isNativeMobile = (isAndroid || isIOS);
final bool isWebMobile = (isAndroidMobile || isIOSMobile);

String currentOs() {
  if (isWindows) {
    return "Windows";
  }
  if (isWindowsBrowser) {
    return "Browser su Windows";
  }

  if (isIOS) {
    return "IOS";
  }

  if (isIOSMobile) {
    return "Browser su IOS";
  }

  if (isAndroid) {
    return "Android";
  }

  if (isAndroidMobile) {
    return "Browser su Android";
  }

  if (isLinux) {
    return "Linux";
  }

  if (isLinuxBrowser) {
    return "Browser su Linux";
  }
  if (isMac) {
    return "MacOs";
  }

  if (isMacBrowser) {
    return "Browser su MacOs";
  }

  return "Sconosciuto";
}
