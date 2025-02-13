class GetAllStatesResponse {
  final List<GetAllStatesModel> states;

  GetAllStatesResponse({required this.states});

  factory GetAllStatesResponse.fromJson(List<dynamic> json) {
    return GetAllStatesResponse(
      states: json.map((state) => GetAllStatesModel.fromJson(state as Map<String, dynamic>)).toList(),
    );
  }
}

// get_all_states_model.dart
class GetAllStatesModel {
  final int id;
  final String name;

  GetAllStatesModel({
    required this.id,
    required this.name,
  });

  factory GetAllStatesModel.fromJson(Map<String, dynamic> json) {
    return GetAllStatesModel(
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
