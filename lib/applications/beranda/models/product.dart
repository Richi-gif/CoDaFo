class Product {
  final String name;        // Nama produk
  final String description; // Deskripsi produk
  final double price;       // Harga produk
  final int stock;          // Stok produk
  final String imageUrl;    // URL gambar produk
  final String category;    // Kategori produk

  // Constructor untuk membuat objek Product
  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.category,
  });

  // Method untuk mengonversi JSON ke objek Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',             // Mengambil nilai 'name' dari JSON, jika kosong set ''
      description: json['description'] ?? '', // Mengambil nilai 'description', jika kosong set ''
      price: json['price']?.toDouble() ?? 0.0,  // Mengambil nilai 'price' dan memastikan menjadi double
      stock: json['stock'] ?? 0,            // Mengambil nilai 'stock' dari JSON
      imageUrl: json['imageUrl'] ?? '',    // Mengambil nilai 'imageUrl' dari JSON
      category: json['category'] ?? '',    // Mengambil nilai 'category' dari JSON
    );
  }
}
