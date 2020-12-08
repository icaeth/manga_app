import 'dart:convert';

class Manga {
  String title;
  String imageUrl;
  Manga({
    this.title,
    this.imageUrl,
  });

  String get fullImageUrl => '$imageUrl';

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image_url': imageUrl,
    };
  }

  factory Manga.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Manga(
      title: map['title'],
      imageUrl: map['image_url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Manga.fromJson(String source) => Manga.fromMap(json.decode(source));
}
