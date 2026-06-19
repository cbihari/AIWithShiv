# AIWithShiv Roadmap Documentation

## Purpose

This folder is the working roadmap system for taking AIWithShiv from current Flutter project state to a controlled Android/iOS launch.

## Recommended Reading Order

1. `00_PROJECT_OVERVIEW.md`
2. `01_PRODUCT_VISION.md`
3. `02_CURRICULUM_ROADMAP.md`
4. `03_CONTENT_ARCHITECTURE.md`
5. `04_COURSE_DESIGN.md`
6. `05_LESSON_DESIGN.md`
7. `06_QUIZ_DESIGN.md`
8. `07_GAMES_DESIGN.md`
9. `08_ACHIEVEMENT_REWARD_SYSTEM.md`
10. `09_LOCALIZATION_PLAN.md`
11. `10_PARENT_TEACHER_CONTENT.md`
12. `11_STORE_ASSETS_PLAN.md`
13. `12_LAUNCH_CHECKLIST.md`
14. `13_PHASED_EXECUTION_PLAN.md`
15. `14_TECHNICAL_AUDIT.md`
16. `15_CONTENT_QA_CHECKLIST.md`

## How Developers Should Use These Docs

- Start with the technical audit.
- Use the phased execution plan for task order.
- Use content architecture before changing JSON.
- Use launch checklist before release builds.
- Add tests whenever content, rewards, routes, or localization change.

## How Content Creators Should Use These Docs

- Start with product vision and curriculum roadmap.
- Use course, lesson, and quiz design docs to create content.
- Use content QA checklist before handing content to development.
- Use localization plan for Hindi/Hinglish adaptation.

## How Founder/Product Owner Should Use These Docs

- Use product vision to keep scope controlled.
- Use launch checklist to prepare store work.
- Use parent/teacher content plan for trust and school readiness.
- Use phased execution plan to avoid building too many features before launch.

## Moving From Docs To Implementation

Recommended first implementation phase:

1. Add a content validation script.
2. Review all lessons/quizzes using `15_CONTENT_QA_CHECKLIST.md`.
3. Improve repeated or weak quiz questions.
4. Complete Hindi content coverage.
5. Run `flutter analyze` and `flutter test`.

## Important Boundaries

- Core learning should remain local-first.
- No child login for v1.
- No Firebase in core learning flow.
- No direct AI API keys in Flutter.
- Ads stay disabled unless child-directed compliance is complete.
- Do not expand age groups until ages 5-10 launch is polished.

## Acceptance Criteria

- A developer can plan implementation without re-inspecting the whole project.
- A content creator can write new lessons consistently.
- A founder can understand launch readiness and risks.
- Roadmap supports phased Android/iOS release.

