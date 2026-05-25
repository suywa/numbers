import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'math_engine.dart';
import 'main.dart';

class GameScreen extends StatefulWidget {
  final int timeLimit;
  const GameScreen({super.key, required this.timeLimit});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  int questionCount = 1;
  late MathQuestion currentQuestion;
  Timer? timer;
  int timeLeft = 0;
  final TextEditingController _controller = TextEditingController();

  // New feedback state variables
  bool _hasAnswered = false;
  bool _isCorrectAnswer = false;

  @override
  void initState() {
    super.initState();
    currentQuestion = MathQuestion.generate();
    startTimer();
  }

  void startTimer() {
    if (widget.timeLimit == 0) return;
    timeLeft = widget.timeLimit;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {
          if (timeLeft > 0) {
            timeLeft--;
          } else {
            // Force evaluate as incorrect when timer hits 0
            _evaluateAnswer(false);
          }
        });
      }
    });
  }

  void _evaluateAnswer(bool wasCorrect) {
    timer?.cancel(); // Freeze the timer during visual feedback phase

    setState(() {
      _hasAnswered = true;
      _isCorrectAnswer = wasCorrect;
      if (wasCorrect) score++;
    });

    // Delays the transition for 1.5 seconds so the child can see the green/red highlight
    Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      if (questionCount < 10) {
        setState(() {
          questionCount++;
          currentQuestion = MathQuestion.generate();
          _controller.clear();
          _hasAnswered = false; // Reset feedback state for next loop
          startTimer();
        });
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: score,
          timeLimit: widget.timeLimit,
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // Dynamic helper to resolve Card background colors based on feedback state
  Color _getCardColor() {
    if (!_hasAnswered) return Colors.white; // Default resting state
    return _isCorrectAnswer ? Colors.greenAccent[100]! : Colors.redAccent[100]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                  Text("Question $questionCount of 10", style: const TextStyle(fontSize: 24)),
                  if (widget.timeLimit > 0 && !_hasAnswered)
                    Text("Time Left: $timeLeft", style: const TextStyle(color: Colors.red, fontSize: 32, fontWeight: FontWeight.bold)),
                  if (_hasAnswered)
                    Text(
                      _isCorrectAnswer ? "🌟 Correct! 🌟" : "❌ Oops! Try Next! ❌",
                      style: TextStyle(
                          color: _isCorrectAnswer ? Colors.green[700] : Colors.red[700],
                          fontSize: 28,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Animated container shifts colors smoothly when state fields change
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: _getCardColor(),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 40.0),
                      child: Text(
                        currentQuestion.text,
                        style: GoogleFonts.unkempt(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: _hasAnswered ? Colors.black87 : Colors.deepOrangeAccent
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                    child: TextField(
                      controller: _controller,
                      enabled: !_hasAnswered, // Locks text entry during feedback phase
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 30),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                        hintText: "?",
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: _hasAnswered
                        ? null // Disables button during feedback delay
                        : () {
                      if (_controller.text.isNotEmpty) {
                        _evaluateAnswer(int.tryParse(_controller.text) == currentQuestion.answer);
                      }
                    },
                    child: const Text("SUBMIT"),
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

// --- RESULTS SCREEN WIDGET ---
class ResultScreen extends StatelessWidget {
  final int score;
  final int timeLimit;

  const ResultScreen({super.key, required this.score, required this.timeLimit});

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
                  Text(
                    "Your Score",
                    style: GoogleFonts.unkempt(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  const SizedBox(height: 30),
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
                  ElevatedButton(
                    onPressed: () {
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