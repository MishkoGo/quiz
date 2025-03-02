import 'package:quiz/Core/answer.dart';
import 'package:quiz/Core/question.dart';

class QuizResponse {
  final List<Question> questions;
  final String next;

  QuizResponse({required this.questions, required this.next});
}

Future<QuizResponse> fetchQuizQuestion(
  String quizeId, {
  int amount = 1,
  String? next,
}) async {
  await Future.delayed(Duration(seconds: 1));

  if (next == 'end') {
    return QuizResponse(questions: [], next: "");
  }

  final List<Question> allQuestions = [
    Question(
      id: 'q1',
      title: 'Какой город является столицей Франции',
      answers: [
        Answer(id: 'a1', text: 'Париж', isValid: true),
        Answer(id: 'a2', text: 'Берлин', isValid: false),
        Answer(id: 'a3', text: 'Рим', isValid: false),
      ],
      point: 10,
    ),
    Question(
      id: 'q2',
      title: 'Какая планета самая большая в Солнечной системе?',
      answers: [
        Answer(id: 'a1', text: 'Земля', isValid: false),
        Answer(id: 'a2', text: 'Юпитер', isValid: true),
        Answer(id: 'a3', text: 'Марс', isValid: false),
        Answer(id: 'a4', text: 'Сатурн', isValid: false),
      ],
      point: 15,
    ),
    Question(
      id: 'q3',
      title: 'Кто написал произведение "Война и мир"?',
      answers: [
        Answer(id: 'a1', text: 'Лев Толстой', isValid: true),
        Answer(id: 'a2', text: 'Фёдор Достоевский', isValid: false),
      ],
      point: 20,
    ),
    Question(
      id: 'q4',
      title: 'Какой элемент обозначается символом "O"?',
      answers: [
        Answer(id: 'a1', text: 'Кислород', isValid: true),
        Answer(id: 'a2', text: 'Водород', isValid: false),
        Answer(id: 'a3', text: 'Углерод', isValid: false),
      ],
      point: 10,
    ),
    Question(
      id: 'q5',
      title: 'В каком году произошла Октябрьская революция?',
      answers: [
        Answer(id: 'a1', text: '1917', isValid: true),
        Answer(id: 'a2', text: '1922', isValid: false),
        Answer(id: 'a3', text: '1905', isValid: false),
        Answer(id: 'a4', text: '1900', isValid: false),
        Answer(id: 'a5', text: '1912', isValid: false),
      ],
      point: 25,
    ),
  ];

  int index = next != null ? int.tryParse(next) ?? 0 : 0;

  if (index >= allQuestions.length) {
    return QuizResponse(questions: [], next: "");
  }

  String nextValue =
      (index + 1 < allQuestions.length) ? (index + 1).toString() : "end";

  return QuizResponse(questions: [allQuestions[index]], next: nextValue);
}

Future<void> sendUserAction(
  String puid,
  String quizeId,
  String questionId,
  String answerId,
) async {
  await Future.delayed(Duration(milliseconds: 500));
  print(
    'User action sent: puid=$puid, quize_id=$quizeId, question_id=$questionId, answer_id=$answerId',
  );
}
