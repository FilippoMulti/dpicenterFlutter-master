import 'package:flutter/foundation.dart';
import 'package:signalr_core/signalr_core.dart';

class DpiCenterReconnectPolicy implements RetryPolicy {
  int delay = 1000;

  DpiCenterReconnectPolicy({
    required this.delay,
  });

  @override
  int? nextRetryDelayInMilliseconds(RetryContext retryContext) {
    if (kDebugMode) {
      print(
          "RetryContext previousRetryCount: ${retryContext.previousRetryCount}");
    }
    if (kDebugMode) {
      print(
          "RetryContext elapsedMilliseconds: ${retryContext.elapsedMilliseconds}");
    }
    if (kDebugMode) {
      print("RetryContext retryReason: ${retryContext.retryReason}");
    }
    return delay;
  }
}
