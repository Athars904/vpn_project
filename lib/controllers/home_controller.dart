import 'package:get/get.dart';
import 'package:vpn_basic_project/services/vpn_engine.dart';
import 'package:flutter/material.dart';
class HomeController extends GetxController{
RxString vpnState = VpnEngine.vpnDisconnected.obs;
Color get getButtonColor{
  switch(vpnState.value)
      {
    case VpnEngine.vpnDisconnected:
      return Colors.lightBlueAccent;
    case VpnEngine.vpnConnected:
      return Colors.lightGreen;
    default:
      return Colors.orangeAccent;
  }
}

String get getButtonText{
  switch(vpnState.value)
      {
    case VpnEngine.vpnDisconnected:
      return 'Tap to Connect';
    case VpnEngine.vpnConnected:
      return 'Connected';
    default:
      return 'Connecting';
  }
}

}