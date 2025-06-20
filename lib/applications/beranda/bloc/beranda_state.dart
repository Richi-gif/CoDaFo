import 'package:equatable/equatable.dart';
import 'package:praktikum_1/applications/beranda/models/product.dart';

// Abstract class untuk state Beranda
abstract class BerandaState extends Equatable {
  @override
  List<Object?> get props => [];
}

// State awal ketika Beranda belum dimuat
class BerandaInitial extends BerandaState {}

// State ketika data sedang dimuat (loading)
class BerandaLoading extends BerandaState {}

// State ketika data berhasil dimuat dari API
class BerandaSuccess extends BerandaState {
  final List<Product> products;

  BerandaSuccess({required this.products});

  @override
  List<Object?> get props => [products];
}

// State ketika terjadi kegagalan saat memuat data
class BerandaFailure extends BerandaState {
  final String error;

  BerandaFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
