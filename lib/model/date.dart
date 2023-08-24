class DataModel {
  DataModel({
    this.text,
  });

  late final String? text;

  DataModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}
