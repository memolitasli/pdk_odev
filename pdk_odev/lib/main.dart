import 'package:flutter/material.dart';
import 'package:pdk_odev/personel.dart';
import 'package:sqflite/sqflite.dart';
import 'personel_database.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      "/": (context) => girisSayfa(),
      "/personelListesi": (context) => personelListeSayfa(),
      "/personelKayit": (context) => anaSayfa()
    },
  ));
}

class girisSayfa extends StatefulWidget {
  const girisSayfa({Key? key}) : super(key: key);

  @override
  _girisSayfaState createState() => _girisSayfaState();
}

class _girisSayfaState extends State<girisSayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(child: Text("Personel Listesi"),onPressed: () {
                Navigator.pushNamed(context, '/personelListesi');
              }),
              RaisedButton(child: Text("Personel Kayıt"),onPressed: () {
                Navigator.pushNamed(context, '/personelKayit');
              })
            ],
          ),
        ),
      ),
    );
  }
}

class anaSayfa extends StatefulWidget {
  const anaSayfa({Key? key}) : super(key: key);

  @override
  _anaSayfaState createState() => _anaSayfaState();
}

List<String> bolumList = [
  "Halkla ilişkiler",
  "yazılım",
  "Pazarlama",
  "Muhasebe",
  "Donanım"
];

String dbSecilen = bolumList[0];

class _anaSayfaState extends State<anaSayfa> {
  String isim = "";
  String soyisim = "";
  String tcNo = "";
  String mailAdresi = "";
  String telefonNo = "";
  var dt = DateTime.now();
  String perFoto = "assets/trevor.jpeg";

  @override
  void initState() {
    // TODO: implement initState
    personelDatabase.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration:
                  InputDecoration(hintText: "İsim", icon: Icon(Icons.person)),
              onChanged: (deger) {
                setState(() {
                  isim = deger;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: "Soyisim", icon: Icon(Icons.person)),
              onChanged: (deger) {
                setState(() {
                  soyisim = deger;
                });
              },
            ),
            TextField(
                decoration:
                    InputDecoration(hintText: "Mail", icon: Icon(Icons.mail)),
                keyboardType: TextInputType.emailAddress,
                onChanged: (deger) {
                  setState(() {
                    mailAdresi = deger;
                  });
                }),
            TextField(
                decoration: InputDecoration(
                    hintText: "TC No",
                    icon: Icon(Icons.important_devices_sharp)),
                keyboardType: TextInputType.number,
                onChanged: (deger) {
                  setState(() {
                    tcNo = deger;
                  });
                }),
            TextField(
                decoration: InputDecoration(
                    hintText: "Telefon No", icon: Icon(Icons.phone)),
                keyboardType: TextInputType.number,
                onChanged: (deger) {
                  setState(() {
                    telefonNo = deger;
                  });
                }),
            Text("Bölüm"),
            DropdownButton(
              hint: Text("Kişinin Çalışacağı Bölüm"),
              value: dbSecilen,
              onChanged: (yeniSecilen) {
                setState(() {
                  dbSecilen = yeniSecilen.toString();
                  debugPrint(dbSecilen);
                });
              },
              items: [
                DropdownMenuItem(
                  child: Text("Yazılım"),
                  value: 'Yazılım',
                ),
                DropdownMenuItem(
                  child: Text("Donanım"),
                  value: 'Donanım',
                ),
                DropdownMenuItem(
                  child: Text("Pazarlama"),
                  value: 'Pazarlama',
                ),
                DropdownMenuItem(
                  child: Text("Halkla ilişkiler"),
                  value: 'Halkla ilişkiler',
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RaisedButton.icon(
                    onPressed: () async {
                      personel per = new personel(
                          isim: isim,
                          soyisim: soyisim,
                          bolum: dbSecilen,
                          tcNo: tcNo,
                          mailAdresi: mailAdresi,
                          telefonNo: telefonNo,
                          kayitTarihi: dt,
                          perFotoYolu: perFoto);
                      kayitEkle(per);
                    },
                    icon: Icon(Icons.save),
                    label: Text("Kayıt")),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                RaisedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.cancel),
                    label: Text("İptal")),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future kayitEkle(personel per) async {
    await personelDatabase.instance.create(per);
  }
}

class personelListeSayfa extends StatefulWidget {
  const personelListeSayfa({Key? key}) : super(key: key);

  @override
  _personelListeSayfaState createState() => _personelListeSayfaState();
}

class _personelListeSayfaState extends State<personelListeSayfa> {
  List<personel> personelListesi = [];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    personelYenile().whenComplete(() {
      setState(() {
        personelListesi;
      });
    });
  }

  Future personelYenile() async {
    setState(() async {
      this.personelListesi = await personelDatabase.instance.tumPersonelOku();
    });
  }

  @override
  Widget build(BuildContext context) {
    int arananID = -1;
    int arananindex = -1;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(hintText: "Aranan ID"),
          onChanged: (deger) {
            setState(() {
              arananID = int.parse(deger);
              for (int i = 0; i < personelListesi.length; i++) {
                if (arananID == personelListesi[i].id) {
                  setState(() {
                    arananindex = i;
                  });
                  break;
                }
              }
              if (arananindex != -1) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _alertDialog(context, arananindex);
                    });
              }
            });
          },
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if (personelListesi.isEmpty) {
            return Card(
              child: ListTile(
                title: Text('kayitli Personel Bulunamadi...'),
              ),
            );
          } else {
            return InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _alertDialog(context, index);
                    });
              },
              child: Card(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        image: AssetImage(personelListesi[index].perFotoYolu),
                        width: 50,
                        height: 50,
                      ),
                      Column(
                        children: [
                          Text("${personelListesi[index].id.toString()}"),
                          Text(
                              "${personelListesi[index].isim} ${personelListesi[index].soyisim}"),
                          Text("Bölüm : ${personelListesi[index].bolum}"),
                          Text(
                              "Telefon No : ${personelListesi[index].telefonNo.toString()}"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
        itemCount: personelListesi.length,
      ),
    );
  }

  _alertDialogGuncelleme(BuildContext context, int index) {
    String yeniisim = personelListesi[index].isim;
    String yenisoyisim = personelListesi[index].soyisim;
    String yenibolum = personelListesi[index].bolum;
    String yenimail = personelListesi[index].mailAdresi;
    String yeniTel = personelListesi[index].telefonNo;

    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Image(
              image: AssetImage(personelListesi[index].perFotoYolu),
              fit: BoxFit.fill,
            ),
          ),
          Text("Personel ID : ${personelListesi[index].id}"),
          TextField(
            decoration: InputDecoration(
                hintText: "İsim: ${personelListesi[index].isim} "),
            onChanged: (deger) {
              setState(() {
                yeniisim = deger;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(
                hintText: "Soyisim : ${personelListesi[index].soyisim} "),
            onChanged: (deger) {
              setState(() {
                yenisoyisim = deger;
              });
            },
          ),
          Text("İletişim Bilgileri"),
          TextField(
            onChanged: (deger) {
              setState(() {
                yeniTel = deger;
              });
            },
            decoration: InputDecoration(
              icon: Icon(Icons.phone),
              hintText: "${personelListesi[index].telefonNo}",
            ),
          ),
          TextField(
            onChanged: (deger) {
              setState(() {
                yenimail = deger;
              });
            },
            decoration: InputDecoration(
                icon: Icon(Icons.mail),
                hintText: "${personelListesi[index].mailAdresi}"),
          ),
          Text("Bölüm"),
          TextField(
            onChanged: (deger) {
              setState(() {
                yenibolum = deger;
              });
            },
            decoration: InputDecoration(
                icon: Icon(Icons.computer),
                hintText: "${personelListesi[index].bolum}"),
          ),
          RaisedButton(
            onPressed: () async {
              final per = personelListesi[index].copy(
                  isim: yeniisim,
                  soyisim: yenisoyisim,
                  bolum: yenibolum,
                  telefonNo: yeniTel,
                  mailAdresi: yenimail);
                  perGuncelle(per);
            },
            child: Text("Güncelle"),
          )
        ],
      ),
    );
  }
Future perGuncelle(personel per)async{
  await personelDatabase.instance.update(per);
}
  _alertDialog(BuildContext context, int index) {
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Image(
              image: AssetImage(personelListesi[index].perFotoYolu),
              fit: BoxFit.fill,
            ),
          ),
          Text("Personel ID : ${personelListesi[index].id}"),
          Text(
              "İsim Soyisim : ${personelListesi[index].isim} ${personelListesi[index].soyisim}"),
          Text("İletişim Bilgileri"),
          TextField(
            decoration: InputDecoration(
                icon: Icon(Icons.phone),
                hintText: "${personelListesi[index].telefonNo}"),
            enabled: false,
          ),
          TextField(
            decoration: InputDecoration(
                icon: Icon(Icons.mail),
                hintText: "${personelListesi[index].mailAdresi}"),
            enabled: false,
          ),
          Text("Bölüm"),
          TextField(
            decoration: InputDecoration(
                icon: Icon(Icons.computer),
                hintText: "${personelListesi[index].bolum}"),
            enabled: false,
          ),
          Row(
            children: [
              RaisedButton.icon(
                  onPressed: () async {
                    personelSil(personelListesi[index].id!)
                        .whenComplete(() => Navigator.pushNamed(context, '/'));
                  },
                  icon: Icon(Icons.delete),
                  label: Text("Personel Sil")),
              RaisedButton.icon(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _alertDialogGuncelleme(context, index);
                        });
                  },
                  icon: Icon(Icons.update),
                  label: Text("Güncelle"))
            ],
          )
        ],
      ),
    );
  }

  Future personelSil(int id) async {
    await personelDatabase.instance.delete(id);
    personelYenile();
  }
}
