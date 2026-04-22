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
            nextQuestion(false);
          }
        });
      }
    });
  }

  void nextQuestion(bool wasCorrect) {
    if (wasCorrect) {
      score++;
    }

    if (questionCount < 10) {
      setState(() {
        questionCount++;
        currentQuestion = MathQuestion.generate();
        _controller.clear();
        startTimer();
      });
    } else {
      timer?.cancel();
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Game Over!", style: GoogleFonts.unkempt(fontSize: 28)),
          content: Text("Final Score: $score/10", style: GoogleFonts.unkempt(fontSize: 22)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MainMenu()),
                      (Route<dynamic> route) => false,
                );
              },
              child: Text("Return to Menu", style: GoogleFonts.unkempt(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
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
                  Text(
                    "Question $questionCount of 10",
                    style: GoogleFonts.unkempt(fontSize: 24, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 10),

                  if (widget.timeLimit > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        // FIXED: Using withValues for modern Flutter versions
                        color: Colors.redAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Time Left: $timeLeft",
                        style: GoogleFonts.unkempt(
                            color: Colors.red,
                            fontSize: 28,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),

                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Text(
                        currentQuestion.text,
                        style: GoogleFonts.unkempt(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
                    child: TextField(
                      controller: _controller,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.unkempt(fontSize: 36),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "?",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        nextQuestion(int.tryParse(_controller.text) == currentQuestion.answer);
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