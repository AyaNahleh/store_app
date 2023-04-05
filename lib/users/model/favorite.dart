class Favorite{
  int? favoriteId;
  int? userId;
  int? itemId;

  String? name;
  double? rating;
  List<String>? tags;
  double? price;
  List<String>? sizes;
  List<String>? colors;
  String? description;
  String? image;

  Favorite({
    this.favoriteId,
    this.userId,
    this.itemId,
    this.name,
    this.rating,
    this.tags,
    this.price,
    this.sizes,
    this.colors,
    this.description,
    this.image
  });
  factory Favorite.fromJson(Map<String,dynamic> json)=>Favorite(
    favoriteId: int.parse(json['favorite_id']),
    itemId: int.parse(json['item_id']),
    userId: int.parse(json['user_id']),
    name: json['name'],
    rating: double.parse(json['rating']),
    tags: json['tags'].toString().split(','),
    price:double.parse(json['price']),
    sizes: json['sizes'].toString().split(','),
    colors: json['colors'].toString().split(','),
    description: json['description'],
    image: json['image'],
  );
}