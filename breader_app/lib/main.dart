import 'package:breader_app/features/library/home/presentation/home_navbar.dart';
import 'package:breader_app/features/library/home/presentation/screens/library/utils/library_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'features/library/home/presentation/model/book_model.dart';
import 'features/library/home/provider/home_provider.dart';

void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BookModelAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {



    return MultiProvider(providers: [
      ChangeNotifierProvider(create:(context) => HomeProvider()),
      ChangeNotifierProvider(create:(context) => LibraryProvider())
      ],
    child: MaterialApp(
        home: HomePresentation(),
        
      ),
    );
  }
}