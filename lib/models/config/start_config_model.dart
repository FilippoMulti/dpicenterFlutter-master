import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

import 'change_log.dart';

part 'start_config_model.g.dart';

@JsonSerializable()
@CopyWith()
class StartConfig implements Equatable {
  ///dpi center backend url
  final String? url;
  final String? currentVersionString;
  final int? currentVersion;
  final int? connectionTimeout;
  final int? requestCloseTimeout;
  final List<ChangeLog>? changeLogs;

  StartConfig(
      {this.url,
      this.currentVersion,
      this.currentVersionString,
      this.connectionTimeout,
      this.requestCloseTimeout,
      this.changeLogs});

  factory StartConfig.fromJson(Map<String, dynamic> json) =>
      _$StartConfigFromJson(json);

  Map<String, dynamic> toJson() => _$StartConfigToJson(this);

  @override
  List<Object?> get props => [
        url,
        currentVersion,
        currentVersionString,
        connectionTimeout,
        requestCloseTimeout,
      ];

  @override
  bool? get stringify => true;

  static Future<StartConfig> loadFromAsset() async {
    try {
      String result =
          await rootBundle.loadString('configuration/start_config.json');
      return StartConfig.fromJson(jsonDecode(result));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return StartConfig();
  }
}
