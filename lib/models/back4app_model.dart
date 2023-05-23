import 'dart:convert';

Back4appModel back4AppmodelFromJson(String str) =>
    Back4appModel.fromJson(json.decode(str));

String back4AppmodelToJson(Back4appModel data) => json.encode(data.toJson());

class Back4appModel {
  List<AddressModel>? results;

  Back4appModel({
    this.results,
  });

  factory Back4appModel.fromJson(Map<String, dynamic> json) => Back4appModel(
        results: List<AddressModel>.from(
            json['results'].map((x) => AddressModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'results': results != null
            ? List<dynamic>.from(results!.map((x) => x.toJson()))
            : [],
      };
}

class AddressModel {
  String? objectId;
  String cep;
  String rua;
  DateTime? createdAt;
  DateTime? updatedAt;

  AddressModel({
    this.objectId,
    required this.cep,
    required this.rua,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        objectId: json['objectId'],
        cep: json['cep'],
        rua: json['rua'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'cep': cep,
        'rua': rua,
      };
}

/*
class Back4appModel {
  List<AdressModel>? results;

  Back4appModel({
    this.results,
  });

  Back4appModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <AdressModel>[];
      json['results'].forEach((v) {
        results!.add(AdressModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AdressModel {
  String? objectId;
  String? cep;
  String? rua;
  String? createdAt;
  String? updatedAt;

  AdressModel({
    this.objectId,
    this.cep,
    this.rua,
    this.createdAt,
    this.updatedAt,
  });

  AdressModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    cep = json['cep'];
    rua = json['rua'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //data['objectId'] = objectId;
    data['cep'] = cep;
    data['rua'] = rua;
    //data['createdAt'] = createdAt;
    //data['updatedAt'] = updatedAt;
    return data;
  }
}
*/
