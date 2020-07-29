import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ilk_projem/arayuz/info.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audio_cache.dart';
import 'faq.dart';
import 'package:google_fonts/google_fonts.dart';

void enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

class Veriler {
  double biriken;
  double tamami;
  double doluYuzdelik;
  double bosYuzdelik;
  String hedefAdi = "";

  Veriler(double biriken, double tamami) {
    this.biriken = biriken;
    this.tamami = tamami;
  }

  double doluYuzdeHesapla() {
    doluYuzdelik = (biriken / tamami) * 100;
    return doluYuzdelik;
  }

  double bosYuzdeHesapla() {
    bosYuzdelik = 100 - doluYuzdeHesapla();
    return bosYuzdelik;
  }

  String birikenDondur() {
    return this.biriken.toString();
  }

  String birikecekDondur() {
    return (this.tamami - this.biriken).toString();
  }

  void hedefDegistir(double yeniHedefinFiyati) {
    this.tamami = yeniHedefinFiyati;
  }
}

class MyKumbara extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kumbara+',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Kumbara+'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool dark = false;
  final myControllerDouble = TextEditingController();
  final myControllerString = TextEditingController();
  static AudioCache player = new AudioCache();
  String paraEkleAz = "paraEkleAz.mp3";
  String paraEkleOrta = "paraEkleOrta.mp3";
  String paraEkleCok = "paraEkleCok.mp3";
  String paraCikar = "paraCikar.mp3";
  String click = "click.mp3";

  void _discrementCounter(double cikartilacak) async {
    final kayitAraci = await SharedPreferences.getInstance();
    setState(
      () {
        if (veri1.biriken - cikartilacak >= 0) {
          veri1.biriken -= cikartilacak;

          kayitAraci.setDouble("ka", veri1.biriken);
          if (!isMuted) {
            player.play(paraCikar);
          }
        } else {
          veri1.biriken = 0;
          kayitAraci.setDouble("ka", veri1.biriken);
          if (!isMuted) {
            player.play(paraCikar);
          }
        }
      },
    );
  }

  void grafikGuncelle() {
    dataMap.clear();
    dataMap.putIfAbsent("Biriken: " + veri1.birikenDondur() + "₺",
        () => veri1.doluYuzdeHesapla());
    dataMap.putIfAbsent("Birikecek: " + veri1.birikecekDondur() + "₺",
        () => veri1.bosYuzdeHesapla());
  }

  void _incrementCounter(double eklenecek) async {
    final kayitAraci = await SharedPreferences.getInstance();
    setState(() {
      if (veri1.biriken + eklenecek <= veri1.tamami) {
        veri1.biriken += eklenecek;

        kayitAraci.setDouble("ka", veri1.biriken);
        if (eklenecek > 0 && eklenecek < 10) {
          if (!isMuted) {
            player.play(paraEkleAz);
          }
        } else if (eklenecek > 10 && eklenecek < 50) {
          if (!isMuted) {
            player.play(paraEkleOrta);
          }
        } else if (eklenecek >= 50) {
          if (!isMuted) {
            player.play(paraEkleCok);
          }
        }
      } else {
        veri1.biriken = veri1.tamami;
        kayitAraci.setDouble("ka", veri1.biriken);
      }
    });
  }

  void duzenle(String textFieldText, double textFieldDouble) async {
    final kayitAraci = await SharedPreferences.getInstance();
    setState(() {
      if (veri1.biriken > textFieldDouble) {
        veri1.tamami = textFieldDouble;
        veri1.biriken = textFieldDouble;
      } else
        veri1.tamami = textFieldDouble;
      veri1.hedefAdi = textFieldText;

      kayitAraci.setString("kase", veri1.hedefAdi);
      kayitAraci.setDouble("kas", veri1.tamami);
      kayitAraci.setDouble("ka", veri1.biriken);
      grafikGuncelle();
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerDouble.dispose();
    super.dispose();
  }

  void _ekleShowDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Ekle"),
          content: new TextField(
            keyboardType: TextInputType.number,
            controller: myControllerDouble,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Ekleyeceğiniz miktarı girin...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  color: Colors.green,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Ekle"),
              onPressed: () {
                _incrementCounter(double.parse(myControllerDouble.text));
                grafikGuncelle();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _cikarShowDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Çıkar"),
          content: new TextField(
            keyboardType: TextInputType.number,
            controller: myControllerDouble,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Çıkaracağınız miktarı girin...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  color: Colors.green,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Çıkar"),
              onPressed: () {
                _discrementCounter(double.parse(myControllerDouble.text));
                grafikGuncelle();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _duzenleShowDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Hedefi Düzenle"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: myControllerString,
                  decoration: InputDecoration(
                    labelText: 'Yeni hedefinizin adını girin...',
                  ),
                ),
                TextField(
                  controller: myControllerDouble,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Yeni hedefinizin fiyatını girin...',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Kaydet"),
              onPressed: () {
                duzenle(myControllerString.text,
                    double.parse(myControllerDouble.text));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool isMuted = false;
  bool toggle = true;
  Map<String, double> dataMap = Map();
  Veriler veri1 = new Veriler(350, 3200);

  List<Color> colorListLight = [
    Colors.green,
    Colors.blueGrey[200],
  ];
  List<Color> colorListDark = [
    Color(0xFF0E530C),
    Color(0xFF656565),
  ];

  @override
  void initState() {
    
    super.initState();
    grafikGuncelle();
    
  }

 

  void getDark() async {
    final kayitAraci = await SharedPreferences.getInstance();
    setState(
      () {
        dark = kayitAraci.getBool("darkone");
        if (dark == null) {
          dark = false;
        }
      },
    );
  }

  void getIsMuted() async {
    final kayitAraci = await SharedPreferences.getInstance();
    setState(
      () {
        isMuted = kayitAraci.getBool("isMuted");
        if (isMuted == null) {
          isMuted = false;
        }
      },
    );
  }

  void getData() async {
    final kayitAraci = await SharedPreferences.getInstance();
    setState(
      () {
        veri1.biriken = kayitAraci.getDouble("ka");
        veri1.tamami = kayitAraci.getDouble("kas");
        veri1.hedefAdi = kayitAraci.getString("kase");
        if (veri1.biriken == null) {
          veri1.biriken = 1;
          kayitAraci.setDouble("ka", veri1.biriken);
        }
        if (veri1.tamami == null) {
          veri1.tamami = 1;
          kayitAraci.setDouble("kas", veri1.biriken);
        }
        if (veri1.hedefAdi == null) {
          veri1.hedefAdi = "Hedef Ekleyiniz";
          kayitAraci.setString("kase", veri1.hedefAdi);

        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getDark();
    getData();
    getIsMuted();
    grafikGuncelle();

    return Scaffold(
      backgroundColor: dark ? Color(0xFF161616) : Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: dark ? Color(0xFF0E530C) : Colors.green,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              flogoVeYaziLoD(),
              fit: BoxFit.cover,
              height: 42.0,
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 70,
          ),
          Text(
            "Hedefim: " + veri1.hedefAdi,
            style: GoogleFonts.hindSiliguri(
              color: dark ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            "Fiyatı: " + veri1.tamami.toString() + '₺',
            style: GoogleFonts.hindSiliguri(
              color: dark ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          toggle
              ? PieChart(
                  dataMap: dataMap,
                  animationDuration: Duration(milliseconds: 500),
                  chartLegendSpacing: 32.0,
                  chartRadius: MediaQuery.of(context).size.width / 2.1,
                  showChartValuesInPercentage: true,
                  showChartValues: true,
                  showChartValuesOutside: false,
                  chartValueBackgroundColor: Colors.grey[200],
                  colorList: dark ? colorListDark : colorListLight,
                  showLegends: true,
                  legendStyle:
                      TextStyle(color: dark ? Colors.white : Colors.black),
                  legendPosition: LegendPosition.bottom,
                  decimalPlaces: 1,
                  showChartValueLabel: true,
                  initialAngle: 0,
                  chartValueStyle: defaultChartValueStyle.copyWith(
                    color: Colors.blueGrey[900].withOpacity(0.9),
                  ),
                  chartType: ChartType.ring,
                )
              : Text("Grafik"),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton.extended(
                onPressed: () {
                  if (!isMuted) {
                    player.play(click, volume: 0.3);
                  }
                  _cikarShowDialog();
                },
                label: Text('Çıkar'),
                icon: Icon(Icons.remove_circle_outline),
                backgroundColor:
                    dark ? Color(0xFF656565) : Colors.blueGrey[200],
              ),
              SizedBox(
                width: 15,
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  if (!isMuted) {
                    player.play(click, volume: 0.3);
                  }
                  _ekleShowDialog();
                },
                label: Text('Ekle'),
                icon: Icon(Icons.add_circle_outline),
                backgroundColor: dark ? Color(0xFF0E530C) : Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          _duzenleShowDialog();
          if (!isMuted) {
            player.play(click, volume: 0.3);
          }
        },
        backgroundColor: dark ? Color(0xFF0E530C) : Colors.green,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: dark ? Color(0xFF0E530C) : Colors.green,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              alignment: Alignment.centerLeft,
              icon: Icon(Icons.info_outline),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Info(dark: dark)));
                if (isMuted == false) {
                  player.play(click, volume: 0.3);
                }
              },
            ),
            IconButton(
              alignment: Alignment.centerLeft,
              icon: dark ? Icon(Icons.brightness_3) : Icon(Icons.wb_sunny),
              color: Colors.white,
              onPressed: () async {
                final kayitAraci = await SharedPreferences.getInstance();
                setState(() {
                  dark = !dark;
                });
                if (!isMuted) {
                  player.play(click, volume: 0.3);
                }
                kayitAraci.setBool("darkone", dark);
              },
            ),
            SizedBox(width: 30),
            IconButton(
              icon: isMuted ? Icon(Icons.volume_off) : Icon(Icons.volume_up),
              alignment: Alignment.centerRight,
              color: Colors.white,
              onPressed: () async {
                final kayitAraci = await SharedPreferences.getInstance();
                setState(() {
                  isMuted = !isMuted;
                });
                if (!isMuted) {
                  player.play(click, volume: 0.3);
                }
                kayitAraci.setBool("isMuted", isMuted);
              },
            ),
            IconButton(
              icon: Icon(Icons.help_outline),
              alignment: Alignment.centerRight,
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Faq(dark: dark)));
                if (!isMuted) {
                  player.play(click, volume: 0.3);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void togglePieChart() {
    setState(() {
      toggle = !toggle;
    });
  }

  bool isLight = true;
  // ignore: missing_return
  String flogoVeYaziLoD() {
    if (dark == false) {
      String logoVeYaziLoD = 'assets/logoVeYaziLight.png';
      return logoVeYaziLoD;
    } else if (dark == true) {
      String logoVeYaziLoD = 'assets/logoVeYaziDark.png';
      return logoVeYaziLoD;
    }
  }
}
