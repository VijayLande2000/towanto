// get_all_countries_response.dart
class GetAllCountriesResponse {
  List<GetAllCountrysModel> countries;

  GetAllCountriesResponse({required this.countries});

  factory GetAllCountriesResponse.fromJson(List<dynamic> json) {
    return GetAllCountriesResponse(
      countries: json.map((country) => GetAllCountrysModel.fromJson(country)).toList(),
    );
  }
}

// get_all_countrys_model.dart
class GetAllCountrysModel {
  final int id;
  final String name;

  GetAllCountrysModel({
    required this.id,
    required this.name,
  });

  factory GetAllCountrysModel.fromJson(Map<String, dynamic> json) {
    return GetAllCountrysModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}