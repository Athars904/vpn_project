import 'package:get/get.dart';
import 'package:vpn_basic_project/models/vpn.dart';
import 'package:vpn_basic_project/APIS/apis.dart';
class LocationController extends GetxController{
  List<Vpn>vpnList=[];
  final RxBool isLoading=false.obs;
  Future<void>getVPNData()async{
    isLoading.value=true;
    vpnList.clear();
    vpnList=await APIS.getVPNServer();
    isLoading.value=false;
  }

}