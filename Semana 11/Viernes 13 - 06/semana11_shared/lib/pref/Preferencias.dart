import 'package:shared_preferences/shared_preferences.dart';

class Preferencias {

  SharedPreferences? preferencia;
  bool wifi=false;
  String pass="";

  Future<SharedPreferences?> get preferences async{
    if(preferencia==null){
      preferencia=await SharedPreferences.getInstance();
      wifi=preferencia?.getBool("wifi")??false;
      pass=preferencia?.getString("pass")??"";
    }
    return preferencia;
  }

  Future<Preferencias> init() async{
    preferencia=await preferences;
    return this;
  }

  Future<void> guardarRed() async{
    await preferencia?.setBool("wifi", wifi);
  }
  Future<void> guardarPass() async{
    await preferencia?.setString("pass", pass);
  }

}