import 'dart:async';
import 'package:flutter/material.dart';
import 'math_engine.dart';

class GameScreen extends StatefulWidget {
  final int timeLimit; // 0, 20, or 10 
  GameScreen({required this.timeLimit});

  @override
  _GameScreenState createState() => _GameScreenState();
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
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        if (timeLeft > 0) timeLeft--;
        else nextQuestion(false); // Time's up
      });
    });
  }

  void nextQuestion(bool wasCorrect) {
    if (wasCorrect) score++;
    if (questionCount < 10) { // Ten questions per game 
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
      builder: (ctx) => AlertDialog(
        title: Text("Game Over!"),
        content: Text("Your score is $score/10"),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Menu"))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Level ${widget.timeLimit == 0 ? '0' : widget.timeLimit == 20 ? '1' : '2'}")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Question $questionCount of 10"),
            if (widget.timeLimit > 0) Text("Time Left: $timeLeft", style: TextStyle(color: Colors.red, fontSize: 24)),
            Text(currentQuestion.text, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(controller: _controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Answer")),
            ),
            ElevatedButton(
              onPressed: () => nextQuestion(int.tryParse(_controller.text) == currentQuestion.answer),
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}