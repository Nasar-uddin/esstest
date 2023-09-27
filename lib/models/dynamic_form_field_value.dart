class DynamicFormFieldValue {
  dynamic value;
  String? type;
  String? label;

  DynamicFormFieldValue({this.value, this.type, this.label});

  DynamicFormFieldValue.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    type = json['type'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['value'] = value;
    data['type'] = type;
    data['label'] = label;
    return data;
  }
}
