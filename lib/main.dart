import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vpn_basic_project/screens/splash_screen.dart';
import 'package:get/get.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value){
    runApp(const MyApp());
  });

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OpenVpn Demo',
      home: SplashScreen(),
    );
  }
}
