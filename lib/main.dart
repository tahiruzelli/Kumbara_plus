import 'package:flutter/material.dart';
import 'arayuz/baha.dart';
import 'arayuz/intro.dart';
import 'package:shared_preferences/shared_preferences.dart';
  void main() async {
    WidgetsFlutterBinding.ensureInitialized ();
    final kayitAraci = await SharedPreferences.getInstance();
    bool gorduMu = false;
    bool son;
    bool durum = kayitAraci.getBool("gerekl");
    setState() {
      son = durum;
    }
 
    enablePlatformOverrideForDesktop();
    if (durum == false || durum == null) {
      gorduMu = true;
      kayitAraci.setBool("gerekl", gorduMu);
      runApp(Intro());
    } else if(durum == true) {
      runApp(MyKumbara());
    }
  }


