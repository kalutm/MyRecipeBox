import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // NEW: Add this package!

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant_menu, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              'MyRecipeBox',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            const SpinKitFadingCircle(color: Colors.white, size: 50.0),
          ],
        ),
      ),
    );
  }
}
