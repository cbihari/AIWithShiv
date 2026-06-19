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
  'pattern-playground-lesson-01': _LessonText(
    'Color Patterns',
    'Shiv rangoli वाला color path बनाता है: red, yellow, red, yellow. Learner next color tap करता है और देखता है कि repeating clues brain को smart guess करने में help करते हैं. Shiv कहता है patterns everywhere होते हैं: rangoli, lights, कपड़े, और classroom charts.',
    ['Colors', 'Repeating patterns', 'Rangoli'],
  ),
  'pattern-playground-lesson-02': _LessonText(
    'Shape Patterns',
    'Shiv classroom को circles और squares से decorate करता है: circle, square, circle, square. Learner missing shape ढूंढता है. Shiv समझाता है कि shapes भी patterns बना सकते हैं, और AI भी ऐसे clues notice कर सकता है.',
    ['Shapes', 'Sequences', 'Missing clue'],
  ),
  'pattern-playground-lesson-03': _LessonText(
    'Number Patterns',
    'Shiv mango baskets लगाता है: 2, 4, 6, 8 mangoes. Learner counting jump spot करता है और next basket guess करता है. Shiv cheer करता है क्योंकि number patterns maths और AI दोनों में clues देते हैं.',
    ['Numbers', 'Counting', 'Prediction'],
  ),
  'pattern-playground-lesson-04': _LessonText(
    'Sound Patterns',
    'Shiv tabla और clap rhythm बनाता है: clap, tap, clap, tap. Learner ध्यान से सुनकर next sound repeat करता है. Shiv कहता है ears भी pattern detectives हैं, जैसे eyes colors और shapes में clues ढूंढती हैं.',
    ['Sounds', 'Rhythm', 'Listening'],
  ),
  'pattern-playground-lesson-05': _LessonText(
    'What Comes Next?',
    'Festival lights blink करती हैं: diya, star, diya, star. Shiv पूछता है next light क्या होगी? Learner clues देखकर diya बोलता है. Shiv बताता है prediction smart guess है, पर important guesses हमेशा check करने चाहिए.',
    ['Prediction', 'Clues', 'Festival lights'],
  ),
  'pattern-playground-lesson-06': _LessonText(
    'Odd One Out',
    'Shiv detective टोपी पहनता है और दिखाता है: mango, apple, banana, bus. Learner bus spot करता है क्योंकि bus fruit group में fit नहीं होती. Shiv कहता है AI भी groups देखकर odd चीजें पहचान सकता है.',
    ['Odd one out', 'Groups', 'Detective thinking'],
  ),
  'pattern-playground-lesson-07': _LessonText(
    'Simple Predictions',
    'Shiv cricket ball को bat की तरफ roll होते देखता है. Learner guess करता है कि bat ball को hit कर सकता है. Shiv समझाता है कि predictions clues से बनते हैं, पर हर prediction perfect नहीं होती.',
    ['Simple prediction', 'Cricket', 'Checking'],
  ),
  'pattern-playground-lesson-08': _LessonText(
    'Treasure Clues',
    'Shiv treasure map खोलता है: blue door तक जाओ, फिर yellow star ढूंढो. Learner clues को order में follow करता है. Shiv बताता है कि सही order से steps clear होते हैं और goal तक पहुंचना आसान होता है.',
    ['Treasure clues', 'Order', 'Map'],
  ),
  'pattern-playground-lesson-09': _LessonText(
    'Detective Thinking',
    'Tiffin spoon गायब है! Shiv कहता है जल्दी blame मत करो, पहले clues देखो. Learner table, bag, और lunch mat check करता है. Evidence देखकर guess करना detective thinking है, और AI answers check करने में भी यही habit काम आती है.',
    ['Reasoning', 'Evidence', 'Careful thinking'],
  ),
  'pattern-playground-lesson-10': _LessonText(
    'Pattern Hero Mission',
    'Shiv festival playground challenge खोलता है. Learner colors, shapes, numbers, sounds, odd-one-out, और treasure clues complete करता है. Shiv कहता है Pattern Hero clues देखता है, smart guess करता है, और important answers check करता है.',
    ['Pattern review', 'Mission', 'Hero thinking'],
  ),
  'teach-the-robot-lesson-01': _LessonText(
    'Examples Robots को सिखाते हैं',
    'ShivBot fruits सीखना चाहता है. Shiv mango, apple, और banana cards दिखाता है. Learner समझता है कि examples robot helper को नई चीजें पहचानना सिखाते हैं. More clear examples मतलब better learning.',
    ['Examples', 'Learning', 'Fruits'],
  ),
  'teach-the-robot-lesson-02': _LessonText(
    'Categories Buckets जैसी हैं',
    'Shiv तीन buckets लाता है: animals, food, और vehicles. Dog animals में जाता है, pizza food में, और bus vehicles में. Learner देखता है कि categories similar चीजों को साथ रखने में help करती हैं.',
    ['Categories', 'Groups', 'Buckets'],
  ),
  'teach-the-robot-lesson-03': _LessonText(
    'ShivBot को Train करना',
    'ShivBot बार-बार examples से practice करता है. Learner many clear examples दिखाता है ताकि ShivBot better समझ सके. Shiv बताता है training का मतलब है enough correct examples देकर सीखने में help करना.',
    ['Training', 'Practice', 'Many examples'],
  ),
  'teach-the-robot-lesson-04': _LessonText(
    'Good Data',
    'Shiv messy flashcards clean करता है. Clear mango picture और सही mango label ShivBot को सही सीखने में help करते हैं. Learner best examples choose करता है और समझता है कि good data clear और correct होता है.',
    ['Good data', 'Clear labels', 'Quality'],
  ),
  'teach-the-robot-lesson-05': _LessonText(
    'Bad Data',
    'Oh no! ShivBot cricket ball को mango समझता है क्योंकि card पर wrong label था. Learner confusing data fix करता है. Shiv बताता है bad data AI को silly mistakes करा सकता है.',
    ['Bad data', 'Wrong labels', 'Mistakes'],
  ),
  'teach-the-robot-lesson-06': _LessonText(
    'AI की तरह Sorting',
    'ShivBot tiffin snacks, toys, और vehicles sort करता है. Learner items को right groups में रखता है. Shiv कहता है classification का मतलब चीजों को सही groups में रखना है.',
    ['Classification', 'Sorting', 'Groups'],
  ),
  'teach-the-robot-lesson-07': _LessonText(
    'Examples से Guess करना',
    'Many fruits देखने के बाद ShivBot yellow curved item देखकर banana guess करता है. Shiv समझाता है कि AI examples और clues से guesses बनाता है. Smart heroes guesses को check भी करते हैं.',
    ['Prediction', 'Examples', 'Guessing'],
  ),
  'teach-the-robot-lesson-08': _LessonText(
    'Recommendations',
    'Learner को cricket stories पसंद हैं, इसलिए Shiv एक और cricket story suggest करता है. Shiv बताता है recommendations choices में patterns देखकर helpful suggestions देती हैं.',
    ['Recommendations', 'Preferences', 'Suggestions'],
  ),
  'teach-the-robot-lesson-09': _LessonText(
    'Mistakes से सीखना',
    'ShivBot silly mistake करता है और learner उसे kindly correct करता है. Shiv बताता है कि feedback smart helpers को improve करने में help करता है. गलती सीखने का chance हो सकती है.',
    ['Feedback', 'Correction', 'Improvement'],
  ),
  'teach-the-robot-lesson-10': _LessonText(
    'Robot Hero Mission',
    'School fair शुरू है! Learner ShivBot को examples, categories, good data, sorting, predictions, और corrections से train करता है. Shiv cape spin करके कहता है, Shabash Robot Hero!',
    ['Review', 'Robot training', 'AI hero'],
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
  'pattern-playground-lesson-01-quiz': _QuizText('Color Patterns Checkpoint', {
    'pattern-playground-lesson-01-q1': _QuestionText(
      'Color pattern कहाँ देख सकते हैं?',
      ['Rangoli', 'Password box', 'Phone number', 'Address card'],
      'Rangoli में beautiful repeating color patterns हो सकते हैं.',
    ),
    'pattern-playground-lesson-01-q2': _QuestionText(
      'Next color ढूंढने में क्या help करता है?',
      [
        'Repeat को देखना',
        'Eyes बंद करना',
        'Secrets share करना',
        'Any word guess करना'
      ],
      'Repeat देखने से next color का clue मिलता है.',
    ),
  }),
  'pattern-playground-lesson-02-quiz': _QuizText('Shape Patterns Checkpoint', {
    'pattern-playground-lesson-02-q1': _QuestionText(
      'Circle, square, circle, square के बाद क्या आएगा?',
      ['Circle', 'Mango', 'Tabla', 'Bus'],
      'Shape pattern circle और square repeat कर रहा है.',
    ),
    'pattern-playground-lesson-02-q2': _QuestionText(
      'इनमें shape कौन सा है?',
      ['Triangle', 'Tiffin', 'Homework', 'Cricket'],
      'Triangle एक shape है.',
    ),
  }),
  'pattern-playground-lesson-03-quiz': _QuizText('Number Patterns Checkpoint', {
    'pattern-playground-lesson-03-q1': _QuestionText(
      '2, 4, 6, 8 के बाद क्या आएगा?',
      ['10', '3', 'Mango', 'Red'],
      'Numbers हर बार 2 से बढ़ रहे हैं, इसलिए 10 next है.',
    ),
    'pattern-playground-lesson-03-q2': _QuestionText(
      'Number patterns हमें क्या help करते हैं?',
      [
        'Next number predict करना',
        'Phone number share करना',
        'Counting भूलना',
        'Pencils छुपाना'
      ],
      'Number patterns next number guess करने में help करते हैं.',
    ),
  }),
  'pattern-playground-lesson-04-quiz': _QuizText('Sound Patterns Checkpoint', {
    'pattern-playground-lesson-04-q1': _QuestionText(
      'Clap, tap, clap, tap के बाद क्या आएगा?',
      ['Clap', 'Bus', 'Mango', 'Star'],
      'Sound pattern clap और tap repeat कर रहा है.',
    ),
    'pattern-playground-lesson-04-q2': _QuestionText(
      'Sound patterns में कौन सी sense help करती है?',
      ['Listening', 'Smelling', 'Running', 'Sleeping'],
      'Listening से sound clues notice होते हैं.',
    ),
  }),
  'pattern-playground-lesson-05-quiz': _QuizText('What Comes Next Checkpoint', {
    'pattern-playground-lesson-05-q1': _QuestionText(
      'Diya, star, diya, star. Next क्या आएगा?',
      ['Diya', 'Phone', 'Dog', 'Pencil'],
      'Festival light pattern diya और star repeat कर रहा है.',
    ),
    'pattern-playground-lesson-05-q2': _QuestionText(
      'Prediction क्या होती है?',
      [
        'Clues से smart guess',
        'Private password',
        'Scary rule',
        'Hidden address'
      ],
      'Prediction clues से बनी smart guess होती है.',
    ),
  }),
  'pattern-playground-lesson-06-quiz': _QuizText('Odd One Out Checkpoint', {
    'pattern-playground-lesson-06-q1': _QuestionText(
      'Odd item कौन सा है: mango, apple, banana, bus?',
      ['Bus', 'Mango', 'Apple', 'Banana'],
      'Bus vehicle है. बाकी fruits हैं.',
    ),
    'pattern-playground-lesson-06-q2': _QuestionText(
      'Odd one out का मतलब क्या है?',
      [
        'जो item group में fit नहीं होता',
        'Best secret',
        'Longest word',
        'Fastest car'
      ],
      'Odd item group में fit नहीं होता.',
    ),
  }),
  'pattern-playground-lesson-07-quiz':
      _QuizText('Simple Predictions Checkpoint', {
    'pattern-playground-lesson-07-q1': _QuestionText(
      'Ball bat की तरफ roll हो रही है. क्या हो सकता है?',
      [
        'Bat ball को hit कर सकता है',
        'Ball password बन जाएगी',
        'Ball homework बन जाएगी',
        'Ball phone call करेगी'
      ],
      'Clues देखकर हम guess कर सकते हैं कि bat ball को hit कर सकता है.',
    ),
    'pattern-playground-lesson-07-q2': _QuestionText(
      'क्या predictions हमेशा perfect होती हैं?',
      [
        'नहीं, हमें check करना चाहिए',
        'हाँ, हमेशा',
        'Only Diwali पर',
        'Only mangoes के साथ'
      ],
      'Predictions helpful हो सकती हैं, पर check करना smart habit है.',
    ),
  }),
  'pattern-playground-lesson-08-quiz': _QuizText('Treasure Clues Checkpoint', {
    'pattern-playground-lesson-08-q1': _QuestionText(
      'Clues को order में follow क्यों करना चाहिए?',
      [
        'Order goal तक पहुंचने में help करता है',
        'Order secrets छुपाता है',
        'Order learning रोकता है',
        'Order address share करता है'
      ],
      'Step-by-step order goal तक पहुंचने में help करता है.',
    ),
    'pattern-playground-lesson-08-q2': _QuestionText(
      'Good treasure clue कौन सा है?',
      [
        'Blue door तक जाओ',
        'अपना password बताओ',
        'Map भूल जाओ',
        'Any secret pick करो'
      ],
      'Good clue safe और clear step देता है.',
    ),
  }),
  'pattern-playground-lesson-09-quiz':
      _QuizText('Detective Thinking Checkpoint', {
    'pattern-playground-lesson-09-q1': _QuestionText(
      'Guess करने से पहले detective को क्या देखना चाहिए?',
      ['Evidence', 'Passwords', 'Random pop-ups', 'Private photos'],
      'Evidence better guesses बनाने में help करता है.',
    ),
    'pattern-playground-lesson-09-q2': _QuestionText(
      'Tiffin spoon missing हो तो क्या help करेगा?',
      [
        'Clues check करना',
        'जल्दी blame करना',
        'Facts ignore करना',
        'Address share करना'
      ],
      'Careful thinkers guess करने से पहले clues check करते हैं.',
    ),
  }),
  'pattern-playground-lesson-10-quiz':
      _QuizText('Pattern Hero Mission Checkpoint', {
    'pattern-playground-lesson-10-q1': _QuestionText(
      'Pattern Hero की skill कौन सी है?',
      [
        'What comes next ढूंढना',
        'Secrets share करना',
        'Never checking',
        'Clues भूलना'
      ],
      'Pattern Heroes clues देखकर next item find करते हैं.',
    ),
    'pattern-playground-lesson-10-q2': _QuestionText(
      'Important pattern guesses के साथ क्या करना चाहिए?',
      ['Check them', 'Always trust them', 'Hide them', 'Thinking बंद करें'],
      'Important guesses को check करना चाहिए.',
    ),
  }),
  'teach-the-robot-lesson-01-quiz':
      _QuizText('Examples Teach Robots Checkpoint', {
    'teach-the-robot-lesson-01-q1': _QuestionText(
      'ShivBot को fruits सीखने में क्या help करता है?',
      ['Fruit examples', 'No pictures', 'Secret numbers', 'Wrong names'],
      'Fruit examples ShivBot को fruits पहचानना सिखाते हैं.',
    ),
    'teach-the-robot-lesson-01-q2': _QuestionText(
      'Fruit example कौन सा है?',
      ['Mango', 'Bus', 'Shoe', 'Pencil'],
      'Mango fruit example है.',
    ),
  }),
  'teach-the-robot-lesson-02-quiz': _QuizText('Categories Checkpoint', {
    'teach-the-robot-lesson-02-q1': _QuestionText(
      'Dog कहाँ belong करता है?',
      ['Animals', 'Food', 'Vehicles', 'Passwords'],
      'Dog animals category में belong करता है.',
    ),
    'teach-the-robot-lesson-02-q2': _QuestionText(
      'Category क्या होती है?',
      ['Similar चीजों का group', 'Secret code', 'Phone number', 'Scary rule'],
      'Category similar चीजों को group करती है.',
    ),
  }),
  'teach-the-robot-lesson-03-quiz': _QuizText('Training ShivBot Checkpoint', {
    'teach-the-robot-lesson-03-q1': _QuestionText(
      'Training ShivBot का मतलब क्या है?',
      [
        'Many examples दिखाना',
        'No examples देना',
        'Address share करना',
        'App close करना'
      ],
      'Training का मतलब examples से सीखने में help करना है.',
    ),
    'teach-the-robot-lesson-03-q2': _QuestionText(
      'Best examples कैसे होते हैं?',
      ['Clear और correct', 'Wrong और messy', 'Private passwords', 'No labels'],
      'Clear और correct examples AI को better सीखाते हैं.',
    ),
  }),
  'teach-the-robot-lesson-04-quiz': _QuizText('Good Data Checkpoint', {
    'teach-the-robot-lesson-04-q1': _QuestionText(
      'कौन सा data ShivBot को सबसे ज्यादा help करता है?',
      [
        'Clear mango card with right label',
        'Wrong label वाला blurry card',
        'Password list',
        'No label at all'
      ],
      'Good data clear और correctly labeled होता है.',
    ),
    'teach-the-robot-lesson-04-q2': _QuestionText(
      'Good data कैसा होना चाहिए?',
      [
        'Clear और correct',
        'Private और secret',
        'Wrong और confusing',
        'Always empty'
      ],
      'Good data AI को safely और correctly सीखने में help करता है.',
    ),
  }),
  'teach-the-robot-lesson-05-quiz': _QuizText('Bad Data Checkpoint', {
    'teach-the-robot-lesson-05-q1': _QuestionText(
      'Bad data क्या cause कर सकता है?',
      ['Mistakes', 'Magic', 'Perfect answers', 'No learning ever'],
      'Bad data AI से wrong answers करा सकता है.',
    ),
    'teach-the-robot-lesson-05-q2': _QuestionText(
      'Wrong labels के साथ क्या करना चाहिए?',
      ['Fix them', 'Hide them', 'Online share them', 'Safety ignore करें'],
      'Wrong labels fix करने से ShivBot improve करता है.',
    ),
  }),
  'teach-the-robot-lesson-06-quiz': _QuizText('Sorting Like AI Checkpoint', {
    'teach-the-robot-lesson-06-q1': _QuestionText(
      'Bus कहाँ जाना चाहिए?',
      ['Vehicles', 'Fruits', 'Animals', 'Passwords'],
      'Bus vehicles group में belong करता है.',
    ),
    'teach-the-robot-lesson-06-q2': _QuestionText(
      'Sorting AI को क्या help करती है?',
      [
        'चीजों को groups में रखना',
        'Secrets collect करना',
        'Examples भूलना',
        'Learning रोकना'
      ],
      'Sorting groups और categories सीखाती है.',
    ),
  }),
  'teach-the-robot-lesson-07-quiz':
      _QuizText('Guessing From Examples Checkpoint', {
    'teach-the-robot-lesson-07-q1': _QuestionText(
      'Yellow curved fruit क्या हो सकता है?',
      ['Banana', 'Cricket bat', 'School bus', 'Notebook'],
      'Examples और clues देखकर AI banana guess कर सकता है.',
    ),
    'teach-the-robot-lesson-07-q2': _QuestionText(
      'AI किससे guess करता है?',
      ['Examples', 'Secrets', 'No clues', 'Angry faces'],
      'AI examples से guesses बनाता है.',
    ),
  }),
  'teach-the-robot-lesson-08-quiz': _QuizText('Recommendations Checkpoint', {
    'teach-the-robot-lesson-08-q1': _QuestionText(
      'अगर आपको cricket stories पसंद हैं, Shiv क्या suggest कर सकता है?',
      [
        'Another cricket story',
        'A password',
        'A random address',
        'A private photo'
      ],
      'Recommendations choices के patterns से suggestions देती हैं.',
    ),
    'teach-the-robot-lesson-08-q2': _QuestionText(
      'Recommendation क्या होती है?',
      ['Helpful suggestion', 'Secret rule', 'Phone number', 'Wrong label'],
      'Recommendation clues और choices से बनी helpful suggestion होती है.',
    ),
  }),
  'teach-the-robot-lesson-09-quiz':
      _QuizText('Learning From Mistakes Checkpoint', {
    'teach-the-robot-lesson-09-q1': _QuestionText(
      'Mistake के बाद ShivBot को improve करने में क्या help करता है?',
      ['Kind correction', 'More wrong labels', 'Private info', 'No feedback'],
      'Feedback और correction ShivBot को improve करते हैं.',
    ),
    'teach-the-robot-lesson-09-q2': _QuestionText(
      'AI mistakes कैसे fix करनी चाहिए?',
      [
        'Check और kindly correct करें',
        'Always ignore करें',
        'Secrets share करें',
        'Learning रोक दें'
      ],
      'Checking और correcting से AI better सीख सकता है.',
    ),
  }),
  'teach-the-robot-lesson-10-quiz': _QuizText('Robot Hero Mission Checkpoint', {
    'teach-the-robot-lesson-10-q1': _QuestionText(
      'Robot Hero ShivBot को train करने के लिए क्या use करता है?',
      [
        'Examples और good data',
        'Passwords और addresses',
        'No labels',
        'Random shouting'
      ],
      'Examples और good data ShivBot को train करने में help करते हैं.',
    ),
    'teach-the-robot-lesson-10-q2': _QuestionText(
      'AI learning को safe रखने वाली habit कौन सी है?',
      [
        'Mistakes check करना',
        'Every guess trust करना',
        'Bad data use करना',
        'Private photos share करना'
      ],
      'Mistakes check करना AI learning को safer बनाता है.',
    ),
  }),
};
