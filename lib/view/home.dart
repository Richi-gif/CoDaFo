import 'package:flutter/material.dart';
import 'package:praktikum_1/view/cart.dart';
import 'package:praktikum_1/view/settings.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String _searchQuery = '';

  final Map<String, List<String>> productCategories = {
    'Drink': ['Es Teh Manis', 'Jus Jeruk', 'Air Mineral'],
    'Ngemil': ['Udang Keju', 'Lumpia Udang', 'Siomay Ayam'],
    'Paketan': ['Paket A', 'Paket B', 'Paket C'],
  };

  // Tambahkan daftar halaman agar bisa ditampilkan sesuai index
  final List<Widget> _pages = [
    const HomeContent(),  // konten produk
    const Cart(),         // halaman keranjang
    const Settings(),     // halaman akun saya
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My App')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Keranjang'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun Saya'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 0, 0),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

// Pisahkan konten utama beranda jadi widget terpisah
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _searchQuery = '';

  final Map<String, List<String>> productCategories = {
    'Drink': ['Es Teh Manis', 'Jus Jeruk', 'Air Mineral'],
    'Ngemil': ['Udang Keju', 'Lumpia Udang', 'Siomay Ayam'],
    'Paketan': ['Paket A', 'Paket B', 'Paket C'],
  };

  @override
  Widget build(BuildContext context) {
    List<String> allProducts = productCategories.values.expand((x) => x).toList();
    List<String> filteredProducts = _searchQuery.isEmpty
        ? []
        : allProducts
            .where((product) => product.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 16),

          if (_searchQuery.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Search Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (filteredProducts.isEmpty)
                  const Text('No products found.')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$product ditekan')));
                            },
                            child: productItem(product),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                const SizedBox(height: 16),
              ],
            ),

          if (_searchQuery.isEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...productCategories.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.key, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      ...entry.value.map((product) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$product ditekan')));
                              },
                              child: productItem(product),
                            ),
                            const Divider(),
                          ],
                        );
                      }).toList(),
                      const SizedBox(height: 12),
                    ],
                  );
                }).toList(),
              ],
            ),
        ],
      ),
    );
  }

  Widget productItem(String product) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/$product.jpg',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey,
                  child: const Icon(Icons.error, color: Colors.red),
                );
              },
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Rp 9.000', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$product ditambahkan ke keranjang')));
            },
            child: const Text('+'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(30, 30),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
