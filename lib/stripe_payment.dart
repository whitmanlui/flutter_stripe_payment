import 'dart:async';

import 'package:flutter/services.dart';

class StripeSource {
  static const MethodChannel _channel = const MethodChannel('stripe_payment');

  /// opens the stripe dialog to add a new card
  /// if the source has been successfully added the card token will be returned
  static Future<String> addSource() async {
    final String token = await _channel.invokeMethod('addSource');
    return token;
  }

  static bool _publishableKeySet = false;

  static bool get ready => _publishableKeySet;

  /// set the publishable key that stripe should use
  /// call this once and before you use [addSource]
  static void setPublishableKey(String apiKey) {
    _channel.invokeMethod('setPublishableKey', apiKey);
    _publishableKeySet = true;
  }

  static Future<void> applyPayment() async {
    String returnMsg;
    try {
      final bool result = await _channel.invokeMethod('checkIfDeviceSupportsApplePay');
      if(result){
        final String status = await _channel.invokeMethod('handleApplePayButtonTapped');
        print(status);
      }
      returnMsg = '$result';
    } catch (e) {
      returnMsg = "Failed: '${e.message}'.";
    }
    print(returnMsg);
  }
}
