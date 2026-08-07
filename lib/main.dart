import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/demo_product_repository.dart';
import 'providers/cart_provider.dart';
import 'providers/catalog_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()..init()),
        ChangeNotifierProvider(
          create: (_) => CatalogProvider(DemoProductRepository())..load(),
        ),
      ],
      child: const ModaPraiaApp(),
    ),
  );
}
