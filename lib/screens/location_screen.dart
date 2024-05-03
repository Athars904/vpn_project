import 'package:flutter/material.dart';
import 'package:vpn_basic_project/APIS/apis.dart';
import 'package:lottie/lottie.dart';
import 'package:vpn_basic_project/controllers/location_controller.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/widgets/vpncard.dart';
class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late Size mq;
  final _controller=LocationController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.getVPNData();
  }
  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Obx(()=>SafeArea(child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text('Location Screen (${_controller.vpnList.length})',style: TextStyle(
            fontWeight: FontWeight.w500
          ),),
        ),
        body: _controller.isLoading.value?_loadingWidget()
            :_controller.vpnList.isEmpty?_noVPNFound():_vpnData(),
      )),
    );
  }
  _vpnData()=>ListView.builder(itemCount: _controller.vpnList.length,
      padding: EdgeInsets.only(
        top: mq.height*.02,
        bottom: mq.height*.1,
        left: mq.width*.04,
        right: mq.width*.04
      ),
      physics: BouncingScrollPhysics(),
      itemBuilder: (context,index)=>VpnCard(vpn: _controller.vpnList[index],));
  _loadingWidget()=> SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset('assets/lottie/lottieanim.json',width: 250,height: 250,),
          Text('Thank you for your patience',style: TextStyle(fontSize: 24),)
        ],
      ),
    ),
  );
  _noVPNFound()=>Center(
    child: Text('No VPN Servers Found',
    style: TextStyle(
      color: Colors.black54,
      fontSize: 28,
      fontWeight: FontWeight.bold
    ),),
  );
}
