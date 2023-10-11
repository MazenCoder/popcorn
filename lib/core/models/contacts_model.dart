import 'dart:convert';

ContactsModel contactsModelFromJson(String str) => ContactsModel.fromJson(json.decode(str));

String contactsModelToJson(ContactsModel data) => json.encode(data.toJson());

class ContactsModel {
  ContactsModel({
    required this.action,
    this.result = 'error',
    required this.userid,
    this.servertime,
    this.contacts,
  });

  String action;
  String result;
  int userid;
  DateTime? servertime;
  List<Contact>? contacts;

  factory ContactsModel.fromJson(Map<String, dynamic> json) => ContactsModel(
    action: json["action"],
    result: json["result"] ?? 'error',
    userid: json["userid"],
    servertime: json["servertime"] != null ? DateTime.parse(json["servertime"]) : null,
    contacts: json["contacts"] != null ? List<Contact>.from(json["contacts"].map((x) => Contact.fromJson(x))) : null,
  );

  Map<String, dynamic> toJson() => {
    "action": action,
    "result": result,
    "userid": userid,
    "servertime": servertime?.toIso8601String(),
    "contacts": contacts != null ? List<Contact>.from(contacts!.map((x) => x.toJson())) : null,
  };
}

class Contact {
  Contact({
    required this.userid,
    required this.username,
    required this.usercolor,
    required this.userimage,
    this.lastOnline,
    required this.currentstatus,
    required this.write,
  });

  int userid;
  String username;
  String usercolor;
  String userimage;
  DateTime? lastOnline;
  String currentstatus;
  String write;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    userid: json["userid"],
    username: json["username"],
    usercolor: json["usercolor"],
    userimage: json["userimage"],
    lastOnline: json["last_online"] != null ? DateTime.parse(json["last_online"]) : null,
    currentstatus: json["currentstatus"],
    write: json["write"],
  );

  Map<String, dynamic> toJsonModel() => {
    "userid": userid,
    "username": username,
    "usercolor": usercolor,
    "userimage": userimage,
    "last_online": lastOnline?.toIso8601String(),
    "currentstatus": currentstatus,
    "write": write,
  };

  toJson() {

  }
}
