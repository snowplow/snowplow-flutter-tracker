// Copyright (c) 2022-present Snowplow Analytics Ltd. All rights reserved.
//
// This program is licensed to you under the Apache License Version 2.0,
// and you may not use this file except in compliance with the Apache License Version 2.0.
// You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the Apache License Version 2.0 is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.

import 'package:flutter/foundation.dart';

/// Overrides for the values for properties of the platform context.
/// Only available on mobile apps (Android and iOS), not on Web.
@immutable
class PlatformContextProperties {
  /// Operating system type (e.g., ios, tvos, watchos, osx, android).
  final String? osType;

  /// The current version of the operating system.
  final String? osVersion;

  /// The manufacturer of the product/hardware.
  final String? deviceVendor;

  /// The end-user-visible name for the end product.
  final String? deviceModel;

  /// The carrier of the SIM inserted in the device.
  final String? carrier;

  /// Type of network the device is connected to.
  final NetworkType? networkType;

  /// Radio access technology that the device is using.
  final String? networkTechnology;

  /// Advertising identifier on iOS (iOS only).
  final String? appleIdfa;

  /// UUID identifier for vendors on iOS (iOS only).
  final String? appleIdfv;

  /// Bytes of storage remaining.
  final int? availableStorage;

  /// Total size of storage in bytes.
  final int? totalStorage;

  /// Total physical system memory in bytes.
  final int? physicalMemory;

  /// Amount of memory in bytes available to the current app (iOS only).
  final int? appAvailableMemory;

  /// Remaining battery level as an integer percentage of total battery capacity.
  final int? batteryLevel;

  /// Battery state for the device.
  final BatteryState? batteryState;

  /// A Boolean indicating whether Low Power Mode is enabled (iOS only).
  final bool? lowPowerMode;

  /// A Boolean indicating whether the device orientation is portrait (either upright or upside down).
  final bool? isPortrait;

  /// Screen resolution in pixels. Arrives in the form of WIDTHxHEIGHT (e.g., 1200x900). Doesn't change when device orientation changes.
  final String? resolution;

  /// Scale factor used to convert logical coordinates to device coordinates of the screen (uses UIScreen.scale on iOS).
  final double? scale;

  /// System language currently used on the device (ISO 639).
  final String? language;

  /// Advertising identifier on Android (Android only).
  final String? androidIdfa;

  /// Available memory on the system in bytes (Android only).
  final int? systemAvailableMemory;

  /// Android vendor ID scoped to the set of apps published under the same Google Play developer account (see https://developer.android.com/training/articles/app-set-id) (Android only).
  final String? appSetId;

  /// Scope of the `appSetId`. Can be scoped to the app or to a developer account on an app store (all apps from the same developer on the same device will have the same ID) (Android only).
  final AppSetIdScope? appSetIdScope;

  const PlatformContextProperties({
    this.osType,
    this.osVersion,
    this.deviceVendor,
    this.deviceModel,
    this.carrier,
    this.networkType,
    this.networkTechnology,
    this.appleIdfa,
    this.appleIdfv,
    this.availableStorage,
    this.totalStorage,
    this.physicalMemory,
    this.appAvailableMemory,
    this.batteryLevel,
    this.batteryState,
    this.lowPowerMode,
    this.isPortrait,
    this.resolution,
    this.scale,
    this.language,
    this.androidIdfa,
    this.systemAvailableMemory,
    this.appSetId,
    this.appSetIdScope,
  });

  Map<String, Object?> toMap() {
    final conf = <String, Object?>{
      'osType': osType,
      'osVersion': osVersion,
      'deviceVendor': deviceVendor,
      'deviceModel': deviceModel,
      'carrier': carrier,
      'networkType': networkType?.name,
      'networkTechnology': networkTechnology,
      'appleIdfa': appleIdfa,
      'appleIdfv': appleIdfv,
      'availableStorage': availableStorage?.toString(),
      'totalStorage': totalStorage?.toString(),
      'physicalMemory': physicalMemory?.toString(),
      'appAvailableMemory': appAvailableMemory,
      'batteryLevel': batteryLevel,
      'batteryState': batteryState?.name,
      'lowPowerMode': lowPowerMode,
      'isPortrait': isPortrait,
      'resolution': resolution,
      'scale': scale,
      'language': language,
      'androidIdfa': androidIdfa,
      'systemAvailableMemory': systemAvailableMemory?.toString(),
      'appSetId': appSetId,
      'appSetIdScope': appSetIdScope?.name,
    };
    conf.removeWhere((key, value) => value == null);
    return conf;
  }
}

enum NetworkType {
  mobile,
  wifi,
  offline,
}

enum BatteryState { unplugged, charging, full }

enum AppSetIdScope { app, developer }
