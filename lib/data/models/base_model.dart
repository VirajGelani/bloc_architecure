class BaseModel<T> {
  bool status;
  String message;
  T? data;

  BaseModel({required this.status, required this.message, this.data});

  factory BaseModel.fromJson(
    Map<String, dynamic> json,
    String id,
    Function(Map<String, dynamic>, String) create,
  ) => BaseModel(
    status: json["status"],
    data: (json["data"] != null)
        ? (json["data"] is List)
              ? List<T>.from(json["data"].map((x) => create(x, id)))
              : (json["data"] is Map<String, dynamic>)
              ? create(json["data"], id)
              : json["data"]
        : null,
    message: json["message"] ?? "",
  );
}

class BaseModelList<T> {
  final bool status;
  final String message;
  final List<T>? data;

  BaseModelList({required this.status, required this.message, this.data});

  factory BaseModelList.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) create,
  ) {
    final rawData = json["data"];
    List<T>? items;

    if (rawData != null && rawData is List) {
      items = rawData.map<T>((x) => create(x)).toList();
    }

    return BaseModelList<T>(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: items,
    );
  }
}
