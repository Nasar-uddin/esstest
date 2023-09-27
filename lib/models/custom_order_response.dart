class CustomOrderResponse {
  String? formName;
  List<Sections>? sections;
  List<ValueMapping>? valueMapping;

  CustomOrderResponse({this.formName, this.sections, this.valueMapping});

  CustomOrderResponse.fromJson(Map<String, dynamic> json) {
    formName = json['formName'];
    if (json['sections'] != null) {
      sections = <Sections>[];
      json['sections'].forEach((v) {
        sections!.add(Sections.fromJson(v));
      });
    }
    if (json['valueMapping'] != null) {
      valueMapping = <ValueMapping>[];
      json['valueMapping'].forEach((v) {
        valueMapping!.add(ValueMapping.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['formName'] = formName;
    if (sections != null) {
      data['sections'] = sections!.map((v) => v.toJson()).toList();
    }
    if (valueMapping != null) {
      data['valueMapping'] = valueMapping!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sections {
  String? name;
  String? key;
  List<Fields>? fields;

  Sections({this.name, this.key, this.fields});

  Sections.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    key = json['key'];
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields!.add(Fields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['key'] = key;
    if (fields != null) {
      data['fields'] = fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ValueMapping {
  List? searchList;
  List? displayList;

  ValueMapping({this.searchList, this.displayList});

  ValueMapping.fromJson(Map<String, dynamic> json) {
    searchList = json['searchList'];

    displayList = json['displayList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (searchList != null) {
      data['searchList'] = searchList;
    }
    if (displayList != null) {
      data['displayList'] = displayList;
    }
    return data;
  }
}

class Fields {
  int? id;
  String? key;
  Map<String, dynamic>? properties;

  Fields({this.id, this.key, this.properties});

  Fields.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    properties = json['properties'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['key'] = key;
    data['properties'] = properties;
    return data;
  }
}
