class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageURL;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageURL,
    this.isFavorite = false,
  });

  /// Altera o valor de Favorito do Produto
  void toggleFavorite() => isFavorite = !isFavorite;
}
