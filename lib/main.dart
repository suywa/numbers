import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'game_screen.dart';

void main() {
  // Fixes the "Binding has not yet been initialized" error from font-loading
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'numbers',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        // Applies the child-friendly font globally across the UI application text
        textTheme: GoogleFonts.unkemptTextTheme(),
      ),
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Matching soft background gradient layout to establish visual consistency
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlueAccent, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Centered, prominent playful app title text
                  Text(
                    "numbers",
                    style: GoogleFonts.unkempt(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black.withValues(alpha: 0.15),
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Choose Your Math Adventure!",
                    style: GoogleFonts.unkempt(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey[700],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Child-friendly buttons with discrete theme colors and descriptions
                  _levelButton(
                    context: context,
                    title: "🟢 Warm Up!",
                    description: "Take your time! No timers here, just fun math practice.",
                    limit: 0,
                    btnColor: Colors.greenAccent[700]!,
                  ),
                  _levelButton(
                    context: context,
                    title: "🟡 Dynamic Run!",
                    description: "A friendly countdown! You have 20 seconds per question.",
                    limit: 20,
                    btnColor: Colors.amber[600]!,
                  ),
                  _levelButton(
                    context: context,
                    title: "🔴 Speed Challenge!",
                    description: "Super fast! Race against a quick 10-second timer.",
                    limit: 10,
                    btnColor: Colors.redAccent[400]!,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Adjusted button builder widget handling child subtitle elements vertically
  Widget _levelButton({
    required BuildContext context,
    required String title,
    required String description,
    required int limit,
    required Color btnColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 40.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GameScreen(timeLimit: limit)),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(300, 60),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25), // Rounded corners for children
              ),
              textStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text(title),
          ),
          const SizedBox(height: 6),
          // Subtitle description placed carefully underneath the button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.unkempt(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}