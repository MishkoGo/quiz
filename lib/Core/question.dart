import 'package:quiz/Core/answer.dart';

class Question {
  final String id;
  final String title;
  final List<Answer> answers;
  final int point;

  Question({
    required this.id,
    required this.title,
    required this.answers,
    required this.point,
  });
}