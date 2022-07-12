class News {
  late final int? id;
  late final String? author;
  late final String? title;
  late final String? url;
  late final String? urlToImage;
  late final String? publishedAt;

  News({
    this.id,
    this.author,
    this.title,
    this.url,
    this.urlToImage,
    this.publishedAt,
  });

  // News({this.id, this.name, this.currency});

  factory News.fromJson(Map<String, dynamic> parsedJson) {
    return News(
      id: int.parse(parsedJson['id']),
      author: parsedJson['author'].toString(),
      title: parsedJson['title'].toString(),
      url: parsedJson['url'].toString(),
      urlToImage: parsedJson['urlToImage'].toString(),
      publishedAt: parsedJson['publishedAt'].toString(),
    );
  }

  Map toJson() => {
        'id': id,
        'author': author,
        'title': title,
        'url': url,
        'urlToImage': urlToImage,
        'publishedAt': publishedAt,
      };
}
