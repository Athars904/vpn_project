import 'package:vpn_basic_project/models/vpn.dart';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;

class APIS {
  static Future<List<Vpn>> getVPNServer() async {
    final List<Vpn> vpnList = [];
    try{

      final response = await http.get(Uri.parse('https://www.vpngate.net/api/iphone/'));
      final csvString = response.body.split("#")[1].replaceAll('*', '');

      List<List<dynamic>> list = const CsvToListConverter().convert(csvString);
      final header = list[0];

      for (int i = 1; i < list.length - 1; ++i) {
        Map<String, dynamic> tempJson = {};
            for (int j = 0; j < header.length; ++j) {
              tempJson.addAll({header[j].toString(): list[i][j]});
            }
            vpnList.add(Vpn.fromJson(tempJson));
          }
    }
    on Exception catch(e){
      print(e);
    }
    vpnList.shuffle();
    return vpnList;
  }
}
