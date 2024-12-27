// To parse this JSON data, do
//
//     final cardModel = cardModelFromJson(jsonString);

import 'dart:convert';

CardModel cardModelFromJson(String str) => CardModel.fromJson(json.decode(str));

String cardModelToJson(CardModel data) => json.encode(data.toJson());

class CardModel {
  String cardId;
  DateTime createdDate;
  bool delete;
  String designation;
  String email;
  String facebook;
  String linkedin;
  String name;
  String phone;
  String twitter;
  String website;
  String whatsapp;
  String instagram;
  String userId;

  CardModel({
    required this.cardId,
    required this.createdDate,
    required this.delete,
    required this.designation,
    required this.email,
    required this.facebook,
    required this.linkedin,
    required this.name,
    required this.phone,
    required this.twitter,
    required this.website,
    required this.whatsapp,
    required this.instagram,
    required this.userId,
  });

  CardModel copyWith({
    String? cardId,
    DateTime? createdDate,
    bool? delete,
    String? designation,
    String? email,
    String? facebook,
    String? linkedin,
    String? name,
    String? phone,
    String? twitter,
    String? website,
    String? whatsapp,
    String? instagram,
    String? userId,
  }) =>
      CardModel(
        cardId: cardId ?? this.cardId,
        createdDate: createdDate ?? this.createdDate,
        delete: delete ?? this.delete,
        designation: designation ?? this.designation,
        email: email ?? this.email,
        facebook: facebook ?? this.facebook,
        linkedin: linkedin ?? this.linkedin,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        twitter: twitter ?? this.twitter,
        website: website ?? this.website,
        whatsapp: whatsapp ?? this.whatsapp,
        instagram: instagram ?? this.instagram,
        userId: userId ?? this.userId,
      );

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
    cardId: json["cardId"],
    createdDate: json["createdDate"].toDate(),
    delete: json["delete"],
    designation: json["designation"],
    email: json["email"],
    facebook: json["facebook"],
    linkedin: json["linkedin"],
    name: json["name"],
    phone: json["phone"],
    twitter: json["twitter"],
    website: json["website"],
    whatsapp: json["whatsapp"],
    instagram: json["instagram"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "cardId": cardId,
    "createdDate": createdDate,
    "delete": delete,
    "designation": designation,
    "email": email,
    "facebook": facebook,
    "linkedin": linkedin,
    "name": name,
    "phone": phone,
    "twitter": twitter,
    "website": website,
    "whatsapp": whatsapp,
    "instagram": instagram,
    "userId": userId,
  };
}
