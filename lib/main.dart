
import 'package:flutter/material.dart';
import 'injection_container.dart';
import 'presentation/fridge_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies() //tu them vo;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cooking Time',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const FridgePage(),
    );
  }
}
