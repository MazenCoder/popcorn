import 'dart:convert';

class AddressModel {
  AddressModel({
    required this.id,
    this.company,
    required this.address1,
    this.address2,
    required this.city,
    this.province,
    required this.country,
    required this.zip,
    this.addressDefault = false,
    this.timestamp,
  });

  String id;
  String? company;
  String address1;
  String? address2;
  String city;
  String? province;
  String country;
  String zip;
  bool addressDefault;
  dynamic timestamp;

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    id: json["id"],
    company: json["company"],
    address1: json["address1"],
    address2: json["address2"],
    city: json["city"],
    province: json["province"],
    country: json["country"],
    zip: json["zip"],
    addressDefault: json["default"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company": company,
    "address1": address1,
    "address2": address2,
    "city": city,
    "province": province,
    "country": country,
    "zip": zip,
    "default": addressDefault,
    "timestamp": timestamp,
  };

  Map<String, dynamic> toUpdateJson() => {
    "company": company,
    "address1": address1,
    "address2": address2,
    "city": city,
    "province": province,
    "country": country,
    "zip": zip,
    "default": addressDefault,
  };
}
