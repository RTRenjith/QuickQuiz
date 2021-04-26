import 'package:quick_quiz/models/ques_snap.dart';
import 'package:quick_quiz/models/question_model.dart';

class DbtoUr{
  List<QuestionModel> quesWeWant = new List<QuestionModel>();

   Future temp(List<QuestionSnap> quesObj) async {
    await getQuestionModelFromSnapShot(quesObj);
    return quesWeWant;
  }
   getQuestionModelFromSnapShot(List<QuestionSnap> quesObj)  {
    for (QuestionSnap temp in quesObj) {
      QuestionModel quesWe = new QuestionModel(
        question: temp.question,
        option1: temp.option1,
        option2: temp.option2,
        option3: temp.option3,
        option4: temp.option4,
      );
      quesWeWant.add(quesWe);
    }
  }
}