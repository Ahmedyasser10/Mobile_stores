import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_ass/providers/store_provider.dart';
import 'package:mobile_ass/Screens/Welcome/welcome_screen.dart';
import 'package:mobile_ass/Screens/Home/home_screen.dart';
import 'package:mobile_ass/Screens/Signup/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://liphpparbpvezjqqjthi.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxpcGhwcGFyYnB2ZXpqcXFqdGhpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIyOTQyNDksImV4cCI6MjA1Nzg3MDI0OX0.aF639wBcHPkr1MSYSM_jUEsNqpXAvAPXO0lMXCelfPk',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => StoreProvider(),
          lazy: false,
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
      debugShowCheckedModeBanner: false,
      title: 'Egypt Stores',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}