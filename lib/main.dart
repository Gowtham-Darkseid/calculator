import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = "";
  String result = "0";
  bool isScientificMode = false;

  void onButtonClick(String value) {
    setState(() {
      if (value == "C") {
        expression = "";
        result = "0";
      } else if (value == "⌫") {
        if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1);
        }
      } else if (value == "√") {
        if (expression.isNotEmpty) {
          try {
            double num = double.parse(expression);
            result = (num >= 0) ? sqrt(num).toString() : "Error";
          } catch (e) {
            result = "Error";
          }
        }
      } else if (value == "=") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          result = exp.evaluate(EvaluationType.REAL, cm).toString();
        } catch (e) {
          result = "Error";
        }
      } else if (value == "SCI") {
        isScientificMode = !isScientificMode;
      } else {
        expression += value;
      }
    });
  }

  double getFontSize() {
    if (expression.length > 10) {
      return 40; // Smallest font size
    } else if (expression.length > 6) {
      return 70; // Medium font size
    } else {
      return 112; // Default font size
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CALC")),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Display screen
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.bottomRight,
            decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  expression,
                  style: TextStyle(
                    fontSize: getFontSize(),
                    color: Colors.white54,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 10),
                Text(
                  result,
                  style: const TextStyle(fontSize: 48, color: Colors.white),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white24),

          // Curved number pad container
          Container(
            decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(50),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                buildButtonRow(["C", "√", ".", "⌫"]),
                const SizedBox(height: 5),
                buildButtonRow(["7", "8", "9", "/"]),
                buildButtonRow(["4", "5", "6", "*"]),
                buildButtonRow(["1", "2", "3", "-"]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton("0"),
                    buildButton("+"),
                    buildMediumButton("="), // Wider '=' button
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) => buildButton(button)).toList(),
    );
  }

  Widget buildButton(String text) {
    return Container(
      margin: const EdgeInsets.all(9),
      child: ElevatedButton(
        onPressed: () => onButtonClick(text),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 30),
          backgroundColor: Colors.grey[850],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 27,
            color: text == "=" || text == "C" || text == "⌫" ? Colors.redAccent : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildMediumButton(String text) {
    return Container(
      margin: const EdgeInsets.all(9),
      width: 175, // Adjusted width for '=' button
      child: ElevatedButton(
        onPressed: () => onButtonClick(text),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 22),
          backgroundColor: Colors.redAccent,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
