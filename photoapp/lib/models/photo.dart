class Photo {
  Photo({
    this.id,
    required this.imageUrl,
    required this.imagePath,
    required this.isFavorite,
    this.createdAt,
  });

  final String? id;
  final String imageUrl;
  final String imagePath;
  final bool isFavorite;
  final DateTime? createdAt;

  Photo toggleIsFavorite() {
    return Photo(
      id: id,
      imageUrl: imageUrl,
      imagePath: imagePath,
      isFavorite: !isFavorite,
      createdAt: createdAt,
    );
  }
}
