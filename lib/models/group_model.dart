// To parse this JSON data, do
//
//     final groupModel = groupModelFromJson(jsonString);

import 'dart:convert';

GroupModel groupModelFromJson(String str) => GroupModel.fromJson(json.decode(str));

String groupModelToJson(GroupModel data) => json.encode(data.toJson());

class GroupModel {
  String groupName;
  String userId;
  String groupId;
  DateTime date;
  String color;
  String image;
  bool delete;
  int membersCount;

  GroupModel({
    required this.groupName,
    required this.groupId,
    required this.userId,
    required this.date,
    required this.color,
    required this.image,
    required this.delete,
    required this.membersCount,
  });

  GroupModel copyWith({
    required String groupName,
    required String groupId,
    required String userId,
    required DateTime date,
    required String color,
    required String image,
    required bool delete,
    required int membersCount,
  }) =>
      GroupModel(
        groupName: groupName ?? this.groupName,
        groupId: groupId ?? this.groupId,
        userId: userId ?? this.userId,
        date: date ?? this.date,
        color: color ?? this.color,
        image: image ?? this.image,
        delete: delete ?? this.delete,
        membersCount: membersCount ?? this.membersCount,
      );

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    groupName: json["groupName"],
    groupId: json["groupId"],
    userId: json["userId"],
    date: json["date"].toDate(),
    color: json["color"],
    image: json["image"],
    delete: json["delete"],
    membersCount: json["membersCount"],
  );

  Map<String, dynamic> toJson() => {
    "groupName": groupName,
    "groupId": groupId,
    "userId": userId,
    "date": date,
    "color": color,
    "image": image.toString(),
    "delete": delete,
    "membersCount": membersCount,
  };
}
