import 'dart:convert';


List<PopularPlaces> popularPlacesFromString(data){
 
 return List<PopularPlaces>.from(jsonDecode(data).map((item) => PopularPlaces.fromJson(item)))  ;
}

String popularPlacesListToJson(List<PopularPlaces> data){
return jsonEncode(List.from(data.map((e) => e.toJson())) );
}

class PopularPlaces {
  String? name;
  String? image;
  String? desc;
  String? rating;
  String? category;
  List<Services>? services;

  PopularPlaces({this.name, this.image, this.desc, this.rating, this.services,this.category});

  PopularPlaces.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    category=json['category'];
    desc = json['desc'];
    rating = json['rating'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services?.add(Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    data['desc'] = desc;
    data['rating'] = rating;
    if (services != null) {
      data['services'] = services?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  String? label;
  String? image;

  Services({this.label, this.image});

  Services.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['label'] = label;
    data['image'] = image;
    return data;
  }
}
