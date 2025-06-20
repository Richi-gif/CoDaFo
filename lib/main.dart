import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:praktikum_1/applications/beranda/bloc/beranda_bloc.dart';
import 'package:praktikum_1/applications/login/bloc/login_bloc.dart';
import 'package:praktikum_1/applications/login/view/login.dart';
import 'package:praktikum_1/applications/register/bloc/register_bloc.dart';
import 'package:praktikum_1/view/home.dart';
import 'package:praktikum_1/view/cart.dart';
import 'package:praktikum_1/view/settings.dart'; // Import halaman Akun Saya
import 'package:praktikum_1/applications/beranda/view/beranda.dart'; // Import Beranda

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await DatabaseHelper
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(),
        ),
        BlocProvider<BerandaBloc>( // Menambahkan provider untuk BerandaBloc
          create: (context) => BerandaBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/', // ⬅️ Menetapkan route awal
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const Beranda(),
        '/cart': (context) => const Cart(), // ✅ Tambahkan ini 
        '/profile': (context) => const Settings(), // ✅ Tambahkan ini
      },
    );
  }
}
