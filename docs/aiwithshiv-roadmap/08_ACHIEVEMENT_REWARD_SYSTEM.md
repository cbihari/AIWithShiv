# Achievement and Reward System

## Purpose

Define XP, coins, streaks, badges, trophies, levels, avatar unlocks, themes, frames, shop logic, and reward fairness rules.

## Current Project Understanding

The app stores progress in SharedPreferences. Lessons/quizzes/games award XP and coins. Achievements load from local JSON. Some game-specific badges are unlocked by game completion logic.

## Current Reward Types

| Reward | Current support |
| --- | --- |
| XP | Supported |
| Coins | Supported |
| Streak | Supported |
| Badges | Supported |
| Trophy room | Supported |
| Shop items | Supported |
| Avatar themes/frames | Partially supported |
| Certificates | Missing |

## XP Balance

| Activity | Current/Recommended |
| --- | --- |
| Lesson quiz question | 20 XP per correct answer |
| Game first completion | 15-25 XP |
| Lesson content XP | Stored in lesson JSON |
| Course completion bonus | Missing |
| Daily streak bonus | Future |

## Coin Balance

| Activity | Current/Recommended |
| --- | --- |
| Quiz question | 10 coins per correct answer |
| Game first completion | 8-12 coins |
| Lesson completion | Current gamification service can add coins |
| Rewarded ad bonus | Optional only, hidden when ads disabled |
| Replay | No duplicate coins |

## Level System

Current code computes level using XP thresholds around 250 XP in gamification paths. Some UI text uses 100 XP progress to next level. This needs alignment before launch.

Recommended v1 levels:

| Level | Title | XP |
| --- | --- | --- |
| 1 | New Hero | 0-99 |
| 2 | AI Explorer | 100-249 |
| 3 | Pattern Detective | 250-499 |
| 4 | Robot Trainer | 500-799 |
| 5 | Safety Hero | 800-1199 |
| 6 | AI Champion | 1200-1699 |
| 7 | Cosmic Shiv Hero | 1700+ |

## Current Achievements

| Achievement | Purpose |
| --- | --- |
| First Spark | First lesson |
| Quiz Champ | First quiz |
| Game Starter | First game |
| 100 XP Hero | Early progress |
| Pattern Detective | Pattern milestone |
| Robot Trainer | Robot training milestone |
| Safety Hero | Privacy/safety milestone |
| 500 XP Legend | XP milestone |
| Course Champion | Course completion |
| AI World Explorer | All 30 Phase 1 lessons |
| AI Games Hero | All active games |
| AI Master | Phase 1 mastery |

## No Duplicate Reward Rules

- Quiz completion can award based on score when submitted.
- Game rewards should be first completion only.
- Replay should show encouragement but no repeated XP/coins.
- Rewarded ad bonus should be claim-once per reward key.
- Badge unlocks should be idempotent.

## Achievement JSON Schema

```json
{
  "id": "robot-trainer",
  "title": "Robot Trainer",
  "description": "Train ShivBot using examples.",
  "icon": "smart_toy",
  "requiredXp": 500
}
```

## Test Cases

| Test | Expected |
| --- | --- |
| Complete first game | `game-starter` unlocks |
| Complete `ai_detective` | `pattern-detective` unlocks |
| Complete `train_robot` | `robot-trainer` unlocks |
| Replay completed game | XP/coins do not increase |
| Complete all active games | `ai-games-hero` unlocks |
| Earn XP threshold | XP badge unlocks once |

## What Already Exists

- Local progress model.
- Gamification service.
- Game completion notifier.
- Rewards and achievements JSON.
- Shop domain items.
- Tests for game rewards and gamification.

## What Is Missing

- Aligned level threshold rules.
- Course completion bonus.
- Certificate rewards.
- Stronger unlock rule metadata.
- Parent-visible reward explanation.

## Recommended Next Steps

1. Align level math across dashboard, trophy room, and gamification.
2. Add tests for level thresholds.
3. Add course completion badge logic.
4. Add certificate concept after course completion.

## Implementation Checklist

- [ ] Document one source of truth for level thresholds.
- [ ] Validate all achievement IDs.
- [ ] Confirm no duplicate rewards on replay.
- [ ] Confirm shop purchase persistence.
- [ ] Confirm rewarded ads bonus is optional and once-only.

## Acceptance Criteria

- Rewards feel exciting but not manipulative.
- Child can progress without ads or purchases.
- Replay is fun but not exploitable.
- Parent can understand reward purpose.

