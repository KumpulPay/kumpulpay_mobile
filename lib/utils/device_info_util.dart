import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

class DeviceInfoUtil {
  static Future<Map<String, dynamic>> initPlatformState() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        // Android
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceData = _readAndroidBuildData(androidInfo);
      } else if (Platform.isIOS) {
        // iOS
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceData = _readIosDeviceInfo(iosInfo);
      } else if (Platform.isLinux) {
        // Linux
        final linuxInfo = await deviceInfoPlugin.linuxInfo;
        deviceData = _readLinuxDeviceInfo(linuxInfo);
      } else if (Platform.isWindows) {
        // Windows
        final windowsInfo = await deviceInfoPlugin.windowsInfo;
        deviceData = _readWindowsDeviceInfo(windowsInfo);
      } else if (Platform.isMacOS) {
        // MacOS
        final macOsInfo = await deviceInfoPlugin.macOsInfo;
        deviceData = _readMacOsDeviceInfo(macOsInfo);
      } else {
        deviceData = {'Error': 'Platform not supported'};
      }
    } on PlatformException {
      deviceData = {'Error': 'Failed to get platform version.'};
    }

    return deviceData;
  }

  // Android Info
  static Map<String, dynamic> _readAndroidBuildDataFull(AndroidDeviceInfo build) {
    return {
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'serialNumber': build.serialNumber,
      'isLowRamDevice': build.isLowRamDevice,
    };
  }

  static Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return {
      'brand': build.brand,
      'model': build.model,
      'device': build.device,
      'androidId': build.id,
    };
  }

  // iOS Info
  static Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return {
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'identifierForVendor': data.identifierForVendor,
    };
  }

  // Linux Info
  static Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return {
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'machineId': data.machineId,
    };
  }

  // Windows Info
  static Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return {
      'computerName': data.computerName,
      'numberOfCores': data.numberOfCores,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
    };
  }

  // MacOS Info
  static Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return {
      'computerName': data.computerName,
      'model': data.model,
      'systemVersion': data.osRelease,
    };
  }
}
