import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/controllers/home_controller.dart';
import 'package:vpn_basic_project/screens/location_screen.dart';
import 'package:vpn_basic_project/widgets/home_card.dart';
import '../models/vpn_config.dart';
import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = HomeController();
  List<VpnConfig> _listVpn = [];
  VpnConfig? _selectedVpn;
  late Size mq;

  @override
  void initState() {
    super.initState();

    ///Add listener to update vpn state
    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });

    initVpn();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void initVpn() async {
    //sample vpn config file (you can get more from https://www.vpngate.net/)
    _listVpn.add(VpnConfig(
        config: await rootBundle.loadString('assets/vpn/japan.ovpn'),
        country: 'Japan',
        username: 'vpn',
        password: 'vpn'));

    _listVpn.add(VpnConfig(
        config: await rootBundle.loadString('assets/vpn/thailand.ovpn'),
        country: 'Thailand',
        username: 'vpn',
        password: 'vpn'));

    SchedulerBinding.instance
        .addPostFrameCallback((t) => setState(() => _selectedVpn = _listVpn.first));
  }

  @override
  Widget build(BuildContext context) {
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
          SizedBox(
            height: 40,
          ),
          HomeCard(
            title: 'Country',
            subtitle: 'Free',
            icon: CircleAvatar(child: Icon(Icons.vpn_lock_outlined)),
            colours: Colors.lightBlueAccent,
          ),
          SizedBox(height: 8),
          HomeCard(
            title: '100 ms',
            subtitle: 'PING',
            icon: CircleAvatar(child: Icon(Icons.flash_on)),
            colours: Colors.orangeAccent,
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
                    title: '$downloadSpeed',
                    subtitle: 'Download',
                    icon: CircleAvatar(child: Icon(Icons.download)),
                    colours: Colors.lightGreen,
                  ),
                  SizedBox(height: 8),
                  HomeCard(
                    title: '$uploadSpeed',
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

  void _connectClick() {
    ///Stop right here if user not select a vpn
    if (_selectedVpn == null) return;

    if (_controller.vpnState.value == VpnEngine.vpnDisconnected) {
      ///Start if stage is disconnected
      VpnEngine.startVpn(_selectedVpn!);
    } else {
      ///Stop if stage is "not" disconnected
      VpnEngine.stopVpn();
    }
  }

  Widget _vpnButton() => Column(
    children: [
      Semantics(
        button: true,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () {
            _connectClick();
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


// Center(
// child: TextButton(
// style: TextButton.styleFrom(
// shape: StadiumBorder(),
// backgroundColor: Theme.of(context).primaryColor,
// ),
// child: Text(
// _vpnState == VpnEngine.vpnDisconnected
// ? 'Connect VPN'
//     : _vpnState.replaceAll("_", " ").toUpperCase(),
// style: TextStyle(color: Colors.white),
// ),
// onPressed: _connectClick,
// ),
// ),
//
// //sample vpn list
// Column(
// children: _listVpn
//     .map(
// (e) => ListTile(
// title: Text(e.country),
// leading: SizedBox(
// height: 20,
// width: 20,
// child: Center(
// child: _selectedVpn == e
// ? CircleAvatar(
// backgroundColor: Colors.green)
//     : CircleAvatar(
// backgroundColor: Colors.grey)),
// ),
// onTap: () {
// log("${e.country} is selected");
// setState(() => _selectedVpn = e);
// },
// ),
// )
// .toList())
