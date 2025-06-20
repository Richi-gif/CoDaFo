import 'package:bloc/bloc.dart';
import 'package:praktikum_1/applications/beranda/bloc/beranda_event.dart';
import 'package:praktikum_1/applications/beranda/bloc/beranda_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:praktikum_1/applications/beranda/models/product.dart';

class BerandaBloc extends Bloc<BerandaEvent, BerandaState> {
  // Constructor untuk menginisialisasi BLoC dengan state awal
  BerandaBloc() : super(BerandaInitial()) {
    on<LoadBerandaData>(_onLoadBerandaData);  // Menambahkan event handler
  }

  // Event handler untuk menangani LoadBerandaData
  Future<void> _onLoadBerandaData(
      LoadBerandaData event, Emitter<BerandaState> emit) async {
    emit(BerandaLoading());  // Menampilkan loading saat data sedang dimuat
    try {
      String url = 'https://backend-e-commerce-rosy.vercel.app/products';
      if (event.query.isNotEmpty) {
        url += '?search=${event.query}';  // Menambahkan query pencarian ke URL
      }

      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');  // Log respons untuk debugging

      if (response.statusCode == 200) {
        // Mengonversi JSON ke Map<String, dynamic>
        Map<String, dynamic> jsonData = json.decode(response.body);

        // Cek apakah ada key 'products' dalam Map
        if (jsonData.containsKey('products')) {
          List<dynamic> data = jsonData['products']; // Ambil data dari field 'products'
          List<Product> products = data.map((productData) => Product.fromJson(productData)).toList();
          emit(BerandaSuccess(products: products));  // Menghasilkan state sukses dengan data produk
        } else {
          // Jika tidak ada key 'products', kita anggap data yang diterima langsung berupa List
          List<dynamic> data = json.decode(response.body);  // Ambil langsung jika berupa List
          List<Product> products = data.map((productData) => Product.fromJson(productData)).toList();
          emit(BerandaSuccess(products: products));  // Menghasilkan state sukses dengan data produk
        }
      } else {
        emit(BerandaFailure(error: 'Failed to load products with status code: ${response.statusCode}'));
      }
    } catch (e) {
      print('Error: $e');
      emit(BerandaFailure(error: 'Failed to load products: $e'));  // Menangani kesalahan lainnya
    }
  }
}
