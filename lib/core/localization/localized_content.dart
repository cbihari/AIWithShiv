import '../../shared/models/course.dart';
import '../../shared/models/game.dart';
import '../../shared/models/lesson.dart';
import '../../shared/models/quiz.dart';
import 'language_service.dart';

class LocalizedContent {
  const LocalizedContent._();

  static Course course(Course value, AppLanguage language) {
    if (language != AppLanguage.hindi) {
      return value;
    }
    final text = _hindiCourses[value.id];
    if (text == null) return value;
    return Course(
      id: value.id,
      title: text.title,
      description: text.description,
      category: text.category,
      ageGroups: value.ageGroups,
      lessonIds: value.lessonIds,
      imageUrl: value.imageUrl,
      xp: value.xp,
    );
  }

  static Lesson lesson(Lesson value, AppLanguage language) {
    if (language != AppLanguage.hindi) return value;
    final text = _hindiLessons[value.id];
    if (text == null) return value;
    return Lesson(
      id: value.id,
      courseId: value.courseId,
      title: text.title,
      story: text.story,
      concepts: text.concepts,
      durationMinutes: value.durationMinutes,
      xp: value.xp,
      order: value.order,
    );
  }

  static Quiz quiz(Quiz value, AppLanguage language) {
    if (language != AppLanguage.hindi) return value;
    final text = _hindiQuizzes[value.id];
    if (text == null) return value;
    return Quiz(
      id: value.id,
      lessonId: value.lessonId,
      title: text.title,
      questions: [
        for (final question in value.questions)
          _localizedQuestion(question, text.questions[question.id]),
      ],
    );
  }

  static LearningGame game(LearningGame value, AppLanguage language) {
    if (language != AppLanguage.hindi) return value;
    final text = _hindiGames[value.id];
    if (text == null) return value;
    return LearningGame(
      id: value.id,
      title: text.title,
      concept: text.concept,
      description: text.description,
      ageGroup: value.ageGroup,
      durationMinutes: value.durationMinutes,
      xpReward: value.xpReward,
      coinReward: value.coinReward,
      route: value.route,
      isActive: value.isActive,
    );
  }

  static QuizQuestion _localizedQuestion(
      QuizQuestion value, _QuestionText? text) {
    if (text == null) return value;
    return QuizQuestion(
      id: value.id,
      prompt: text.prompt,
      options: text.options,
      answerIndex: value.answerIndex,
      correctAnswerIndexes: value.correctAnswerIndexes,
      explanation: text.explanation,
    );
  }
}

class _CourseText {
  const _CourseText(this.title, this.description, this.category);

  final String title;
  final String description;
  final String category;
}

class _LessonText {
  const _LessonText(this.title, this.story, this.concepts);

  final String title;
  final String story;
  final List<String> concepts;
}

class _QuizText {
  const _QuizText(this.title, this.questions);

  final String title;
  final Map<String, _QuestionText> questions;
}

class _GameText {
  const _GameText(this.title, this.concept, this.description);

  final String title;
  final String concept;
  final String description;
}

class _QuestionText {
  const _QuestionText(this.prompt, this.options, this.explanation);

  final String prompt;
  final List<String> options;
  final String explanation;
}

const _hindiCourses = {
  'ai-masti-missions': _CourseText(
    'AI Masti Missions',
    'Shiv robot-superhero dost के साथ 10 funny missions करो और AI को safe, simple तरीके से सीखो.',
    'AI Basics',
  ),
  'pattern-playground': _CourseText(
    'Pattern Playground',
    'Rangoli, cricket, shapes, sounds और treasure clues से patterns सीखो.',
    'Patterns',
  ),
  'teach-the-robot': _CourseText(
    'Teach The Robot',
    'ShivBot को examples, sorting और good data से सीखाना शुरू करो.',
    'Machine Learning',
  ),
};

const _hindiLessons = {
  'ai-masti-missions-lesson-01': _LessonText(
    'Shiv AI Hero से मिलो',
    'Namaste, hero! Shiv saffron cape और blinking chest light के साथ classroom में zoom करता है. उसके school bag में funny gadgets हैं, पर उसकी best power बच्चों को सोचने में help करना है. इस mission में Shiv बताता है कि AI smart helper जैसा है, magic नहीं. Together वे mangoes sort करते हैं, missing pencil ढूंढते हैं, और याद रखते हैं कि humans ही final choice करते हैं.',
    ['AI helper', 'Human choice', 'Shiv'],
  ),
  'ai-masti-missions-lesson-02': _LessonText(
    'AI क्या है?',
    'Shiv AI Masti नाम की छोटी comic book खोलता है. वह बताता है कि AI मतलब computer examples से सीखकर tasks में help कर सकता है. Learner pretend tiffin robot को clues से snacks guess करते देखता है: round, yellow, sweet मतलब laddoo. Robot cricket ball guess करता है तो सब हंसते हैं, फिर Shiv बताता है कि AI अच्छे examples से बेहतर होता है.',
    ['Artificial intelligence', 'Examples', 'Learning'],
  ),
  'ai-masti-missions-lesson-03': _LessonText(
    'मेरे घर में AI',
    'Chalo home mission! Shiv एक friendly home में जाता है जहाँ AI small ways में help करता है. Phone face से unlock होता है, music app song suggest करता है, और map family को nani के घर ले जाने में help करता है. Shiv याद दिलाता है कि AI help कर सकता है, पर family rules सबसे जरूरी हैं. Mission silly beep song पर खत्म होता है.',
    ['Daily life', 'Smart tools', 'Family rules'],
  ),
  'ai-masti-missions-lesson-04': _LessonText(
    'School में AI',
    'Shiv blackboard के पास land करता है और classroom को learning lab बना देता है. वह दिखाता है कि AI word पढ़ने, counting practice करने, या homework idea समझाने में help कर सकता है. जब pencil desk के नीचे जाती है, Shiv कहता है AI सब काम नहीं कर सकता, इसलिए learner खुद safely देखकर pencil ढूंढता है. Shabash!',
    ['School help', 'Homework', 'Teamwork'],
  ),
  'ai-masti-missions-lesson-05': _LessonText(
    'Examples से AI सिखाना',
    'Shiv तीन baskets लाता है: mangoes, bananas, और cricket balls. Learner pretend AI को many examples दिखाकर सिखाता है. Yellow और curved banana basket में जाता है. Round और bouncy cricket ball basket में जाता है. Shiv funny mistake करके mango को ball basket में डालता है, फिर बताता है कि clear और correct examples से AI better सीखता है.',
    ['Training', 'Sorting', 'Clear examples'],
  ),
  'ai-masti-missions-lesson-06': _LessonText(
    'Patterns Treasure Clues जैसे हैं',
    'Shiv rangoli pattern बनाता है: red, yellow, red, yellow. Next क्या आएगा? Learner clue ढूंढकर red कहता है. Shiv cheer करता है क्योंकि AI भी examples में patterns खोजता है. वे claps, steps, और cricket scores से खेलते हैं. Mission सिखाता है कि patterns AI को guess करने में help करते हैं, पर guesses check करने चाहिए.',
    ['Patterns', 'Prediction', 'Checking'],
  ),
  'ai-masti-missions-lesson-07': _LessonText(
    'AI से अच्छे सवाल पूछना',
    'Shiv Prompt Power Lunch Box खोलता है. अंदर तीन magic ingredients हैं: क्या चाहिए, helpful details, और polite question. सिर्फ homework बोलने के बजाय learner पूछता है: please explain my mango sharing sum for class 2. Shiv cape spin करता है और कहता है अच्छे questions AI को better answers देने में help करते हैं. Chalo, prompt hero!',
    ['Prompts', 'Details', 'Polite questions'],
  ),
  'ai-masti-missions-lesson-08': _LessonText(
    'AI गलती कर सकता है',
    'Shiv pretend AI से पूछता है, yellow और sweet fruit कौन सा? AI चिल्लाता है potato. सब giggle करते हैं. Shiv समझाता है कि AI silly mistakes कर सकता है, इसलिए important answers teacher, parent, book, या trusted source से check करने चाहिए. Learner Fact Check Hero बनकर answer mango या banana करता है.',
    ['Mistakes', 'Fact checking', 'Trusted adults'],
  ),
  'ai-masti-missions-lesson-09': _LessonText(
    'Secrets Safe रखो',
    'Shiv अपना Secret Shield पहनता है. वह सिखाता है कि passwords, home address, phone number, school ID, और private photos AI chats में share नहीं करने. Learner safe चीजें share करना practice करता है, जैसे favorite color या math question, और private things locked रखता है. Shiv कहता है smart heroes family secrets protect करते हैं.',
    ['Privacy', 'Passwords', 'Safe sharing'],
  ),
  'ai-masti-missions-lesson-10': _LessonText(
    'मेरा पहला AI Hero Mission',
    'Final mission day है! Shiv learner से सभी hero powers use करवाता है: AI helper है, clear examples देना, patterns find करना, good questions पूछना, mistakes check करना, और secrets safe रखना. Together वे private information share किए बिना Diwali rangoli idea plan करते हैं. Shiv light up होकर कहता है, Shabash, AI Masti Hero!',
    ['Review', 'Safe AI', 'Hero mission'],
  ),
};

const _hindiGames = {
  'train_robot': _GameText(
    'Robot को Train करें',
    'Machine Learning',
    'Correct examples देकर ShivBot को सिखाएं.',
  ),
  'ai_detective': _GameText(
    'AI Detective',
    'Pattern Recognition',
    'Pattern में छुपा odd item ढूंढें.',
  ),
  'sort_like_ai': _GameText(
    'AI की तरह Sort करें',
    'Classification',
    'Animals, food, और vehicles को groups में sort करें.',
  ),
  'robot_treasure_hunt': _GameText(
    'Robot Treasure Hunt',
    'Algorithm',
    'Shiv को clear steps देकर treasure तक पहुंचाएं.',
  ),
  'spot_ai_mistake': _GameText(
    'AI Mistake पकड़ो',
    'AI Safety',
    'AI answers check करें और silly mistakes पकड़ें.',
  ),
};

const _hindiQuizzes = {
  'ai-masti-missions-lesson-01-quiz': _QuizText('Shiv AI Hero Checkpoint', {
    'ai-masti-missions-lesson-01-q1': _QuestionText(
      'App में Shiv कौन है?',
      [
        'Friendly robot-superhero helper',
        'Scary monster',
        'Cricket bat',
        'Lunch box'
      ],
      'Shiv friendly robot-superhero dost है जो बच्चों को सीखने में help करता है.',
    ),
    'ai-masti-missions-lesson-01-q2': _QuestionText(
      'AI use करते समय charge में कौन रहना चाहिए?',
      ['Child और trusted adults', 'Only computer', 'School bag', 'Lost pencil'],
      'AI helper है. Final choice लोग करते हैं.',
    ),
  }),
  'ai-masti-missions-lesson-02-quiz': _QuizText('AI क्या है? Checkpoint', {
    'ai-masti-missions-lesson-02-q1': _QuestionText(
      'AI किस जैसा है?',
      ['Smart computer helper', 'हमेशा सही magic wand', 'Mango tree', 'Shoes'],
      'AI smart helper जैसा है जो examples से सीख सकता है.',
    ),
    'ai-masti-missions-lesson-02-q2': _QuestionText(
      'AI को better सीखने में क्या help करता है?',
      ['Good examples', 'No examples', 'Only jokes', 'Eyes बंद करना'],
      'Good examples AI को task समझने में help करते हैं.',
    ),
  }),
  'ai-masti-missions-lesson-03-quiz': _QuizText('घर में AI Checkpoint', {
    'ai-masti-missions-lesson-03-q1': _QuestionText(
      'घर में AI help का example कौन सा है?',
      [
        'Map app directions देती है',
        'Spoon सोता है',
        'Tiffin dance करता है',
        'Wall laddoo खाती है'
      ],
      'Map app smart tools से family को route find करने में help कर सकता है.',
    ),
    'ai-masti-missions-lesson-03-q2': _QuestionText(
      'Smart tools use करते समय घर में क्या follow करना चाहिए?',
      [
        'Family rules',
        'No rules ever',
        'Only robot rules',
        'Cricket score rules'
      ],
      'Family rules बच्चों को technology use करते समय safe रखते हैं.',
    ),
  }),
  'ai-masti-missions-lesson-04-quiz': _QuizText('School में AI Checkpoint', {
    'ai-masti-missions-lesson-04-q1': _QuestionText(
      'AI school में कैसे help कर सकता है?',
      [
        'Homework idea explain करके',
        'Notebook खाकर',
        'Pencil छुपाकर',
        'Learning cancel करके'
      ],
      'AI ideas explain कर सकता है, पर learning बच्चा ही करता है.',
    ),
    'ai-masti-missions-lesson-04-q2': _QuestionText(
      'Pencil desk के नीचे जाए तो क्या करें?',
      [
        'Safely ढूंढें',
        'AI से screen से उठवाएं',
        'हमेशा रोएं',
        'Blackboard को blame करें'
      ],
      'AI हर real-world काम नहीं कर सकता. बच्चे भी smart solutions ढूंढते हैं.',
    ),
  }),
  'ai-masti-missions-lesson-05-quiz': _QuizText('Examples से AI Checkpoint', {
    'ai-masti-missions-lesson-05-q1': _QuestionText(
      'Pretend AI को सिखाने का अच्छा तरीका क्या है?',
      [
        'Clear examples दिखाना',
        'कुछ न दिखाना',
        'सिर्फ जोर से चिल्लाना',
        'Phone पर snacks रखना'
      ],
      'Clear examples AI को समझने में help करते हैं.',
    ),
    'ai-masti-missions-lesson-05-q2': _QuestionText(
      'Shiv के basket game में round और bouncy item कौन सा है?',
      ['Cricket ball', 'Banana', 'School eraser', 'Rangoli powder'],
      'Cricket ball round और bouncy है, इसलिए ball basket में जाता है.',
    ),
  }),
  'ai-masti-missions-lesson-06-quiz': _QuizText('Patterns Checkpoint', {
    'ai-masti-missions-lesson-06-q1': _QuestionText(
      'Pattern में next क्या आएगा: red, yellow, red, yellow?',
      ['Red', 'Blue', 'Tiffin', 'Homework'],
      'Colors red, yellow repeat हो रहे हैं, इसलिए red next आता है.',
    ),
    'ai-masti-missions-lesson-06-q2': _QuestionText(
      'Patterns AI को क्यों help करते हैं?',
      [
        'वे AI को guesses बनाने में help करते हैं',
        'वे AI को mangoes खिलाते हैं',
        'वे learning रोकते हैं',
        'वे books को laddoo बनाते हैं'
      ],
      'Patterns AI को next क्या हो सकता है guess करने में help करते हैं.',
    ),
  }),
  'ai-masti-missions-lesson-07-quiz': _QuizText('Good Questions Checkpoint', {
    'ai-masti-missions-lesson-07-q1': _QuestionText(
      'Better AI question कौन सा है?',
      [
        'Please explain my class 2 mango sharing sum',
        'Homework',
        'Do everything',
        'Banana banana banana'
      ],
      'Good question बताता है कि आपको क्या help चाहिए और details देता है.',
    ),
    'ai-masti-missions-lesson-07-q2': _QuestionText(
      'Prompt को better क्या बनाता है?',
      ['Helpful details', 'Secret passwords', 'Angry words', 'No topic'],
      'Helpful details AI को guide करते हैं. Secret information share नहीं करनी चाहिए.',
    ),
  }),
  'ai-masti-missions-lesson-08-quiz': _QuizText('AI Mistakes Checkpoint', {
    'ai-masti-missions-lesson-08-q1': _QuestionText(
      'क्या AI गलती कर सकता है?',
      ['हाँ, कभी-कभी', 'कभी नहीं', 'Only Sundays', 'Only idli खाते समय'],
      'AI helpful हो सकता है, पर फिर भी mistakes कर सकता है.',
    ),
    'ai-masti-missions-lesson-08-q2': _QuestionText(
      'Important AI answer के साथ क्या करना चाहिए?',
      [
        'Trusted adult या source से check करें',
        'बिना check believe करें',
        'Shoe में छुपाएं',
        'Book फेंक दें'
      ],
      'Important answers trusted people या sources से check करने चाहिए.',
    ),
  }),
  'ai-masti-missions-lesson-09-quiz': _QuizText('Secrets Safe Checkpoint', {
    'ai-masti-missions-lesson-09-q1': _QuestionText(
      'कौन सी चीज private रखनी चाहिए?',
      ['Your password', 'Favorite color', 'Mango drawing', 'Funny safe joke'],
      'Passwords private होते हैं और AI chats में share नहीं करने चाहिए.',
    ),
    'ai-masti-missions-lesson-09-q2': _QuestionText(
      'AI से safely क्या पूछ सकते हैं?',
      [
        'Please explain a math idea',
        'Here is my home address',
        'Here is my password',
        'Here is my parent phone number'
      ],
      'Learning questions okay हैं. Private details safe रखनी चाहिए.',
    ),
  }),
  'ai-masti-missions-lesson-10-quiz': _QuizText('AI Hero Mission Checkpoint', {
    'ai-masti-missions-lesson-10-q1': _QuestionText(
      'AI Hero habit कौन सी है?',
      [
        'Clearly पूछना और important answers check करना',
        'हर secret share करना',
        'हर answer बिना सोचे believe करना',
        'Adult से कभी न पूछना'
      ],
      'AI heroes good questions पूछते हैं, answers check करते हैं, और safe रहते हैं.',
    ),
    'ai-masti-missions-lesson-10-q2': _QuestionText(
      'Shiv और learner को क्या याद रखना चाहिए?',
      [
        'AI helper है, boss नहीं',
        'AI हमेशा magic है',
        'Children को सोचना बंद करना चाहिए',
        'Private information सबके लिए है'
      ],
      'AI help करता है, पर लोग responsible रहते हैं और final choice करते हैं.',
    ),
  }),
};
