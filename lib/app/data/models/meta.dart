class Meta {
  Surahs? surahs;
  Juzs? juzs;

  Meta({this.surahs, this.juzs});

  Meta.fromJson(Map<String, dynamic> json) {
    surahs =
        json['surahs'] != null ? new Surahs.fromJson(json['surahs']) : null;
    juzs = json['juzs'] != null ? new Juzs.fromJson(json['juzs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.surahs != null) {
      data['surahs'] = this.surahs!.toJson();
    }
    if (this.juzs != null) {
      data['juzs'] = this.juzs!.toJson();
    }
    return data;
  }
}

class Surahs {
  int? count;
  List<References>? references;

  Surahs({this.count, this.references});

  Surahs.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['references'] != null) {
      references = <References>[];
      json['references'].forEach((v) {
        references!.add(new References.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.references != null) {
      data['references'] = this.references!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Juzs {
  int? count;
  List<juzReferences>? references;

  Juzs({this.count, this.references});

  Juzs.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['references'] != null) {
      references = <juzReferences>[];
      json['references'].forEach((v) {
        references!.add(new juzReferences.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.references != null) {
      data['references'] = this.references!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class References {
  int? number;
  String? name;
  String? englishName;
  String? englishNameTranslation;
  int? numberOfAyahs;
  String? revelationType;

  References({
    this.number,
    this.name,
    this.englishName,
    this.englishNameTranslation,
    this.numberOfAyahs,
    this.revelationType,
  });

  References.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'];
    englishName = json['englishName'];
    englishNameTranslation = json['englishNameTranslation'];
    numberOfAyahs = json['numberOfAyahs'];
    revelationType = json['revelationType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['name'] = this.name;
    data['englishName'] = this.englishName;
    data['englishNameTranslation'] = this.englishNameTranslation;
    data['numberOfAyahs'] = this.numberOfAyahs;
    data['revelationType'] = this.revelationType;
    return data;
  }
}

class juzReferences {
  int? surah;
  int? ayah;

  juzReferences({this.surah, this.ayah});

  juzReferences.fromJson(Map<String, dynamic> json) {
    surah = json['surah'];
    ayah = json['ayah'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['surah'] = this.surah;
    data['ayah'] = this.ayah;
    return data;
  }
}
