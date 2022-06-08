import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanctum_flutter_app_03/home_screen.dart';
import 'package:sanctum_flutter_app_03/service/auth.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      home: HomeScreen(),
    );
  }
}
