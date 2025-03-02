import 'package:math_expressions/math_expressions.dart';

String _calculate() {
  try {
    // Parsing the input expression
    final expression = _input;
    final exp = Expression.parse(expression);

    // Evaluating the expression
    final evaluator = ExpressionEvaluator();
    final result = evaluator.eval(exp, {});

    // Converting the result to string and return
    return result.toString();
  } catch (e) {
    return "Error"; // In case of an invalid expression
  }
}
