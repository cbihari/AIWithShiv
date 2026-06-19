import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceModeService {
  const DeviceModeService._();

  static const instance = DeviceModeService._();

  Future<bool> isLowEndDevice() async {
    try {
      if (!Platform.isAndroid) return false;
      final info = await DeviceInfoPlugin().androidInfo;
      return info.isLowRamDevice;
    } catch (_) {
      return false;
    }
  }
}
