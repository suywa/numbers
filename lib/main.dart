import 'package:flutter/material.dart';
import 'game_screen.dart';

void main() => runApp(MaterialApp(home: MainMenu(), theme: ThemeData(primarySwatch: Colors.blue)));

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("numbers")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Select a Level", style: TextStyle(fontSize: 24)),
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
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => GameScreen(timeLimit: limit))),
        child: Text(title),
      ),
    );
  }
}