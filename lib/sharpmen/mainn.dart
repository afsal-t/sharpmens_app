
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:sharpens/sharpmen/home.dart';
import 'package:sharpens/sharpmen/login.dart';
import 'package:sharpens/sharpmen/splash.dart';
import 'admin page product.dart';
import 'cart provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBjY4BRV0zQ4p0D8geAXXFJi8BKdaa3S6o",
      appId: "1:165245725212:android:03f0513952df4b07d08dd9",
      messagingSenderId: "",
      projectId: "mensapp-687b1",
      storageBucket: "mensapp-687b1.firebasestorage.app",
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()), // Add your provider here
        // Add other providers if needed
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    ),
  );
}
