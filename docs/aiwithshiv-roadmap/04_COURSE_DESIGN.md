# Course Design

## Purpose

Define the course framework and document the Phase 1 courses for AIWithShiv.

## Course Framework

Every course should have:

- Clear learning goal.
- Age group.
- Difficulty.
- Ten short lessons.
- One final mission.
- Three related game ideas.
- Parent value.
- Safety theme.
- XP total.

## Current Phase 1 Courses

| Course | Goal | Difficulty | Age |
| --- | --- | --- | --- |
| AI Masti Missions | Introduce AI and safe use | Beginner | 5-10 |
| Pattern Playground | Teach patterns and prediction | Beginner to easy | 5-10 |
| Teach The Robot | Introduce machine learning through examples | Easy | 5-10 |

## Course 1: AI Masti Missions

Description: Shiv introduces AI through home, school, tiffin, cricket, mangoes, Diwali, and safety examples.

Learning goal: Child understands AI as a helpful computer system that learns from examples, can make mistakes, and must be used safely.

Safety theme: Keep secrets safe and ask trusted adults.

Parent value: Child learns practical AI awareness without needing an account or internet.

Lessons:

| Order | Lesson |
| ---: | --- |
| 1 | Meet Shiv the AI Hero |
| 2 | What Is AI? |
| 3 | AI Around My Home |
| 4 | AI at School |
| 5 | Teaching AI With Examples |
| 6 | Patterns Are Like Treasure Clues |
| 7 | Asking AI Good Questions |
| 8 | AI Can Make Mistakes |
| 9 | Keep Secrets Safe |
| 10 | My First AI Hero Mission |

Course games:

- AI Helper Hunt: future game idea.
- Ask Shiv Clearly: future game idea.
- Secret Shield Mission: future game idea.

Current related existing games:

- Spot the AI Mistake.
- Robot Treasure Hunt.

## Course 2: Pattern Playground

Description: Shiv teaches patterns through rangoli colors, shapes, sounds, numbers, cricket clues, and treasure trails.

Learning goal: Child identifies repeating patterns, odd items, ordered clues, and simple predictions.

Safety theme: Smart guesses must be checked.

Parent value: Child builds early reasoning skills for AI, math, reading, and problem solving.

Lessons:

| Order | Lesson |
| ---: | --- |
| 1 | Color Patterns |
| 2 | Shape Patterns |
| 3 | Number Patterns |
| 4 | Sound Patterns |
| 5 | What Comes Next? |
| 6 | Odd One Out |
| 7 | Simple Predictions |
| 8 | Treasure Clues |
| 9 | Detective Thinking |
| 10 | Pattern Hero Mission |

Course games:

- Rangoli Pattern Pop: future game idea.
- Odd One Detective: future game idea.
- Treasure Clue Trail: future game idea.

Current related existing games:

- AI Detective.
- Robot Treasure Hunt.

## Course 3: Teach The Robot

Description: Children teach ShivBot using examples, categories, good data, bad data, sorting, prediction, recommendations, and feedback.

Learning goal: Child understands that AI learns from examples and can improve when humans provide better data and corrections.

Safety theme: Wrong data can create wrong answers.

Parent value: Child learns the basic idea behind machine learning without technical jargon.

Lessons:

| Order | Lesson |
| ---: | --- |
| 1 | Examples Teach Robots |
| 2 | Categories Are Buckets |
| 3 | Training ShivBot |
| 4 | Good Data |
| 5 | Bad Data |
| 6 | Sorting Like AI |
| 7 | Guessing From Examples |
| 8 | Recommendations |
| 9 | Learning From Mistakes |
| 10 | Robot Hero Mission |

Course games:

- Train the Robot: exists.
- Sort Like AI: exists.
- Fix Bad Data: future game idea.

## What Already Exists

- All three courses exist in `assets/data/courses.json`.
- Each course has 10 lessons.
- Course XP matches lesson XP totals.
- Learning path reads courses dynamically.

## What Is Missing

- App-level unlock rules between courses.
- Course completion certificate.
- Parent-facing course summary.
- Full Hindi course content beyond course card metadata.
- All 9 planned course games.

## Recommended Next Steps

1. Keep Phase 1 to 3 courses for first launch.
2. Add parent value text to a future parent/teacher guide.
3. Implement the four missing planned game ideas only after current 5 games are stable.

## Implementation Checklist

- [ ] Confirm each course has one clear learning outcome.
- [ ] Confirm lesson order and route behavior.
- [ ] Confirm course progress display works for 3 courses.
- [ ] Add course completion states.
- [ ] Add course certificate/copy later.

## Acceptance Criteria

- Every course can be explained to a parent in one sentence.
- Every course has 10 lessons and one final mission.
- Every course has a safety theme.
- Course design supports future expansion without changing the core model.

