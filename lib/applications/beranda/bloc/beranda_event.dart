import 'package:equatable/equatable.dart';

// Abstract class untuk event Beranda
abstract class BerandaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Event untuk memuat data produk dengan query pencarian
class LoadBerandaData extends BerandaEvent {
  final String query;

  LoadBerandaData({required this.query});

  @override
  List<Object?> get props => [query];
}
