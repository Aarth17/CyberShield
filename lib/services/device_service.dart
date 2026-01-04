import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<Map<String, dynamic>> getDeviceInfo() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return {
        'model': '${androidInfo.manufacturer} ${androidInfo.model}',
        'os': 'Android ${androidInfo.version.release}',
        'sdk': 'API ${androidInfo.version.sdkInt}',
      };
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return {
        'model': iosInfo.model,
        'os': '${iosInfo.systemName} ${iosInfo.systemVersion}',
        'sdk': iosInfo.utsname.machine,
      };
    }

    return {
      'model': 'Unknown',
      'os': 'Unknown',
      'sdk': 'Unknown',
    };
  }
}
