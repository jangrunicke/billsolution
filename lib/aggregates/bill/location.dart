import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

/// ValueObject Location des Aggregates Bill im Sinne von DDD

@JsonSerializable(explicitToJson: true)
class Location {
  String street;
  String city;
  String zip;
  String country;

  Location({this.street, this.city, this.zip, this.country});

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
