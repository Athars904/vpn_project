import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vpn_basic_project/models/vpn.dart';
late Size mq;

class VpnCard extends StatelessWidget {
  final Vpn vpn;

  const VpnCard({Key? key, required this.vpn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5.0,
      margin: EdgeInsets.symmetric(vertical: mq.height*.01),
      child: InkWell(
        borderRadius: BorderRadius.circular(5.0),
        onTap: ()
        {
          
        },
        child: ListTile(
          textColor: Colors.white38,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: Text(
            vpn.countryLong,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: Image.asset(
            'assets/flags/${vpn.countryShort.toLowerCase()}.png',
            width: 30, // Adjust width as needed
            height: 30, // Adjust height as needed
          ),
          subtitle: Row(
            children: [
              Icon(Icons.speed_rounded, color: Colors.lightBlueAccent, size: 20.0),
              SizedBox(width: 4),
              Text(
                _formatBytes(vpn.speed, 1),
                style: TextStyle(color: Colors.black54),
              )
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                vpn.numVpnSessions.toString(),
                style: TextStyle(color: Colors.black54, fontSize: 20.0),
              ),
              SizedBox(width: 4),
              Icon(
                CupertinoIcons.person_3_fill,
                color: Colors.lightBlueAccent,
                size: 25.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
  String _formatBytes(int bytes,int decimals)
  {
    if(bytes<=0)
      return "0 B";
    const suffixes=["Mpbs"];
    var i=(log(bytes)/log(1024)).floor();
    return '${(bytes/pow(1024, i)).toStringAsFixed(decimals)} ${suffixes}';
  }
}
