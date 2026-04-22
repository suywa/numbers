import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  // Fixes the "Binding has not yet been initialized" error
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Math Skills App',
    theme: ThemeData(
      primarySwatch: Colors.orange,
      // Applies the playful font for young children (M3/D3 requirement)
      textTheme: GoogleFonts.unkemptTextTheme(),
    ),
    home: const MainMenu(), // Ensure MainMenu is called with const if it has a const constructor
  ));
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key}); // Added const constructor to fix linting errors

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Numbers Game")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Select a Level", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            _levelButton(context, "Level 0 (No Limit)", 0),
            _levelButton(context, "Level 1 (20 Seconds)", 20),
            _levelButton(context, "Level 2 (10 Seconds)", 10),
          ],
        ),
      ),
    );
  }

  Widget _levelButton(BuildContext context, String title, int limit) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => GameScreen(timeLimit: limit))
        ),
        child: Text(title),
      ),
    );
  }
}