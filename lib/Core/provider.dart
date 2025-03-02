import 'package:flutter/material.dart';
import 'package:quiz/Core/answer.dart';
import 'package:quiz/Core/question.dart';
import 'package:quiz/Core/response.dart';

class QuizProvider extends ChangeNotifier {
  final String quizeId;
  final String puid;

  int _score = 0;
  int get score => _score;
  Question? _currentQuestion;
  Question? get currentQuestion => _currentQuestion;

  String? _next;
  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;
  bool _isCorrect = false;
  bool get isCorrect => _isCorrect;
  String? _selectedAnswerId;
  String? get selectedAnswerId => _selectedAnswerId;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _quizEnded = false;
  bool get quizEnded => _quizEnded;

  int _currentStep = 0;
  int get currentStep => _currentStep;

  QuizProvider({required this.quizeId, required this.puid}) {
    loadNextQuestion();
  }

  void resetQuiz() {
    _score = 0;
    _currentStep = 0;
    _isAnswered = false;
    _isCorrect = false;
    _isLoading = false;
    _quizEnded = false;
    _selectedAnswerId = '';

    notifyListeners();
  }

  Future<void> loadNextQuestion() async {
    if (_isAnswered && _currentQuestion != null) {
      _currentStep++;
    }

    _isLoading = true;
    notifyListeners();

    final response = await fetchQuizQuestion(quizeId, amount: 1, next: _next);

    if (response.questions.isEmpty) {
      _quizEnded = true;
    } else {
      _currentQuestion = response.questions.first;
      _next = response.next;
      _isAnswered = false;
      _isCorrect = false;
      _selectedAnswerId = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> answerQuestion(Answer answer) async {
    if (_isAnswered || _currentQuestion == null) return;

    _isAnswered = true;
    _isCorrect = answer.isValid;
    _selectedAnswerId = answer.id;
    notifyListeners();

    await sendUserAction(puid, quizeId, _currentQuestion!.id, answer.id);

    if (answer.isValid) {
      _score += _currentQuestion!.point;
    }
    notifyListeners();
  }
}
