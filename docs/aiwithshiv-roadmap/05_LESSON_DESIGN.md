# Lesson Design

## Purpose

Define how every AIWithShiv lesson should be written, structured, voiced, tested, and reviewed.

## Required Lesson Flow

Every lesson follows:

Story -> Concept -> Example -> Activity -> Quiz -> Reward -> Real-life habit

## Current Project Understanding

Lessons are loaded from `assets/data/lessons.json` and rendered by `LessonScreen`. The screen splits the `story` into panels, shows concepts as chips, supports TTS reading, and unlocks quiz after reading progress.

## Lesson Template

| Section | Requirement |
| --- | --- |
| Title | Short, playful, sentence case |
| Story | 3-6 simple sentences |
| Concept | One main AI idea |
| Example | Indian child-friendly example |
| Activity | Tap, think, sort, choose, spot, predict |
| Safety | Include where relevant |
| Quiz | One checkpoint quiz with 2 questions |
| Reward | XP and coins through quiz/game completion |
| Habit | One real-life takeaway |

## Comic Panel Structure

Recommended story panels:

1. Shiv enters with a funny mission.
2. Child sees a real-life example.
3. Shiv explains one simple AI concept.
4. Child practices with a tiny activity.
5. Shiv gives a safety or thinking habit.

## Voice Narration Format

- Use short sentences.
- Avoid long clauses.
- Use friendly Indian English.
- Include occasional Hindi words: Namaste, Shabash, Chalo, Dost, Masti.
- Keep pronunciation simple for TTS.
- Avoid too many emojis inside narrated text.

## Reading Level Rules

| Rule | Target |
| --- | --- |
| Sentence length | Mostly under 14 words |
| Paragraph length | 1-3 sentences |
| Concepts per lesson | 1 main, 2 supporting |
| Vocabulary | Concrete, familiar, playful |
| Examples | School, home, tiffin, mango, cricket, Diwali, friends |

## Safety Reminder Rules

Use safety reminders when lessons mention:

- AI chat.
- Online questions.
- Personal information.
- Photos.
- Phone or address.
- Important answers.

Safety reminder style:

"Ask a trusted grown-up before sharing private things."

## JSON Example

```json
{
  "id": "pattern-playground-lesson-06",
  "courseId": "pattern-playground",
  "title": "Odd One Out",
  "story": "Shiv becomes a detective and shows mango, apple, banana, and bus. The learner spots the bus because it does not belong with fruits.",
  "concepts": ["Odd one out", "Groups", "Detective thinking"],
  "durationMinutes": 6,
  "xp": 25,
  "order": 6
}
```

## What Already Exists

- 30 lessons.
- Story-based lesson screen.
- Voice reading.
- Concept chips.
- Quiz unlock based on reading progress.
- Comic UI.

## What Is Missing

- Explicit activity field in JSON.
- Explicit safety note field in JSON.
- Lesson content QA status.
- Hindi translations for all lessons.
- Audio narration QA across devices.

## Recommended Next Steps

1. Keep current schema for v1 to avoid app churn.
2. Add activity/safety metadata in docs first.
3. Consider JSON schema expansion after launch.
4. Add a content QA checklist per lesson.

## Implementation Checklist

- [ ] Check each lesson has one learning objective.
- [ ] Check each lesson uses child-friendly examples.
- [ ] Check each story is short enough for TTS.
- [ ] Check safety lessons avoid fear.
- [ ] Check quiz matches lesson content.
- [ ] Check Hindi adaptation later.

## Acceptance Criteria

- A 5-10 year old can understand the lesson with minimal adult help.
- Shiv sounds kind, funny, and protective.
- The lesson teaches one AI idea clearly.
- The lesson does not ask for private data.
- The lesson leads naturally to its quiz.

