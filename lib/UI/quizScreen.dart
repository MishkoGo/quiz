import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz/Core/answer.dart';
import 'package:quiz/Core/provider.dart';
import 'package:quiz/main.dart';
import 'package:quiz/UI/shakeWidget.dart';
import 'package:quiz/Core/sound.dart';
import 'package:quiz/UI/welcomeScreen.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _handleAnswer(QuizProvider quizProvider, Answer answer) {
    quizProvider.answerQuestion(answer);
    if (answer.isValid) {
      SoundPlayer.playCorrect();
    } else {
      SoundPlayer.playWrong();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        if (quizProvider.isLoading) {
          return Scaffold(
            appBar: AppBar(title: Text("Quiz")),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (quizProvider.quizEnded) {
          return Scaffold(
            appBar: AppBar(title: Text("Quiz")),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Квиз завершён.",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Ваш результат: ${quizProvider.score}",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<QuizProvider>(
                        context,
                        listen: false,
                      ).resetQuiz();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => WelcomeScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text(
                      "На Главную",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (quizProvider.isAnswered && quizProvider.isCorrect) {
          Future.microtask(() {
            _confettiController.play();
          });
        }

        final currentQuestion = quizProvider.currentQuestion!;

        return Scaffold(
          appBar: AppBar(title: Text("Quiz")),
          body: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Вопрос ${quizProvider.currentStep + 1}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            currentQuestion.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          ...currentQuestion.answers.map((answer) {
                            final bool isAnswered = quizProvider.isAnswered;
                            final String? selectedId =
                                quizProvider.selectedAnswerId;
                            Color buttonColor;

                            if (isAnswered) {
                              if (answer.id == selectedId) {
                                buttonColor =
                                    answer.isValid ? Colors.green : Colors.red;
                              } else {
                                buttonColor =
                                    answer.isValid ? Colors.green : Colors.grey;
                              }
                            } else {
                              buttonColor = Colors.blue;
                            }

                            final VoidCallback? onPressed;
                            if (isAnswered) {
                              if (answer.id == selectedId || answer.isValid) {
                                onPressed = () {};
                              } else {
                                onPressed = null;
                              }
                            } else {
                              onPressed = () {
                                quizProvider.answerQuestion(answer);
                                if (answer.isValid) {
                                  SoundPlayer.playCorrect();
                                } else {
                                  SoundPlayer.playWrong();
                                }
                              };
                            }

                            final answerButton = ElevatedButton(
                              onPressed: onPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                disabledForegroundColor: buttonColor
                                    .withOpacity(0.38),
                                disabledBackgroundColor: buttonColor.withOpacity(
                                  0.12,
                                ), // чтобы цвет сохранялся в неактивном состоянии
                              ),
                              child: Text(answer.text),
                            );

                            final resultButton =
                                (isAnswered &&
                                        answer.id == selectedId &&
                                        !answer.isValid)
                                    ? ShakeWidget(
                                      shake: true,
                                      child: answerButton,
                                    )
                                    : answerButton;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: resultButton,
                            );
                          }).toList(),
                          Spacer(),

                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'Баллы: ${quizProvider.score}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          SizedBox(height: 16),
                          if (quizProvider.isAnswered)
                            ElevatedButton(
                              onPressed: () {
                                quizProvider.loadNextQuestion();
                              },
                              child: Text("Следующий вопрос"),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
