class ApiResponseModel {
    final String name;
    final String value;
    final String label;
    final String placeholder;
    final String tooltip;

    ApiResponseModel({
        required this.name,
        required this.value,
        required this.label,
        required this.placeholder,
        required this.tooltip,
    });

    factory ApiResponseModel.fromJson(Map<String, dynamic> json) => ApiResponseModel(
        name: json["name"],
        value: json["value"],
        label: json["label"],
        placeholder: json["placeholder"],
        tooltip: json["tooltip"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
        "label": label,
        "placeholder": placeholder,
        "tooltip": tooltip,
    };
}
