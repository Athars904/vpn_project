import 'package:get/get.dart';
import 'package:vpn_basic_project/services/vpn_engine.dart';
import 'package:flutter/material.dart';
import 'package:vpn_basic_project/models/vpn.dart';
import 'dart:convert';
import 'package:vpn_basic_project/models/vpn_config.dart';
class HomeController extends GetxController{
RxString vpnState = VpnEngine.vpnDisconnected.obs;
final Rx<Vpn>vpn=Vpn.fromJson({}).obs;


Future<void> connectToVpn() async {
  ///Stop right here if user not select a vpn
  if(vpn.value.openVPNConfigDataBase64.isEmpty) return;


  if (vpnState.value == VpnEngine.vpnDisconnected) {
    final data = Base64Decoder().convert(vpn.value.openVPNConfigDataBase64);
    final config = Utf8Decoder().convert(data);
    final vpnConfig = VpnConfig(
        country: vpn.value.countryLong,
        username: 'vpn',
        password: 'vpn',
        config: config);
     await VpnEngine.startVpn(vpnConfig);
  }
  VpnEngine.stopVpn();
}
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