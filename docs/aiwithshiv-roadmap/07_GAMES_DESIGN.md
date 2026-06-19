# Games Design

## Purpose

Define the AI mini-game system, current games, future games, rewards, replay behavior, and QA expectations.

## Current Project Understanding

Games are loaded from `assets/data/games.json`, listed at `/games`, and opened through registered GoRouter paths. Game progress is stored with SharedPreferences. Rewards are awarded only once per game completion.

## Current 5 Games

| Game | Route | AI concept |
| --- | --- | --- |
| Train the Robot | `/games/train-robot` | Machine learning |
| AI Detective | `/games/ai-detective` | Pattern recognition |
| Sort Like AI | `/games/sort-like-ai` | Classification |
| Robot Treasure Hunt | `/games/robot-treasure-hunt` | Algorithm |
| Spot the AI Mistake | `/games/spot-ai-mistake` | AI safety |

## Game 1: Train the Robot

- Goal: Teach ShivBot with correct examples.
- How to play: Child chooses examples that belong to the target concept.
- UX flow: Intro -> examples -> choices -> feedback -> completion.
- Reward: XP and coins on first completion.
- Replay logic: Replay allowed, no duplicate reward.
- Safety note: AI learns from examples but humans guide it.
- Testing checklist: route opens, completion saves, replay does not duplicate reward, Robot Trainer badge unlocks.

## Game 2: AI Detective

- Goal: Spot odd items and patterns.
- How to play: Child finds the item that does not fit.
- AI concept: Pattern recognition.
- UX flow: Detective setup -> item group -> child choice -> explanation.
- Reward: XP and coins on first completion.
- Replay logic: Replay allowed, no duplicate reward.
- Safety note: Guesses should be checked.
- Testing checklist: Pattern Detective badge unlocks, small screen layout works.

## Game 3: Sort Like AI

- Goal: Classify items into groups.
- How to play: Child sorts food, animals, vehicles, or similar examples.
- AI concept: Classification.
- UX flow: Category labels -> draggable/tappable items -> feedback -> completion.
- Reward: XP and coins on first completion.
- Replay logic: Replay allowed, no duplicate reward.
- Safety note: Wrong labels can teach AI badly.
- Testing checklist: progress saved, categories readable, no overflow.

## Game 4: Robot Treasure Hunt

- Goal: Follow steps to reach treasure.
- How to play: Child gives clear step commands.
- AI concept: Algorithm.
- UX flow: Grid/map -> commands -> robot movement -> treasure.
- Reward: XP and coins on first completion.
- Replay logic: Replay allowed, no duplicate reward.
- Safety note: Clear instructions help computers.
- Testing checklist: back button, route, completion, small device fit.

## Game 5: Spot the AI Mistake

- Goal: Check AI answers.
- How to play: Child spots silly/wrong AI responses.
- AI concept: AI can make mistakes.
- UX flow: AI answer card -> choose if correct/wrong -> explanation.
- Reward: XP and coins on first completion.
- Replay logic: Replay allowed, no duplicate reward.
- Safety note: Ask trusted adults for important answers.
- Testing checklist: safety copy, completion, no reward duplication.

## Future Course Games

| Course | Future game | Goal |
| --- | --- | --- |
| AI Masti Missions | AI Helper Hunt | Find AI helpers at home/school |
| AI Masti Missions | Ask Shiv Clearly | Practice good prompts |
| AI Masti Missions | Secret Shield Mission | Sort private vs safe info |
| Pattern Playground | Rangoli Pattern Pop | Complete visual patterns |
| Pattern Playground | Odd One Detective | Spot odd items |
| Pattern Playground | Treasure Clue Trail | Follow ordered clues |
| Teach The Robot | Fix Bad Data | Correct labels and messy examples |

## What Already Exists

- Five active game routes.
- Local game repository.
- Local game progress repository.
- Completion logic with first-win rewards.
- Game achievements for Game Starter, Pattern Detective, Robot Trainer, AI Games Hero.
- Tests for game repository, route registration, and completion.

## What Is Missing

- Full 9-game curriculum plan implemented.
- Course-to-game unlock mapping.
- Game difficulty metadata.
- Dedicated game content schema for levels/rounds.
- More visual polish QA on real devices.

## Recommended Next Steps

1. Keep current 5 games for v1 unless more time is available.
2. Add one missing safety-focused game next: Secret Shield Mission.
3. Add course game mapping after current navigation is stable.

## Implementation Checklist

- [ ] Every active game route registered.
- [ ] Every active game has test coverage.
- [ ] First completion grants XP/coins once.
- [ ] Replay grants no duplicate reward.
- [ ] Back button returns to `/games`.
- [ ] UI fits iPhone SE/small Android.

## Acceptance Criteria

- Child can open and finish every active game.
- Rewards are fair and non-duplicating.
- Games teach a real AI concept.
- Games do not interrupt learning with ads.

