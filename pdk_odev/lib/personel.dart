final String tablePersonel = 'tblpersonel';

class personelField {
  static final List<String> values = [
    id,
    isim,
    soyisim,
    mailAdresi,
    telefonNo,
    perFotoYolu,
    bolum,
    kayitTarihi,
    tcNo
  ];
  static final String id = '_id';
  static final String isim = 'isim';
  static final String soyisim = 'soyisim';
  static final String mailAdresi = 'mailAdresi';
  static final String telefonNo = 'telefonNo';
  static final String perFotoYolu = 'perFotoYolu';
  static final String bolum = 'bolum';
  static final String kayitTarihi = 'kayitTarihi';
  static final String tcNo = 'tcNo';

}

class personel {
  final int? id;
  final String isim;
  final String soyisim;
  final String mailAdresi;
  final String telefonNo;
  final String tcNo;
  final String perFotoYolu;
  final DateTime kayitTarihi;
  final String bolum;

  const personel({
    this.id,
    required this.isim,
    required this.soyisim,
    required this.bolum,
    required this.tcNo,
    required this.mailAdresi,
    required this.telefonNo,
    required this.kayitTarihi,
    required this.perFotoYolu
  });

  Map<String, Object?> toJson() =>
      {
        personelField.id: id,
        personelField.isim: isim,
        personelField.soyisim: soyisim,
        personelField.tcNo: tcNo,
        personelField.telefonNo: telefonNo,
        personelField.mailAdresi: mailAdresi,
        personelField.perFotoYolu: perFotoYolu,
        personelField.kayitTarihi: kayitTarihi.toString(),
        personelField.bolum: bolum
      };

  personel copy({
    int? id,
    String? isim,
    String? soyisim,
    String? bolum,
    String? tcNo,
    String? mailAdresi,
    String? telefonNo,
    DateTime? kayitTarihi,
    String? perFotoYolu
  }) =>
      personel(
          id:id ?? this.id,
          isim: isim ?? this.isim,
          soyisim: soyisim ?? this.soyisim,
          bolum: bolum ?? this.bolum,
          tcNo: tcNo ?? this.tcNo,
          mailAdresi: mailAdresi ?? this.mailAdresi,
          telefonNo: telefonNo ?? this.telefonNo,
          kayitTarihi: kayitTarihi ?? this.kayitTarihi,
          perFotoYolu: perFotoYolu ?? this.perFotoYolu);

  static personel fromJson(Map<String,Object?> json)=>personel(
    id: json[personelField.id] as int?,
    isim: json[personelField.isim] as String,
    soyisim: json[personelField.soyisim] as String,
    bolum:  json[personelField.bolum] as String,
    kayitTarihi: DateTime.parse(json[personelField.kayitTarihi] as String),
    mailAdresi: json[personelField.mailAdresi] as String,
    telefonNo: json[personelField.telefonNo] as String,
    tcNo: json[personelField.tcNo] as String,
    perFotoYolu:  json[personelField.perFotoYolu] as String,
  );
}