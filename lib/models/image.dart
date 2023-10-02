class Image {
  String name;
  String url;

  Image({
    required this.name,
    required this.url,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(name: json['name'], url: json['url']);
  }
}
