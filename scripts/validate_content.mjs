import fs from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const dataDir = path.join(root, 'assets', 'data');

const expectedRoutes = new Set([
  '/games',
  '/games/train-robot',
  '/games/ai-detective',
  '/games/sort-like-ai',
  '/games/robot-treasure-hunt',
  '/games/spot-ai-mistake',
]);

const files = {
  courses: 'courses.json',
  lessons: 'lessons.json',
  quizzes: 'quizzes.json',
  games: 'games.json',
  achievements: 'achievements.json',
  rewards: 'rewards.json',
};

const errors = [];
const warnings = [];

function readJson(name) {
  const filePath = path.join(dataDir, files[name]);
  try {
    const decoded = JSON.parse(fs.readFileSync(filePath, 'utf8'));
    if (!Array.isArray(decoded)) {
      errors.push(`${files[name]} must contain a JSON array.`);
      return [];
    }
    return decoded;
  } catch (error) {
    errors.push(`${files[name]} could not be parsed: ${error.message}`);
    return [];
  }
}

function requireString(item, field, label) {
  if (typeof item[field] !== 'string' || item[field].trim() === '') {
    errors.push(`${label}.${field} must be a non-empty string.`);
  }
}

function requireInteger(item, field, label, { min = 0, max = Number.MAX_SAFE_INTEGER } = {}) {
  if (!Number.isInteger(item[field]) || item[field] < min || item[field] > max) {
    errors.push(`${label}.${field} must be an integer from ${min} to ${max}.`);
  }
}

function requireUnique(items, type) {
  const seen = new Set();
  for (const item of items) {
    if (typeof item.id !== 'string' || item.id.trim() === '') {
      errors.push(`${type} item is missing a valid id.`);
      continue;
    }
    if (seen.has(item.id)) errors.push(`${type} has duplicate id: ${item.id}`);
    seen.add(item.id);
  }
  return seen;
}

const courses = readJson('courses');
const lessons = readJson('lessons');
const quizzes = readJson('quizzes');
const games = readJson('games');
const achievements = readJson('achievements');
const rewards = readJson('rewards');

const courseIds = requireUnique(courses, 'courses');
const lessonIds = requireUnique(lessons, 'lessons');
const quizIds = requireUnique(quizzes, 'quizzes');
const gameIds = requireUnique(games, 'games');
const achievementIds = requireUnique(achievements, 'achievements');
const rewardIds = requireUnique(rewards, 'rewards');

for (const course of courses) {
  const label = `course(${course.id ?? 'missing-id'})`;
  requireString(course, 'title', label);
  requireString(course, 'description', label);
  requireString(course, 'category', label);
  requireInteger(course, 'xp', label, { min: 1 });
  if (!Array.isArray(course.ageGroups) || !course.ageGroups.includes('kids')) {
    errors.push(`${label}.ageGroups must include "kids".`);
  }
  if (!Array.isArray(course.lessonIds) || course.lessonIds.length !== 10) {
    errors.push(`${label}.lessonIds must contain exactly 10 lesson ids.`);
  }
  const courseLessons = lessons.filter((lesson) => lesson.courseId === course.id);
  if (courseLessons.length !== 10) {
    errors.push(`${label} must have exactly 10 matching lessons; found ${courseLessons.length}.`);
  }
  const xpTotal = courseLessons.reduce((sum, lesson) => sum + (lesson.xp ?? 0), 0);
  if (course.xp !== xpTotal) {
    errors.push(`${label}.xp (${course.xp}) must equal lesson XP total (${xpTotal}).`);
  }
  for (const lessonId of course.lessonIds ?? []) {
    if (!lessonIds.has(lessonId)) errors.push(`${label} references missing lesson: ${lessonId}`);
  }
}

for (const lesson of lessons) {
  const label = `lesson(${lesson.id ?? 'missing-id'})`;
  requireString(lesson, 'courseId', label);
  requireString(lesson, 'title', label);
  requireString(lesson, 'story', label);
  requireInteger(lesson, 'durationMinutes', label, { min: 5, max: 8 });
  requireInteger(lesson, 'xp', label, { min: 20, max: 40 });
  requireInteger(lesson, 'order', label, { min: 1, max: 10 });
  if (!courseIds.has(lesson.courseId)) errors.push(`${label} references missing course: ${lesson.courseId}`);
  if (!Array.isArray(lesson.concepts) || lesson.concepts.length === 0) {
    errors.push(`${label}.concepts must contain at least one concept.`);
  }
  const expectedId = `${lesson.courseId}-lesson-${String(lesson.order).padStart(2, '0')}`;
  if (lesson.id !== expectedId) {
    errors.push(`${label}.id should be ${expectedId} for Phase 1 naming consistency.`);
  }
}

const quizzesByLesson = new Map();
for (const quiz of quizzes) {
  const label = `quiz(${quiz.id ?? 'missing-id'})`;
  requireString(quiz, 'lessonId', label);
  requireString(quiz, 'title', label);
  if (!lessonIds.has(quiz.lessonId)) errors.push(`${label} references missing lesson: ${quiz.lessonId}`);
  quizzesByLesson.set(quiz.lessonId, (quizzesByLesson.get(quiz.lessonId) ?? 0) + 1);
  if (!Array.isArray(quiz.questions) || quiz.questions.length !== 2) {
    errors.push(`${label}.questions must contain exactly 2 questions.`);
    continue;
  }
  for (const [index, question] of quiz.questions.entries()) {
    const questionLabel = `${label}.questions[${index}]`;
    requireString(question, 'id', questionLabel);
    requireString(question, 'prompt', questionLabel);
    requireString(question, 'explanation', questionLabel);
    if (!Array.isArray(question.options) || question.options.length !== 4) {
      errors.push(`${questionLabel}.options must contain exactly 4 options.`);
      continue;
    }
    requireInteger(question, 'answerIndex', questionLabel, { min: 0, max: question.options.length - 1 });
    if (!Array.isArray(question.correctAnswerIndexes) || question.correctAnswerIndexes.length === 0) {
      errors.push(`${questionLabel}.correctAnswerIndexes must contain at least one answer.`);
    } else {
      for (const answer of question.correctAnswerIndexes) {
        if (!Number.isInteger(answer) || answer < 0 || answer >= question.options.length) {
          errors.push(`${questionLabel}.correctAnswerIndexes contains invalid option index: ${answer}`);
        }
      }
      if (!question.correctAnswerIndexes.includes(question.answerIndex)) {
        errors.push(`${questionLabel}.answerIndex must be included in correctAnswerIndexes.`);
      }
    }
  }
}

for (const lessonId of lessonIds) {
  const count = quizzesByLesson.get(lessonId) ?? 0;
  if (count !== 1) errors.push(`lesson(${lessonId}) must have exactly one quiz; found ${count}.`);
}

for (const game of games) {
  const label = `game(${game.id ?? 'missing-id'})`;
  requireString(game, 'title', label);
  requireString(game, 'concept', label);
  requireString(game, 'description', label);
  requireString(game, 'route', label);
  requireInteger(game, 'durationMinutes', label, { min: 1, max: 10 });
  requireInteger(game, 'xpReward', label, { min: 1, max: 50 });
  requireInteger(game, 'coinReward', label, { min: 0, max: 50 });
  if (game.isActive !== true && game.isActive !== false) {
    errors.push(`${label}.isActive must be boolean.`);
  }
  if (game.isActive === true && !expectedRoutes.has(game.route)) {
    errors.push(`${label}.route is not a known registered route: ${game.route}`);
  }
}

for (const achievement of achievements) {
  const label = `achievement(${achievement.id ?? 'missing-id'})`;
  requireString(achievement, 'title', label);
  requireString(achievement, 'description', label);
  requireString(achievement, 'icon', label);
  requireInteger(achievement, 'requiredXp', label, { min: 0 });
}

for (const reward of rewards) {
  const label = `reward(${reward.id ?? 'missing-id'})`;
  requireString(reward, 'title', label);
  requireString(reward, 'trigger', label);
  requireInteger(reward, 'coins', label, { min: 1, max: 500 });
}

const repeatedPrompts = new Map();
for (const quiz of quizzes) {
  for (const question of quiz.questions ?? []) {
    if (typeof question.prompt === 'string') {
      repeatedPrompts.set(question.prompt, (repeatedPrompts.get(question.prompt) ?? 0) + 1);
    }
  }
}
for (const [prompt, count] of repeatedPrompts) {
  if (count > 5) warnings.push(`Quiz prompt repeats ${count} times: "${prompt}"`);
}

const counts = {
  courses: courses.length,
  lessons: lessons.length,
  quizzes: quizzes.length,
  games: games.length,
  achievements: achievements.length,
  rewards: rewards.length,
};

console.log(`Content counts: ${JSON.stringify(counts)}`);
if (warnings.length > 0) {
  console.log('\nWarnings:');
  for (const warning of warnings) console.log(`- ${warning}`);
}
if (errors.length > 0) {
  console.error('\nContent validation failed:');
  for (const error of errors) console.error(`- ${error}`);
  process.exit(1);
}

console.log('Content validation passed.');
