import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:praktikum_1/applications/beranda/bloc/beranda_bloc.dart';
import 'package:praktikum_1/applications/beranda/bloc/beranda_state.dart';
import 'package:praktikum_1/applications/beranda/bloc/beranda_event.dart';
import 'package:praktikum_1/applications/beranda/models/product.dart';
import 'package:praktikum_1/service/cart/helper/cart_helper.dart'; // <-- IMPORT TAMBAHAN
import 'package:praktikum_1/view/cart.dart';
import 'package:praktikum_1/view/settings.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  int _selectedIndex = 0;

  final CartHelper _cartHelper =
      CartHelper(); // <-- TAMBAHKAN INSTANSiasi CartHelper

  @override
  void initState() {
    super.initState();
    context.read<BerandaBloc>().add(LoadBerandaData(query: ''));
  }

  void onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
    context.read<BerandaBloc>().add(LoadBerandaData(query: query));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      _buildProductPage(), // Beranda Page
      Cart(),
      const Settings(), // Akun Saya Page
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
        backgroundColor: const Color(0xFF881FFF),
      ),
      body: _pages[_selectedIndex], // Display page based on selected index
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Keranjang'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun Saya'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF881FFF),
        onTap: _onItemTapped, // Handle navigation item tap
      ),
    );
  }

  // Function to build the product page with search and product list
  Widget _buildProductPage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: const InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<BerandaBloc, BerandaState>(
            builder: (context, state) {
              if (state is BerandaLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BerandaSuccess) {
                // Filter berdasarkan search
                List<Product> filtered = state.products.where((product) {
                  return product.name
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                      child: Text('Tidak ada produk ditemukan.'));
                }

                // Kelompokkan berdasarkan kategori
                final kategoriProduk = <String, List<Product>>{};
                for (var product in filtered) {
                  kategoriProduk.putIfAbsent(product.category, () => []);
                  kategoriProduk[product.category]!.add(product);
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: kategoriProduk.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...entry.value.map((product) {
                          return Column(
                            children: [
                              productItem(product),
                              const Divider(),
                            ],
                          );
                        }).toList(),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                );
              } else if (state is BerandaFailure) {
                return Center(child: Text(state.error));
              }
              return const Center(child: Text('No Data Available'));
            },
          ),
        ),
      ],
    );
  }

  // Widget for displaying product item
  Widget productItem(Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10.0),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            product.imageUrl.isNotEmpty
                ? product.imageUrl
                : 'https://example.com/default_image.png', // Gambar default jika URL kosong
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Rp ${product.price}',
          style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
        ),
        trailing: ElevatedButton(
          onPressed: () async {
            // Pastikan fungsi ini async
            try {
              // Cek apakah item sudah ada di keranjang
              final existingItem =
                  await _cartHelper.getCartItemByName(product.name);

              if (existingItem != null) {
                // Jika ada, update kuantitasnya
                int newQuantity = existingItem['quantity'] + 1;
                await _cartHelper.updateCartItem(
                    existingItem['id'], newQuantity);
              } else {
                // Jika tidak ada, insert sebagai item baru
                final cartItem = {
                  'name': product.name,
                  'price': product.price.toInt(),
                  'quantity': 1,
                };
                await _cartHelper.insertCartItem(cartItem);
              }

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('${product.name} ditambahkan ke keranjang')));
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menambahkan item: $e')));
            }
          },
          child: const Text('+'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size(30, 30),
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}
