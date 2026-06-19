import fs from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const dataDir = path.join(root, 'assets', 'data');

const courses = [
  {
    id: 'ai-masti-missions',
    title: 'AI Masti Missions',
    description:
      'Join Shiv, the robot-superhero dost, for funny AI missions that teach what AI is, where it helps, how to ask good questions, and how to stay safe.',
    category: 'AI Basics',
    xp: 290,
    lessons: [
      ['Meet Shiv the AI Hero', 'AI helper', 'Namaste, hero! Shiv zooms into class with a saffron cape and a glowing chest panel. He tells the learner that AI is a smart helper, not magic. Together they sort mangoes, find a missing pencil, and remember that humans stay in charge.', ['AI helper', 'Human choice', 'Shiv'], 5, 25],
      ['What Is AI?', 'Smart computer helper', 'Shiv opens a tiny comic book called AI Masti. He explains that AI means a computer can learn from examples and help with tasks. A pretend tiffin robot guesses snacks from clues and learns that good examples make it better.', ['Artificial intelligence', 'Examples', 'Learning'], 6, 25],
      ['AI Around My Home', 'AI in daily life', 'Chalo home mission! Shiv visits a family home where a phone unlocks with a face, music suggests songs, and maps help reach nani house. Shiv reminds the learner that family rules still matter.', ['Daily life', 'Smart tools', 'Family rules'], 6, 25],
      ['AI at School', 'AI as study helper', 'Shiv lands near the blackboard and turns class into a learning lab. AI can help read words, practice counting, or explain homework, but children still do the learning. Shabash for thinking!', ['School help', 'Homework', 'Teamwork'], 7, 30],
      ['Teaching AI With Examples', 'Training examples', 'Shiv brings baskets for mangoes, bananas, and cricket balls. The learner teaches a pretend AI by showing clear examples. Shiv makes a funny mistake and explains that AI learns better from correct examples.', ['Training', 'Sorting', 'Clear examples'], 7, 30],
      ['Patterns Are Like Treasure Clues', 'Patterns', 'Shiv draws a rangoli pattern: red, yellow, red, yellow. The learner spots what comes next. Shiv cheers because AI also looks for patterns in examples, but guesses still need checking.', ['Patterns', 'Prediction', 'Checking'], 6, 25],
      ['Asking AI Good Questions', 'Prompting', 'Shiv opens the Prompt Power Lunch Box. Inside are three ingredients: what you want, helpful details, and a polite question. The learner changes homework into a clear mango sharing question.', ['Prompts', 'Details', 'Polite questions'], 8, 30],
      ['AI Can Make Mistakes', 'Fact checking', 'Shiv asks a pretend AI what fruit is yellow and sweet. It shouts potato and everyone giggles. The learner becomes a Fact Check Hero and checks important answers with trusted adults.', ['Mistakes', 'Fact checking', 'Trusted adults'], 6, 30],
      ['Keep Secrets Safe', 'Digital privacy', 'Shiv activates Secret Shield. Passwords, home address, phone number, school ID, and private photos are not for AI chats. The learner practices sharing safe learning questions instead.', ['Privacy', 'Passwords', 'Safe sharing'], 7, 30],
      ['My First AI Hero Mission', 'Responsible AI use', 'It is final mission day! Shiv asks the learner to use all hero powers: AI helper, clear examples, patterns, good questions, checking mistakes, and keeping secrets safe during a Diwali rangoli plan.', ['Review', 'Safe AI', 'Hero mission'], 8, 40],
    ],
  },
  {
    id: 'pattern-playground',
    title: 'Pattern Playground',
    description:
      'Explore rangoli colors, shapes, sounds, numbers, treasure clues, and detective thinking with Shiv.',
    category: 'Patterns',
    xp: 255,
    lessons: [
      ['Color Patterns', 'Visual patterns', 'Shiv builds a rangoli color path with red, yellow, red, yellow. The learner taps the next color and sees how repeating clues help the brain guess.', ['Colors', 'Repeating patterns', 'Rangoli'], 5, 20],
      ['Shape Patterns', 'Shape sequences', 'Shiv decorates the classroom with circles, squares, circles, squares. The learner finds the missing shape and learns that shapes can make patterns too.', ['Shapes', 'Sequences', 'Missing clue'], 5, 20],
      ['Number Patterns', 'Number sequence', 'Shiv fills mango baskets with 2, 4, 6, and 8 mangoes. The learner spots the counting jump and predicts the next basket.', ['Numbers', 'Counting', 'Prediction'], 6, 25],
      ['Sound Patterns', 'Audio patterns', 'Shiv makes a tabla and clap rhythm: clap, tap, clap, tap. The learner listens and repeats the next sound like a rhythm hero.', ['Sounds', 'Rhythm', 'Listening'], 6, 25],
      ['What Comes Next?', 'Prediction', 'Festival lights blink diya, star, diya, star. Shiv asks the learner to predict the next light and explains that predictions are smart guesses from clues.', ['Prediction', 'Clues', 'Festival lights'], 6, 25],
      ['Odd One Out', 'Difference spotting', 'Shiv becomes a detective and shows mango, apple, banana, and bus. The learner spots the bus because it does not belong with fruits.', ['Odd one out', 'Groups', 'Detective thinking'], 6, 25],
      ['Simple Predictions', 'Guessing from clues', 'Shiv watches a cricket ball roll toward a bat and asks what might happen next. The learner learns predictions can be helpful but not always perfect.', ['Simple prediction', 'Cricket', 'Checking'], 6, 25],
      ['Treasure Clues', 'Step-by-step clues', 'Shiv follows a map that says go to the blue door, then the yellow star. The learner follows clues in order to reach treasure.', ['Treasure clues', 'Order', 'Map'], 7, 30],
      ['Detective Thinking', 'Reasoning', 'A tiffin spoon goes missing. Shiv asks the learner to look at clues before guessing, because good thinkers check evidence.', ['Reasoning', 'Evidence', 'Careful thinking'], 7, 30],
      ['Pattern Hero Mission', 'Pattern mastery', 'Shiv opens the festival playground challenge. The learner completes colors, shapes, numbers, sounds, odd-one-out, and treasure clues to become a Pattern Hero.', ['Pattern review', 'Mission', 'Hero thinking'], 8, 30],
    ],
  },
  {
    id: 'teach-the-robot',
    title: 'Teach The Robot',
    description:
      'Help ShivBot learn from examples, categories, good data, mistakes, sorting, and recommendations.',
    category: 'Machine Learning',
    xp: 260,
    lessons: [
      ['Examples Teach Robots', 'Examples', 'ShivBot wants to learn fruits. Shiv shows mango, apple, and banana cards. The learner discovers that examples help robots understand new things.', ['Examples', 'Learning', 'Fruits'], 5, 20],
      ['Categories Are Buckets', 'Categories', 'Shiv brings buckets labeled animals, food, and vehicles. Dog goes in animals, pizza goes in food, and bus goes in vehicles.', ['Categories', 'Groups', 'Buckets'], 5, 20],
      ['Training ShivBot', 'Training', 'ShivBot practices again and again with many examples. The learner sees that training means showing enough clear examples for ShivBot to learn.', ['Training', 'Practice', 'Many examples'], 6, 25],
      ['Good Data', 'Good data', 'Shiv cleans messy flashcards. A clear mango picture with the right label helps ShivBot learn, so the learner chooses the best examples.', ['Good data', 'Clear labels', 'Quality'], 6, 25],
      ['Bad Data', 'Bad data', 'Oh no! ShivBot thinks a cricket ball is a mango because a card had the wrong label. The learner fixes confusing data.', ['Bad data', 'Wrong labels', 'Mistakes'], 6, 25],
      ['Sorting Like AI', 'Classification', 'ShivBot sorts tiffin snacks, toys, and vehicles. The learner practices putting items into the right groups like a mini AI trainer.', ['Classification', 'Sorting', 'Groups'], 6, 25],
      ['Guessing From Examples', 'Prediction from examples', 'After seeing many fruits, ShivBot guesses that a yellow curved item may be a banana. Shiv explains that AI guesses from examples.', ['Prediction', 'Examples', 'Guessing'], 7, 30],
      ['Recommendations', 'Suggestions', 'Shiv suggests a cricket story because the learner liked cricket stories before. The learner sees that recommendations use patterns in choices.', ['Recommendations', 'Preferences', 'Suggestions'], 7, 30],
      ['Learning From Mistakes', 'Feedback', 'ShivBot makes a silly mistake and the learner corrects it kindly. Shiv explains that feedback helps smart helpers improve.', ['Feedback', 'Correction', 'Improvement'], 7, 30],
      ['Robot Hero Mission', 'Machine learning review', 'The school fair is here! The learner trains ShivBot with examples, categories, good data, sorting, predictions, and corrections to finish the Robot Hero Mission.', ['Review', 'Robot training', 'AI hero'], 8, 30],
    ],
  },
];

const quizzesByLessonTitle = {
  'Meet Shiv the AI Hero': [
    ['Who is Shiv in the app?', ['A friendly robot-superhero tutor', 'A scary exam robot', 'A secret password keeper', 'A cricket umpire'], 0, 'Shiv is a friendly robot-superhero tutor who helps kids learn.'],
    ['Who stays in charge when using AI?', ['Humans', 'Passwords', 'Unknown pop-ups', 'Only robots'], 0, 'Humans stay in charge and make smart choices.'],
  ],
  'What Is AI?': [
    ['AI is like what for kids?', ['A smart computer helper', 'A magic wand', 'A lunch box', 'A school bus'], 0, 'AI is a smart computer helper, not magic.'],
    ['What can help AI learn?', ['Examples', 'Secrets', 'Angry shouting', 'No clues'], 0, 'AI learns better from clear examples.'],
  ],
  'AI Around My Home': [
    ['Which home tool can use AI?', ['A song app suggesting music', 'A plain spoon', 'A pencil eraser', 'A cricket stump'], 0, 'Some apps use AI to suggest helpful choices.'],
    ['What should still guide tech at home?', ['Family rules', 'Random strangers', 'Secret codes', 'Silly guesses only'], 0, 'Family rules help children use technology safely.'],
  ],
  'AI at School': [
    ['How can AI help at school?', ['Practice reading words', 'Do all learning for you', 'Hide homework', 'Share school ID'], 0, 'AI can help practice, but the child still learns.'],
    ['What should a learner do with AI help?', ['Think and try', 'Stop learning', 'Copy without checking', 'Share passwords'], 0, 'Shabash! A learner thinks, tries, and checks.'],
  ],
  'Teaching AI With Examples': [
    ['What should you show a pretend fruit AI?', ['Clear fruit examples', 'Wrong labels', 'Private photos', 'No examples'], 0, 'Clear examples help AI learn the right idea.'],
    ['If AI makes a funny mistake, what helps?', ['Better examples', 'More secrets', 'No checking', 'Closing your eyes'], 0, 'Better examples can help AI improve.'],
  ],
  'Patterns Are Like Treasure Clues': [
    ['What comes after red, yellow, red, yellow?', ['Red', 'Bus', 'Dog', 'Phone'], 0, 'The color pattern repeats red and yellow.'],
    ['Why does Shiv like patterns?', ['They are clues for guesses', 'They are passwords', 'They hide homework', 'They stop thinking'], 0, 'Patterns help us make smart guesses.'],
  ],
  'Asking AI Good Questions': [
    ['Which question is clearer?', ['How do I share 6 mangoes with 3 friends?', 'Help', 'Thing mango fast', 'Secret password please'], 0, 'A clear question gives useful details.'],
    ['What belongs in a good AI question?', ['What you want and helpful details', 'Home address', 'Phone number', 'Only emojis'], 0, 'Good questions include the goal and safe details.'],
  ],
  'AI Can Make Mistakes': [
    ['If AI says a potato is a fruit, what should you do?', ['Check the answer', 'Believe it always', 'Share a password', 'Never ask adults'], 0, 'AI can make mistakes, so important answers need checking.'],
    ['Who can help check important answers?', ['Trusted adult', 'Unknown stranger', 'Random pop-up', 'Silly robot only'], 0, 'Trusted adults help children check important answers.'],
  ],
  'Keep Secrets Safe': [
    ['Which thing should stay private?', ['Password', 'Favorite mango', 'Safe joke', 'Drawing of a star'], 0, 'Passwords and private details should stay safe.'],
    ['What is safe to ask ShivBot?', ['Explain patterns with mangoes', 'My home address is...', 'My phone number is...', 'Here is my password'], 0, 'Safe learning questions do not include private details.'],
  ],
  'My First AI Hero Mission': [
    ['Which is an AI Hero habit?', ['Ask clearly and check answers', 'Share secrets', 'Trust every answer', 'Ignore grown-ups'], 0, 'AI Heroes ask clearly, check answers, and stay safe.'],
    ['What should you keep safe during an AI chat?', ['Private information', 'A mango color', 'A rangoli shape', 'A cricket score'], 0, 'Private information should not be shared in AI chats.'],
  ],
  'Color Patterns': [
    ['Where can you see a color pattern?', ['Rangoli', 'Password box', 'Phone number', 'Address card'], 0, 'Rangoli can use repeating color patterns.'],
    ['What helps find the next color?', ['Look at the repeat', 'Close your eyes', 'Share secrets', 'Guess any word'], 0, 'Repeating clues help us find what comes next.'],
  ],
  'Shape Patterns': [
    ['What comes after circle, square, circle, square?', ['Circle', 'Mango', 'Tabla', 'Bus'], 0, 'The shape pattern repeats circle and square.'],
    ['Which item is a shape?', ['Triangle', 'Tiffin', 'Homework', 'Cricket'], 0, 'Triangle is a shape.'],
  ],
  'Number Patterns': [
    ['What comes after 2, 4, 6, 8?', ['10', '3', 'Mango', 'Red'], 0, 'The numbers jump by 2 each time.'],
    ['Number patterns help us do what?', ['Predict the next number', 'Share a phone number', 'Forget counting', 'Hide pencils'], 0, 'Number patterns help us predict what may come next.'],
  ],
  'Sound Patterns': [
    ['What comes after clap, tap, clap, tap?', ['Clap', 'Bus', 'Mango', 'Star'], 0, 'The sound pattern repeats clap and tap.'],
    ['Which sense helps with sound patterns?', ['Listening', 'Smelling', 'Running', 'Sleeping'], 0, 'Listening helps us notice sound patterns.'],
  ],
  'What Comes Next?': [
    ['Diya, star, diya, star. What comes next?', ['Diya', 'Phone', 'Dog', 'Pencil'], 0, 'The festival light pattern repeats diya and star.'],
    ['A prediction is what?', ['A smart guess from clues', 'A private password', 'A scary rule', 'A hidden address'], 0, 'Predictions are smart guesses from clues.'],
  ],
  'Odd One Out': [
    ['Which item is odd: mango, apple, banana, bus?', ['Bus', 'Mango', 'Apple', 'Banana'], 0, 'Bus is a vehicle. The others are fruits.'],
    ['Odd one out means what?', ['Item that does not fit', 'Best secret', 'Longest word', 'Fastest car'], 0, 'The odd item does not fit the group.'],
  ],
  'Simple Predictions': [
    ['A ball rolls toward a bat. What might happen?', ['The bat may hit it', 'It becomes a password', 'It turns into homework', 'It calls a phone'], 0, 'A prediction uses clues to guess what may happen.'],
    ['Are predictions always perfect?', ['No, we should check', 'Yes, always', 'Only on Diwali', 'Only with mangoes'], 0, 'Predictions can be helpful but still need checking.'],
  ],
  'Treasure Clues': [
    ['Why should clues be followed in order?', ['Order helps reach the goal', 'Order hides secrets', 'Order stops learning', 'Order shares address'], 0, 'Step-by-step clues help us reach the goal.'],
    ['Which is a good treasure clue?', ['Go to the blue door', 'Tell your password', 'Forget the map', 'Pick any secret'], 0, 'A good clue gives a clear safe step.'],
  ],
  'Detective Thinking': [
    ['Before guessing, a detective should look for what?', ['Evidence', 'Passwords', 'Random pop-ups', 'Private photos'], 0, 'Evidence helps us make better guesses.'],
    ['If the tiffin spoon is missing, what helps?', ['Checking clues', 'Blaming quickly', 'Ignoring facts', 'Sharing address'], 0, 'Careful thinkers check clues before guessing.'],
  ],
  'Pattern Hero Mission': [
    ['Which skill belongs to a Pattern Hero?', ['Finding what comes next', 'Sharing secrets', 'Never checking', 'Forgetting clues'], 0, 'Pattern Heroes use clues to find what comes next.'],
    ['What should you do with important pattern guesses?', ['Check them', 'Trust them always', 'Hide them', 'Turn off thinking'], 0, 'Important guesses should be checked.'],
  ],
  'Examples Teach Robots': [
    ['What helps ShivBot learn fruits?', ['Fruit examples', 'No pictures', 'Secret numbers', 'Wrong names'], 0, 'Fruit examples help ShivBot learn fruits.'],
    ['Which is a fruit example?', ['Mango', 'Bus', 'Shoe', 'Pencil'], 0, 'Mango is a fruit example.'],
  ],
  'Categories Are Buckets': [
    ['Where does a dog belong?', ['Animals', 'Food', 'Vehicles', 'Passwords'], 0, 'Dog belongs in the animals category.'],
    ['What is a category?', ['A group for similar things', 'A secret code', 'A phone number', 'A scary rule'], 0, 'A category groups similar things together.'],
  ],
  'Training ShivBot': [
    ['Training ShivBot means what?', ['Showing many examples', 'Giving no examples', 'Sharing address', 'Closing the app'], 0, 'Training means learning from examples.'],
    ['What kind of examples are best?', ['Clear and correct', 'Wrong and messy', 'Private passwords', 'No labels'], 0, 'Clear and correct examples help AI learn.'],
  ],
  'Good Data': [
    ['Which data helps ShivBot most?', ['Clear mango card with right label', 'Blurry card with wrong label', 'Password list', 'No label at all'], 0, 'Good data is clear and correctly labeled.'],
    ['Good data should be what?', ['Clear and correct', 'Private and secret', 'Wrong and confusing', 'Always empty'], 0, 'Good data helps AI learn safely and correctly.'],
  ],
  'Bad Data': [
    ['What can bad data cause?', ['Mistakes', 'Magic', 'Perfect answers', 'No learning ever'], 0, 'Bad data can cause wrong AI answers.'],
    ['What should we do with wrong labels?', ['Fix them', 'Hide them', 'Share them online', 'Ignore safety'], 0, 'Fixing wrong labels helps ShivBot improve.'],
  ],
  'Sorting Like AI': [
    ['Where should a bus go?', ['Vehicles', 'Fruits', 'Animals', 'Passwords'], 0, 'Bus belongs with vehicles.'],
    ['Sorting helps AI do what?', ['Put things into groups', 'Collect secrets', 'Forget examples', 'Stop learning'], 0, 'Sorting teaches groups and categories.'],
  ],
  'Guessing From Examples': [
    ['A yellow curved fruit may be what?', ['Banana', 'Cricket bat', 'School bus', 'Notebook'], 0, 'AI can guess banana from examples and clues.'],
    ['AI guesses from what?', ['Examples', 'Secrets', 'No clues', 'Angry faces'], 0, 'AI uses examples to make guesses.'],
  ],
  'Recommendations': [
    ['If you like cricket stories, Shiv may suggest what?', ['Another cricket story', 'A password', 'A random address', 'A private photo'], 0, 'Recommendations use patterns in choices.'],
    ['A recommendation is what?', ['A helpful suggestion', 'A secret rule', 'A phone number', 'A wrong label'], 0, 'A recommendation is a suggestion based on clues.'],
  ],
  'Learning From Mistakes': [
    ['What helps ShivBot improve after a mistake?', ['Kind correction', 'More wrong labels', 'Private info', 'No feedback'], 0, 'Feedback and correction help ShivBot improve.'],
    ['How should we fix AI mistakes?', ['Check and correct kindly', 'Laugh and ignore always', 'Share secrets', 'Stop learning'], 0, 'Checking and correcting helps AI learn better.'],
  ],
  'Robot Hero Mission': [
    ['What does a Robot Hero use to train ShivBot?', ['Examples and good data', 'Passwords and addresses', 'No labels', 'Random shouting'], 0, 'Examples and good data help train ShivBot.'],
    ['Which habit keeps AI learning safe?', ['Check mistakes', 'Trust every guess', 'Use bad data', 'Share private photos'], 0, 'Checking mistakes keeps AI learning safer.'],
  ],
};

function lessonId(courseId, index) {
  return `${courseId}-lesson-${String(index + 1).padStart(2, '0')}`;
}

const generatedCourses = courses.map((course) => ({
  id: course.id,
  title: course.title,
  description: course.description,
  category: course.category,
  ageGroups: ['kids'],
  lessonIds: course.lessons.map((_, index) => lessonId(course.id, index)),
  imageUrl: '',
  xp: course.xp,
}));

const lessons = courses.flatMap((course) =>
  course.lessons.map(([title, concept, story, concepts, durationMinutes, xp], index) => ({
    id: lessonId(course.id, index),
    courseId: course.id,
    title,
    story,
    concepts,
    durationMinutes,
    xp,
    order: index + 1,
  })),
);

const quizzes = lessons.map((lesson) => {
  const baseQuestions = quizzesByLessonTitle[lesson.title];
  if (!baseQuestions) {
    throw new Error(`Missing quiz questions for lesson: ${lesson.title}`);
  }
  return {
    id: `${lesson.id}-quiz`,
    lessonId: lesson.id,
    title: `${lesson.title} Checkpoint`,
    questions: baseQuestions.map(([prompt, options, answerIndex, explanation], index) => ({
      id: `${lesson.id}-q${index + 1}`,
      prompt,
      options,
      answerIndex,
      correctAnswerIndexes: [answerIndex],
      explanation,
    })),
  };
});

const achievements = [
  ['first-spark', 'First Spark', 'Complete your first lesson.', 'bolt', 20],
  ['quiz-champ', 'Quiz Champ', 'Complete your first quiz.', 'school', 40],
  ['game-starter', 'Game Starter', 'Complete your first AI game.', 'sports_esports', 99999],
  ['hundred-xp-hero', '100 XP Hero', 'Earn 100 XP.', 'bolt', 100],
  ['pattern-detective', 'Pattern Detective', 'Spot patterns and odd items like a detective.', 'search', 250],
  ['robot-trainer', 'Robot Trainer', 'Train ShivBot using examples.', 'smart_toy', 500],
  ['safety-hero', 'Safety Hero', 'Learn how to protect private information.', 'shield', 800],
  ['five-hundred-xp-legend', '500 XP Legend', 'Earn 500 XP.', 'emoji_events', 500],
  ['course-champion', 'Course Champion', 'Complete one full course.', 'emoji_events', 99999],
  ['ai-world-explorer', 'AI World Explorer', 'Complete all 30 Phase 1 lessons.', 'travel_explore', 99999],
  ['ai-games-hero', 'AI Games Hero', 'Complete all AI games.', 'emoji_events', 99999],
  ['ai-master', 'AI Master', 'Complete the Phase 1 AI Hero journey.', 'workspace_premium', 1700],
].map(([id, title, description, icon, requiredXp]) => ({
  id,
  title,
  description,
  icon,
  requiredXp,
}));

for (const [file, data] of [
  ['courses.json', generatedCourses],
  ['lessons.json', lessons],
  ['quizzes.json', quizzes],
  ['achievements.json', achievements],
]) {
  fs.writeFileSync(path.join(dataDir, file), `${JSON.stringify(data, null, 2)}\n`);
}

console.log(`Generated ${generatedCourses.length} courses, ${lessons.length} lessons, ${quizzes.length} quizzes, ${achievements.length} achievements.`);
