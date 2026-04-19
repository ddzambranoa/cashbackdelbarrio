import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/pg1.dart';
//import 'test_premios.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fbdcmlnqbsecgdqrousv.supabase.co',
    anonKey: 'sb_publishable_5V9LBAwMziC5vHZhCllm6w_Lz6eFv2N',
  );

  runApp(const DeUnaCloneApp());
}

class DeUnaCloneApp extends StatelessWidget {
  const DeUnaCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'deuna negocios',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFEFE7F4),
      ),
  home: const Pg1(),    );
  }
}