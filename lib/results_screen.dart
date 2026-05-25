import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'game_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int timeLimit;

  const ResultScreen({super.key, required this.score, required this.timeLimit});

  // Dynamic compliments algorithm optimized for a child audience
  String _getCompliment(int finalScore) {
    if (finalScore == 10) return "🌟 Perfect Score! You're a Math Superstar! 🌟";
    if (finalScore >= 8) return "🎉 Amazing Job! Brilliant Thinking! 🎉";
    if (finalScore >= 5) return "👍 Great Effort! Keep Practicing! 👍";
    return "🚀 Good Try! Try Again to Smash Your Score! 🚀";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Blends seamlessly with your established game background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlueAccent, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title at the middle top
                  Text(
                    "Your Score",
                    style: GoogleFonts.unkempt(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Score box modeled after the question card UI
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                      child: Text(
                        "$score / 10",
                        style: GoogleFonts.unkempt(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Dynamic child compliment display
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      _getCompliment(score),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.unkempt(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Vertically stacked navigation controls
                  ElevatedButton(
                    onPressed: () {
                      // Restart the game with the same level settings
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => GameScreen(timeLimit: timeLimit),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      minimumSize: const Size(220, 55),
                    ),
                    child: const Text("PLAY AGAIN"),
                  ),
                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: () {
                      // Cleanly pop back out to the main landing menu
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const MainMenu()),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size(220, 55),
                    ),
                    child: const Text("MAIN MENU"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}