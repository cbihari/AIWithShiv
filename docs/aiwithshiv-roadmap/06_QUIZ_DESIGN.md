# Quiz Design

## Purpose

Define the quiz checkpoint system for child-friendly learning and reward progression.

## Current Project Understanding

Each lesson has one quiz loaded from `assets/data/quizzes.json`. `QuizScreen` supports question-by-question flow, answer checking, TTS question reading, feedback, and completion rewards.

## Phase 1 Quiz Format

| Rule | Value |
| --- | --- |
| Quizzes per lesson | 1 |
| Questions per quiz | 2 |
| Options per question | 4 |
| Correct answer count | Usually 1 |
| Tone | Encouraging, never shaming |
| Feedback | Short explanation |

## Option Writing Rules

- Correct answer should be clearly right for a child.
- Wrong answers should be obviously wrong but not silly in a confusing way.
- Avoid scary/adult/political/private-data examples.
- Keep options short.
- Do not use trick questions for ages 5-10.
- Avoid "all of the above" for Phase 1.

## Wrong Answer Feedback Rules

Wrong feedback should:

- Tell the correct answer.
- Encourage retry.
- Avoid blame.
- Keep the child motivated.

Example:

"Oops! The answer was Clear examples. Shiv learns better from good examples."

## Future Multiple Choice Support

The model already supports `correctAnswerIndexes`. Future quizzes can support multiple answers, but Phase 1 should mostly stay single-answer to reduce cognitive load.

## Difficulty Scaling

| Level | Question type |
| --- | --- |
| Easy | Identify a safe/correct item |
| Medium | Apply concept to a new example |
| Hard future | Choose multiple correct habits |

## Quiz JSON Schema

```json
{
  "id": "teach-the-robot-lesson-03-quiz",
  "lessonId": "teach-the-robot-lesson-03",
  "title": "Training ShivBot Checkpoint",
  "questions": [
    {
      "id": "teach-the-robot-lesson-03-q1",
      "prompt": "Training ShivBot means what?",
      "options": ["Showing many examples", "Giving no examples", "Sharing address", "Closing the app"],
      "answerIndex": 0,
      "correctAnswerIndexes": [0],
      "explanation": "Training means learning from examples."
    }
  ]
}
```

## What Already Exists

- 30 quizzes.
- 2-question format.
- Four options per current question.
- XP and coins based on score.
- TTS question reading.
- Unit tests for quiz view model.

## What Is Missing

- Content-level quiz QA script.
- Question difficulty labels.
- Hindi coverage for all quiz questions.
- More varied question templates for courses 2 and 3.
- Duplicate quiz wording review.

## Recommended Next Steps

1. Review all 60 Phase 1 questions manually.
2. Improve variety where default repeated questions appear.
3. Add Hindi adaptations.
4. Add JSON validation test.

## Implementation Checklist

- [ ] Validate every quiz has 2 questions.
- [ ] Validate every question has 4 options.
- [ ] Validate answer index is in range.
- [ ] Validate explanation exists.
- [ ] Validate prompt is child-friendly.
- [ ] Validate no private-data collection.

## Acceptance Criteria

- Quiz is fair after the lesson.
- Child can answer without reading adult-level language.
- Wrong answers teach, not punish.
- Quiz completion updates progress reliably.

