import 'package:flutter/material.dart';
import 'package:praktikum_1/service/cart/helper/cart_helper.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Map<String, dynamic>> cartItems = [];
  final CartHelper _cartHelper = CartHelper();

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final items = await _cartHelper.getCartItems();
    setState(() {
      cartItems = items.map((item) {
        return {
          'id': item['id'],
          'name': item['name'],
          'quantity': item['quantity'] is int
              ? item['quantity']
              : (item['quantity'] as num).toInt(),
          'price': item['price'] is int
              ? item['price']
              : (item['price'] as num).toInt(),
        };
      }).toList();
    });
  }

  Future<void> _removeItem(int id) async {
    await _cartHelper.deleteCartItem(id);
    _loadCartItems();
  }

  Future<void> _updateQuantity(int id, int newQuantity) async {
    if (newQuantity > 0) {
      await _cartHelper.updateCartItem(id, newQuantity);
      _loadCartItems();
    } else {
      _removeItem(id);
    }
  }

  Future<void> _showAddItemDialog() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tambah Produk ke Keranjang"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nama Produk"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: "Jumlah"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: "Harga"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    quantityController.text.isNotEmpty &&
                    priceController.text.isNotEmpty) {
                  String name = nameController.text;
                  int quantity = int.tryParse(quantityController.text) ?? 1;
                  int price = int.tryParse(priceController.text) ?? 0;

                  Map<String, dynamic> newItem = {
                    'id': DateTime.now().millisecondsSinceEpoch,
                    'name': name,
                    'quantity': quantity,
                    'price': price,
                  };

                  await _cartHelper.insertCartItem(newItem);
                  _loadCartItems();
                  Navigator.pop(context);
                }
              },
              child: const Text("Tambah"),
            ),
          ],
        );
      },
    );
  }

  int _calculateTotal() {
    return cartItems.fold<int>(0, (sum, item) {
      final quantity = item['quantity'] as int;
      final price = item['price'] as int;
      return sum + (quantity * price);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Keranjang"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? const Center(
                    child: Text("Keranjang Kosong",
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                  )
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.pink[100],
                            child: Text('${item['quantity']}'),
                          ),
                          title: Text(item['name']),
                          subtitle: Text('Rp ${item['price']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline,
                                    color: Colors.grey),
                                onPressed: () {
                                  _updateQuantity(
                                      item['id'], item['quantity'] - 1);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline,
                                    color: Colors.grey),
                                onPressed: () {
                                  _updateQuantity(
                                      item['id'], item['quantity'] + 1);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _removeItem(item['id']);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total: Rp ${_calculateTotal()}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Fitur Checkout akan segera hadir!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Checkout', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
