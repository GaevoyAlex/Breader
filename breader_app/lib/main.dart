import 'package:breader_app/features/library/home/presentation/home_navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/library/home/provider/home_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create:(context) => HomeProvider()),
      ],
    child: MaterialApp(
        home: HomePresentation(),
        
      ),
    );
  }
}