import 'package:flutter/material.dart';
import 'package:ilk_projem/arayuz/buttons.dart';

import 'baha.dart';

bool _faqDark = false;
class Faq extends StatefulWidget {
  final  bool dark;
  Faq({Key key, @required this.dark}) : super(key: key); 
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Faq> {
  void faqDark() async{
    _faqDark = widget.dark;
  }
  @override
  Widget build(BuildContext context) {
    faqDark();
    return Scaffold(
      backgroundColor: _faqDark ? Color(0xFF161616) : Colors.white,
      appBar: AppBar(
        backgroundColor: _faqDark ? Color(0xFF0E530C):Colors.green,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyKumbara()));
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'S.S.S',
              style: TextStyle(
                fontSize: 20,
              ),
              textDirection: TextDirection.rtl,
            )
          ],
        ),
        actions: <Widget>[
          Text(
            "v1.0   ",
            style: TextStyle(
              height: 2.2,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      body: Container(
        
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        //  margin: EdgeInsets.symmetric(vertical:20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    EntryItem(data[index]),
                itemCount: data.length,
              ),
            ),
            //MyButtons(Colors.black)
          ],
        ),
      ),
    );
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.as, [this.children = const <Entry>[]]);
  // ignore: non_constant_identifier_names
  final Text as;
  //final String title;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  
  Entry(
    Text('Neden Kumbara+ uygulamasını kullanmalıyım?',style: TextStyle(color: Colors.white),),
    <Entry>[
      Entry(
        Text('Kumbara+ sizi motive edici, para biriktirmenize yardımcı olacak bir uygulamadır. Eğer para biriktirmede zorluk çekiyorsanız bu uygulama tam size göre.'),
      )
    ],
  ),
  Entry(
    Text('Paramı uygulama hesabında mı saklamam gerek?'),
    <Entry>[
      Entry(
        Text(
            'Hayır, Kumbara+ sadece verilerinizi görselleştiren bir uygulamadır.'),
      )
    ],
  ),
  Entry(
    Text('Yeni özellikler eklenecek mi ?'),
    <Entry>[
      Entry(
        Text(
            'Ishkembe Studios olarak sabit kalmayı sevmeyen bir organizasyonuz ve geliştirmeye çok açık olan bu uygulamamızın yeni versiyonları yakın vakitte çıkacaktır.'),
      )
    ],
  ),
  Entry(
    Text('Ishkembe Studios Nedir?'),
    <Entry>[
      Entry(
        Text(
            "'CBU TECH' adlı Teknoloji şirketinin Start-Up projesi olan Ishkembe Studios, bir grup istekli ve yetenekli genç tarafından yönetilmektedir. Kar amacı gütmeyen bu kuruluş hayatı kolaylaştırmaya ve güzelleştirmeye yönelik çalışmalar yürütmektedir."),
      )
    ],
  ),
  Entry(
    Text('Size nasıl ulaşırım?'),
    <Entry>[
      Entry(
        Text('ishkembeStudios@gmail.com adlı mail adresinden ulaşabilirsiniz.'),
      )
    ],
  ),
  Entry(
    Text("Kumbara+'ı kimler kullanabilir?"),
    <Entry>[
      Entry(
        Text(
            'Herhangi bir kısıtlama yoktur, basit ve kullanışlı arayüzü sayesinde dileyen herkes kullanabilir.'),
      )
    ],
  ),
  Entry(
    Text("Uygulama nasıl geliştirildi?"),
    <Entry>[
      Entry(
        Text(
            'Bir Google projesi olan Flutter ile geliştirilmiştir.'),
      )
    ],
  ),
];
class EntryItem extends StatelessWidget {

  const EntryItem(this.entry);
  
  final Entry entry;
  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty)
      return ListTile(title: Text(root.as.data.toString(),style: TextStyle(color:_faqDark ? Colors.white70: Colors.black54),));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.as.data.toString(),style: TextStyle(color:_faqDark ? Colors.white:Colors.black),),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
