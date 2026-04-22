import 'dart:math';

class MathQuestion {
  final String text;
  final int answer;

  MathQuestion({required this.text, required this.answer});

  factory MathQuestion.generate() {
    final rand = Random();
    int a = rand.nextInt(12) + 1; // Numbers 1 to 12 
    int b = rand.nextInt(12) + 1;
    
    // Choose operator: 0=+, 1=-, 2=*, 3=/
    int op = rand.nextInt(4);
    
    if (op == 0) return MathQuestion(text: "$a + $b", answer: a + b);
    if (op == 1) {
      // Prevent negative answers by putting the larger number first 
      return MathQuestion(text: "${max(a, b)} - ${min(a, b)}", answer: (a - b).abs());
    }
    if (op == 2) return MathQuestion(text: "$a × $b", answer: a * b);
    
    // For division, multiply first to ensure a whole number result 
    int product = a * b;
    return MathQuestion(text: "$product ÷ $b", answer: a);
  }
}