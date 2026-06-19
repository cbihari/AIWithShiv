import 'language_service.dart';

class AppStrings {
  const AppStrings(this.language);

  final AppLanguage language;

  bool get isHindi => language == AppLanguage.hindi;

  String get appTitle => 'AI with Shiv';
  String greeting(String name) =>
      isHindi ? 'Namaste $name! 👋' : 'Hey $name! 👋';
  String get unmute => isHindi ? 'आवाज चालू करें' : 'Unmute';
  String get mute => isHindi ? 'आवाज बंद करें' : 'Mute';
  String get xp => 'XP';
  String level(int value) => isHindi ? 'Level $value' : 'Level $value';
  String xpToNext(int value) => isHindi
      ? '$value / 100 XP अगले level तक'
      : '$value / 100 XP to next level';
  String get startLearning => isHindi ? 'सीखना शुरू करें' : 'Start Learning';
  String get dailyQuiz => isHindi ? 'Daily Quiz' : 'Daily Quiz';
  String get askShiv => isHindi ? 'Shiv से पूछें' : 'Ask Shiv';
  String get aiGames => isHindi ? 'AI Games' : 'AI Games';
  String get myTrophies => isHindi ? 'मेरी Trophies' : 'My Trophies';
  String get newBadge => isHindi ? 'नया' : 'NEW';
  String streakLine(int value) => isHindi
      ? '$value दिन की learning streak! Shabash! 🔥'
      : '$value day learning streak! Shabash! 🔥';
  String get learningPath => isHindi ? 'Learning Path' : 'Learning Path';
  String lessonsDone(int done, int total) =>
      isHindi ? '$done of $total lessons पूरे' : '$done of $total lessons done';
  String lessonCount(int order, int total) =>
      isHindi ? 'Lesson $order of $total' : 'Lesson $order of $total';
  String get leaveMission => isHindi ? 'Mission छोड़ें?' : 'Leave mission?';
  String get progressNotSaved => isHindi
      ? 'आपकी progress save नहीं होगी 😢'
      : "Your progress won't be saved 😢";
  String get yesLeave => isHindi ? 'हाँ, छोड़ें' : 'YES LEAVE';
  String get keepGoing => isHindi ? 'चलते रहो' : 'KEEP GOING';
  String get shivSays => isHindi ? 'Shiv कहता है:' : 'Shiv says:';
  String get funFact => isHindi
      ? 'Fun Fact! 💡 AI examples से सीखता है, जैसे आप cricket shot देखकर सीखते हो.'
      : 'Fun Fact! 💡 AI learns from examples, just like you learn a new cricket shot by watching and trying.';
  String get shivTip => isHindi ? 'Shiv की tip' : "Shiv's Tip";
  String get startQuiz =>
      isHindi ? 'समझ गया! ⚡ Quiz शुरू करें' : 'I Understand! ⚡ Start Quiz';
  String get keepReading => isHindi ? 'पढ़ते रहो... 📖' : 'Keep Reading... 📖';
  String get pause => isHindi ? 'रोकें' : 'Pause';
  String get readToMe => isHindi ? 'मुझे पढ़कर सुनाओ!' : 'Read to Me!';
  String get lessonNotFound =>
      isHindi ? 'Lesson नहीं मिला.' : 'Lesson not found.';
  String get quizTime => isHindi ? 'QUIZ TIME!' : 'QUIZ TIME!';
  String get twoQuestions => isHindi
      ? '2 सवाल. तुम कर सकते हो dost! 🤖'
      : '2 Questions. You got this dost! 🤖';
  String get questionsLost => isHindi
      ? 'ShivBot ने questions खो दिए! 😅 फिर try करो!'
      : 'ShivBot lost the questions! 😅 Try again!';
  String get noWorries => isHindi
      ? 'कोई बात नहीं dost, refresh करो या वापस जाओ.'
      : 'No worries dost, tap refresh or go back.';
  String questionOf(int current, int total) =>
      isHindi ? 'Q$current of $total' : 'Q$current of $total';
  String get readQuestion => isHindi ? 'Question पढ़ें' : 'Read question';
  String get checkAnswer => isHindi ? 'Answer check करें ✅' : 'Check Answer ✅';
  String get saving => isHindi ? 'Save हो रहा है...' : 'Saving...';
  String get finishMission =>
      isHindi ? 'Mission पूरा करें 🏆' : 'Finish Mission 🏆';
  String get nextQuestion => isHindi ? 'अगला सवाल ▶' : 'Next Question ▶';
  String correctFeedback() => isHindi ? 'Shabash! 🌟 +XP' : 'Shabash! 🌟 +XP';
  String wrongFeedback(String answer) => isHindi
      ? 'Oops! सही answer था $answer 💪'
      : 'Oops! The answer was $answer 💪';
  String get missionComplete =>
      isHindi ? 'Mission पूरा हुआ! 🎉' : 'Mission Complete! 🎉';
  String scoreLine(int score, int total) => isHindi
      ? 'आपने $score out of $total सही किए!'
      : 'You got $score out of $total!';
  String resultMessage(int score, int total) {
    if (score == total) {
      return isHindi
          ? 'PERFECT! Ekdum Badhiya! ⚡🌟'
          : 'PERFECT! Ekdum Badhiya! ⚡🌟';
    }
    if (score == 1) {
      return isHindi
          ? 'लगभग सही! चलते रहो! 💪'
          : 'Almost there! Keep going! 💪';
    }
    return isHindi
        ? 'Practice से hero बनते हैं dost! 🤗'
        : 'Practice makes perfect dost! 🤗';
  }

  String get heroProfile => isHindi ? 'Hero Profile' : 'Hero Profile';
  String get totalXpEarned => isHindi ? 'Total XP' : 'Total XP earned';
  String get totalCoins => isHindi ? 'Total Coins' : 'Total Coins';
  String get lessonsCompleted => isHindi ? 'Lessons पूरे' : 'Lessons Completed';
  String get bestStreak => isHindi ? 'Best Streak' : 'Best Streak';
  String get myLearningJourney =>
      isHindi ? 'मेरी Learning Journey 🗺' : 'My Learning Journey 🗺';
  String get noCourses => isHindi ? 'अभी कोई course नहीं.' : 'No courses yet.';
  String get tapToChange => isHindi ? 'बदलने के लिए tap करें' : 'Tap to change';
  String heroLevel(int level) =>
      isHindi ? 'Level $level Hero ⭐' : 'Level $level Hero ⭐';
  String get soundEffects => isHindi ? '🔊 Sound Effects' : '🔊 Sound Effects';
  String get voiceReading => isHindi ? '🔊 Voice Reading' : '🔊 Voice Reading';
  String speed(String label) => isHindi ? 'Speed: $label' : 'Speed: $label';
  String get easyReading =>
      isHindi ? '🌟 Easy Reading Mode' : '🌟 Easy Reading Mode';
  String get dataSaver => isHindi ? '📶 Data Saver Mode' : '📶 Data Saver Mode';
  String get appLanguage =>
      isHindi ? '🌐 भाषा / Language' : '🌐 Language / भाषा';
  String get changeAgeGroup =>
      isHindi ? '🌙 Age Group बदलें' : '🌙 Change Age Group';
  String get changeHeroName =>
      isHindi ? '🔄 Hero Name बदलें' : '🔄 Change Hero Name';
  String get aboutApp =>
      isHindi ? 'ℹ️ AI with Shiv के बारे में' : 'ℹ️ About AI with Shiv';
  String get slow => isHindi ? 'Slow 🐢' : 'Slow 🐢';
  String get normal => isHindi ? 'Normal ⚡' : 'Normal ⚡';
  String get fast => isHindi ? 'Fast 🚀' : 'Fast 🚀';
  String get safetyFirst => isHindi
      ? '🛡️ Safety First\nAI with Shiv आपका real name, address या phone number नहीं पूछता. Online कुछ share करने से पहले grown-up से पूछें! 🤗'
      : '🛡️ Safety First\nAI with Shiv never asks for your real name, address, or phone number. Always ask a grown-up before sharing anything online! 🤗';
  String get aboutText => isHindi
      ? 'एक मजेदार comic learning app जहाँ Shiv बच्चों को AI safely सिखाता है.'
      : 'A fun comic learning app where Shiv helps kids learn AI safely.';
  String get nice => isHindi ? 'Nice!' : 'Nice!';

  String get languageChanged => isHindi
      ? 'Language हिन्दी हो गई! Shabash! 🌐'
      : 'Language changed to English! Shabash! 🌐';

  String get gamesSafety => isHindi
      ? 'AI games मजेदार हैं, पर personal information share करने से पहले grown-up से पूछें.'
      : 'AI games are fun, but always ask a grown-up before sharing personal information.';
  String get startGame => isHindi ? 'START GAME' : 'START GAME';
  String get completed => isHindi ? 'Completed' : 'Completed';
  String get unlocked => isHindi ? 'Unlocked' : 'Unlocked';
  String get reward => isHindi ? 'Reward' : 'Reward';
  String get concept => isHindi ? 'Concept' : 'Concept';
  String minutes(int value) => isHindi ? '$value min' : '$value min';
  String gameReward(int xp, int coins) => '⚡ $xp XP  🪙 $coins';
  String get gameReplayNoReward => isHindi
      ? 'Replay मजेदार है! Reward first win पर मिल चुका है.'
      : 'Replay is fun! Reward was already given on the first win.';
  String gameWin(int xp, int coins) => isHindi
      ? 'Shabash! आपने $xp XP और $coins coins कमाए!'
      : 'Shabash! You earned $xp XP and $coins coins!';
  String get backToGames => isHindi ? 'Games पर वापस' : 'Back to Games';
  String get playAgain => isHindi ? 'फिर खेलें' : 'Play Again';
  String get check => isHindi ? 'Check' : 'Check';
  String get next => isHindi ? 'Next' : 'Next';
  String get animal => isHindi ? 'Animal' : 'Animal';
  String get fruit => isHindi ? 'Fruit' : 'Fruit';
  String get vehicle => isHindi ? 'Vehicle' : 'Vehicle';
  String get food => isHindi ? 'Food' : 'Food';
  String get correct => isHindi ? 'Correct' : 'Correct';
  String get wrong => isHindi ? 'Wrong' : 'Wrong';
  String get algorithmTip => isHindi
      ? 'Clear steps को algorithm कहते हैं.'
      : 'A clear set of steps is called an algorithm.';
  String get trainRobotDone => isHindi
      ? 'Great! आपने ShivBot को examples से train किया.'
      : 'Great! You trained ShivBot with examples.';
  String get detectiveDone => isHindi
      ? 'Super! आपने pattern में odd item spot किया.'
      : 'Super! You spotted odd items in patterns.';
  String get sortDone => isHindi
      ? 'Shabash! आपने items को AI की तरह classify किया.'
      : 'Shabash! You classified items like AI.';
  String get treasureDone => isHindi
      ? 'Treasure मिल गया! आपके steps clear थे.'
      : 'Treasure found! Your steps were clear.';
  String get mistakeDone => isHindi
      ? 'Fact Check Hero! AI answers को check करना smart है.'
      : 'Fact Check Hero! Checking AI answers is smart.';
}
