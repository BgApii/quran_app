class DetailJuz {
  int? code;
  String? status;
  Data? data;

  DetailJuz({this.code, this.status, this.data});

  DetailJuz.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? number;
  List<Ayahs>? ayahs;
  Surahs? surahs;
  Edition? edition;

  Data({this.number, this.ayahs, this.surahs, this.edition});

  Data.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    if (json['ayahs'] != null) {
      ayahs = <Ayahs>[];
      json['ayahs'].forEach((v) {
        ayahs!.add(new Ayahs.fromJson(v));
      });
    }
    surahs =
        json['surahs'] != null ? new Surahs.fromJson(json['surahs']) : null;
    edition =
        json['edition'] != null ? new Edition.fromJson(json['edition']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    if (this.ayahs != null) {
      data['ayahs'] = this.ayahs!.map((v) => v.toJson()).toList();
    }
    if (this.surahs != null) {
      data['surahs'] = this.surahs!.toJson();
    }
    if (this.edition != null) {
      data['edition'] = this.edition!.toJson();
    }
    return data;
  }
}

class Ayahs {
  int? number;
  String? text;
  Surah? surah;
  int? numberInSurah;
  int? juz;
  int? manzil;
  int? page;
  int? ruku;
  int? hizbQuarter;
  Sajda? sajda; // Ubah tipe dari bool ke Sajda

  Ayahs({
    this.number,
    this.text,
    this.surah,
    this.numberInSurah,
    this.juz,
    this.manzil,
    this.page,
    this.ruku,
    this.hizbQuarter,
    this.sajda,
  });

  Ayahs.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    text = json['text'];
    surah = json['surah'] != null ? Surah.fromJson(json['surah']) : null;
    numberInSurah = json['numberInSurah'];
    juz = json['juz'];
    manzil = json['manzil'];
    page = json['page'];
    ruku = json['ruku'];
    hizbQuarter = json['hizbQuarter'];

    // Tangani properti sajda yang bisa berupa boolean atau objek
    if (json['sajda'] is bool) {
      sajda = Sajda(recommended: false, obligatory: false);
    } else if (json['sajda'] is Map<String, dynamic>) {
      sajda = Sajda.fromJson(json['sajda']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['text'] = text;
    if (surah != null) {
      data['surah'] = surah!.toJson();
    }
    data['numberInSurah'] = numberInSurah;
    data['juz'] = juz;
    data['manzil'] = manzil;
    data['page'] = page;
    data['ruku'] = ruku;
    data['hizbQuarter'] = hizbQuarter;
    if (sajda != null) {
      data['sajda'] = sajda!.toJson();
    }
    return data;
  }
}

class Sajda {
  int? id;
  bool? recommended;
  bool? obligatory;

  Sajda({this.id, this.recommended, this.obligatory});

  Sajda.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recommended = json['recommended'];
    obligatory = json['obligatory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['recommended'] = recommended;
    data['obligatory'] = obligatory;
    return data;
  }
}

class Surah {
  int? number;
  String? name;
  String? englishName;
  String? englishNameTranslation;
  String? revelationType;
  int? numberOfAyahs;

  Surah({
    this.number,
    this.name,
    this.englishName,
    this.englishNameTranslation,
    this.revelationType,
    this.numberOfAyahs,
  });

  Surah.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'];
    englishName = json['englishName'];
    englishNameTranslation = json['englishNameTranslation'];
    revelationType = json['revelationType'];
    numberOfAyahs = json['numberOfAyahs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['name'] = this.name;
    data['englishName'] = this.englishName;
    data['englishNameTranslation'] = this.englishNameTranslation;
    data['revelationType'] = this.revelationType;
    data['numberOfAyahs'] = this.numberOfAyahs;
    return data;
  }
}

class Surahs {
  Surah? s1;
  Surah? s2;

  Surahs({this.s1, this.s2});

  Surahs.fromJson(Map<String, dynamic> json) {
    s1 = json['1'] != null ? new Surah.fromJson(json['1']) : null;
    s2 = json['2'] != null ? new Surah.fromJson(json['2']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.s1 != null) {
      data['1'] = this.s1!.toJson();
    }
    if (this.s2 != null) {
      data['2'] = this.s2!.toJson();
    }
    return data;
  }
}

class Edition {
  String? identifier;
  String? language;
  String? name;
  String? englishName;
  String? format;
  String? type;
  String? direction;

  Edition({
    this.identifier,
    this.language,
    this.name,
    this.englishName,
    this.format,
    this.type,
    this.direction,
  });

  Edition.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    language = json['language'];
    name = json['name'];
    englishName = json['englishName'];
    format = json['format'];
    type = json['type'];
    direction = json['direction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identifier'] = this.identifier;
    data['language'] = this.language;
    data['name'] = this.name;
    data['englishName'] = this.englishName;
    data['format'] = this.format;
    data['type'] = this.type;
    data['direction'] = this.direction;
    return data;
  }
}
