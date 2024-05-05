import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/controllers/home_controller.dart';
import 'package:vpn_basic_project/screens/location_screen.dart';
import 'package:vpn_basic_project/widgets/home_card.dart';
import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';
late Size mq;
class HomeScreen extends StatelessWidget {
  final _controller = Get.put(HomeController());
  HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {

    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });
    mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(CupertinoIcons.home),
          title: Center(child: Text('Madly VPN')), // Center the title
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.info_outline),
              color: Colors.orange,
            ),
          ],
        ),
        bottomNavigationBar: _changeLocation(),
        body: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            height: mq.height * .02,
            width: double.maxFinite,
          ),
          Obx(() => _vpnButton()),
          Obx(()=>Column(
              children: [

                SizedBox(
                  height: 40,
                ),
                HomeCard(
                  title: _controller.vpn.value.countryLong.isEmpty?'Country':_controller.vpn.value.countryLong,
                  subtitle: 'Free',
                  icon: _controller.vpn.value.countryLong.isEmpty
                      ? Icon(Icons.vpn_lock_outlined)
                      : ClipOval(
                    child: Image.asset(
                      'assets/flags/${_controller.vpn.value.countryShort.toLowerCase()}.png',
                      width: 40.0, // Adjust width as needed
                      height: 40.0, // Adjust height as needed
                      fit: BoxFit.cover, // Ensure the image covers the circular area
                    ),
                  ),


                  colours: Colors.lightBlueAccent,
                ),
                SizedBox(height: 8),
                HomeCard(
                  title: _controller.vpn.value.ping.isEmpty?'100 ms':
                  _controller.vpn.value.ping+ ' ms',
                  subtitle: 'PING',
                  icon: CircleAvatar(child: Icon(Icons.flash_on)),
                  colours: Colors.orangeAccent,
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          StreamBuilder<VpnStatus>(
            initialData: VpnStatus(),
            stream: VpnEngine.vpnStatusSnapshot().map<VpnStatus>((snapshot) => snapshot!),
            builder: (context, snapshot) {
              final data = snapshot.data;
              final downloadSpeed = data?.byteIn ?? 0;
              final uploadSpeed = data?.byteOut ?? 0;
              return Column(
                children: [
                  HomeCard(
                    title: _controller.vpn.value.ping.isEmpty?'0':'$downloadSpeed',
                    subtitle: 'Download',
                    icon: CircleAvatar(child: Icon(Icons.download)),
                    colours: Colors.lightGreen,
                  ),
                  SizedBox(height: 8),
                  HomeCard(
                    title: _controller.vpn.value.ping.isEmpty?'0':'$uploadSpeed',
                    subtitle: 'Upload',
                    icon: CircleAvatar(child: Icon(Icons.upload)),
                    colours: Colors.redAccent,
                  ),
                ],
              );
            },
          ),
        ]),
      ),
    );
  }

  Widget _vpnButton() => Column(
    children: [
      Semantics(
        button: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () {
            _controller.connectToVpn();
          },
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _controller.getButtonColor.withOpacity(.3),
            ),
            child: Container(
              width: mq.height * .14,
              height: mq.height * .14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _controller.getButtonColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.power,
                    size: 28,
                    color: Colors.white,
                  ),
                  SizedBox(height: 4),
                  Text(
                    _controller.getButtonText,
                    style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: mq.height * .015),
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          _controller.vpnState.value == VpnEngine.vpnDisconnected
              ? 'Not Connected'
              : _controller.vpnState.replaceAll('_', ' ').toUpperCase(),
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      )
    ],
  );

  Widget _changeLocation() => Semantics(
    button: true,
    child: InkWell(
      onTap: () {
        Get.to(LocationScreen());
      },
      child: Container(
        height: 60,
        color: Colors.lightBlueAccent,
        padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.globe,
              size: 28,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              'Change Location',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0),
            ),
            Spacer(),
            CircleAvatar(
              child: Icon(Icons.navigate_next_rounded),
            )
          ],
        ),
      ),
    ),
  );
}