import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Parse JSON string to MemberModel
MemberModel memberModelFromJson(String str) => MemberModel.fromJson(json.decode(str));

/// Convert MemberModel to JSON string
String memberModelToJson(MemberModel data) => json.encode(data.toJson());

class MemberModel {
  final String memberName;
  final String memberId;
  final DateTime date;
  final String phone;
  final String whatsapp;
  final String facebook;
  final String email;
  final String twitter;
  final String linkedin;
  final String instagram;
  final String website;
  final bool delete;

  MemberModel({
    required this.memberName,
    required this.memberId,
    required this.date,
    required this.phone,
    required this.delete,
    required this.website,
    required this.instagram,
    required this.whatsapp,
    required this.facebook,
    required this.twitter,
    required this.linkedin,
    required this.email,
  });

  /// Create a copy with updated fields
  MemberModel copyWith({
    String? memberName,
    String? memberId,
    DateTime? date,
    String? phone,
    bool? delete,
    String? whatsapp,
    String? facebook,
    String? email,
    String? twitter,
    String? linkedin,
    String? instagram,
    String? website,
  }) =>
      MemberModel(
        memberName: memberName ?? this.memberName,
        memberId: memberId ?? this.memberId,
        date: date ?? this.date,
        phone: phone ?? this.phone,
        delete: delete ?? this.delete,
        instagram: instagram ?? this.instagram,
        whatsapp: whatsapp ?? this.whatsapp,
        website: website ?? this.website,
        linkedin: linkedin ?? this.linkedin,
        twitter: twitter ?? this.twitter,
        facebook: facebook ?? this.facebook,
        email: email ?? this.email,
      );

  /// Create MemberModel from JSON map
  factory MemberModel.fromJson(Map<String, dynamic> json) => MemberModel(
    memberName: json["memberName"] ?? "Unknown",
    memberId: json["memberId"] ?? "",
    date: (json["date"] as Timestamp).toDate(),
    phone: json["phone"] ?? "",
    delete: json["delete"] ?? false,
    email: json["email"] ?? "",
    facebook: json["facebook"] ?? "",
    twitter: json["twitter"] ?? "",
    linkedin: json["linkedin"] ?? "",
    website: json["website"] ?? "",
    whatsapp: json["whatsapp"] ?? "",
    instagram: json["instagram"] ?? "",
  );

  /// Convert MemberModel to JSON map
  Map<String, dynamic> toJson() => {
    "memberName": memberName,
    "memberId": memberId,
    "date": date,
    "phone": phone,
    "delete": delete,
    "email": email,
    "facebook": facebook,
    "twitter": twitter,
    "linkedin": linkedin,
    "website": website,
    "whatsapp": whatsapp,
    "instagram": instagram,
  };
}
