# Phase 5 Store and Privacy Pack

## Purpose

Prepare store listing copy, screenshot captions, privacy claims, and data safety notes for AIWithShiv v1 on Android and iOS.

This pack is written for the current v1 direction:

- Android/iOS only.
- Children aged 5-10.
- Core learning is local-first.
- No child login for core learning.
- Firebase is not required in the core learning flow.
- ShivBot uses a separate backend only if enabled.
- Ads stay disabled by default unless child-directed compliance is complete.

## Final Store Positioning

Recommended app name:

AI with Shiv: Kids Learn AI

Short subtitle:

Comic AI lessons, games, quizzes, and Hindi/English support for kids.

One-line pitch:

AI with Shiv helps Indian children aged 5-10 learn safe AI basics through comic missions, games, quizzes, voice narration, and playful rewards.

## Google Play Short Description

Safe comic-style AI learning for kids with Shiv, games, quizzes, XP, and Hindi/English support.

## App Store Subtitle

Comic AI learning for kids

## Long Store Description

AI with Shiv helps children learn the basics of Artificial Intelligence through short comic missions, simple quizzes, playful games, voice narration, and friendly rewards.

Children join Shiv, a robot-superhero tutor, to explore AI helpers, patterns, examples, machine learning, good questions, AI mistakes, and privacy safety. The app is designed for Indian children aged 5-10 and uses familiar examples like school, tiffin, cricket, mangoes, rangoli, friends, family, and Diwali lights.

Core learning works without a child login. Lessons are bundled inside the app, and learning progress is stored locally on the device.

Features:

- 30 beginner AI lessons across 3 courses.
- 5 AI mini-games.
- Simple two-question checkpoints.
- XP, coins, streaks, badges, trophies, and shop rewards.
- Hindi/English learning support.
- Voice narration and accessibility settings.
- Offline-first core lessons and games.
- Child-friendly privacy and AI safety lessons.

Children learn:

- What AI is in simple words.
- How AI uses examples and patterns.
- Why AI can make mistakes.
- How to ask clearer questions.
- Why private information should stay safe.
- How humans guide and check AI.

Parent trust:

- No child login is required for core learning.
- No child phone number, email, address, password, school ID, or private photo is needed for core learning.
- Core progress is stored locally on the device.
- Ads are disabled by default unless intentionally enabled with child-safe compliance.
- ShivBot AI chat should use a protected backend if enabled.

AI with Shiv is built to make early AI literacy joyful, safe, and easy for young learners.

## Keywords

AI for kids, learn AI, kids education, Indian kids learning, machine learning for kids, AI games, educational app, Hindi English learning, STEM for kids, safe learning app, coding basics, robot learning, children education.

## Screenshot Captions

| Screen | Caption |
| --- | --- |
| Welcome/Dashboard | Start your AI Hero journey with Shiv |
| Learning Path | 30 playful AI lessons for kids |
| Lesson Screen | Comic stories with voice narration |
| Quiz Screen | Tiny checkpoints that build confidence |
| Games Screen | Learn AI through 5 mini-games |
| Trophy Room | Earn XP, coins, badges, and levels |
| Profile/Settings | Hindi, voice, and safe learning settings |
| ShivBot | Ask ShivBot simple AI questions |

## Preview Video Script

1. Shiv appears on the dashboard and greets the child.
2. The XP bar and comic mission cards appear.
3. The child opens the Learning Path.
4. A lesson explains AI with a familiar mango, tiffin, or classroom example.
5. The child answers a two-question quiz.
6. XP, coins, and badge progress appear.
7. The child plays Train the Robot.
8. The Trophy Room shows badges and level progress.
9. Final card: "Become an AI Hero with Shiv."

## Store Category and Age Notes

Recommended category:

- Education

Age positioning:

- Designed for children aged 5-10.
- Keep content child-safe, non-political, non-scary, and non-adult.

Kids category note:

Only submit to strict kids/family categories after final privacy, ads, external link, and data collection review. If ads are enabled, child-directed treatment must be verified first.

## Data Safety Notes For Current V1

Core learning:

- Does not require child login.
- Does not require child email.
- Does not require child phone number.
- Does not require child address.
- Does not require child password.
- Does not require school ID.
- Does not require private photos.

Stored locally on device:

- Completed lessons.
- Quiz progress.
- Game progress.
- XP, coins, streaks, level, and badges.
- Profile preferences such as avatar, hero name, sound, language, accessibility, and shop choices.

Optional/conditional features:

- ShivBot may send chat prompts to a protected backend if enabled.
- Ads may involve ad network processing only if `ENABLE_ADS=true` and compliant production IDs are configured.
- Analytics/crash reporting should remain optional and privacy-safe if added later.

## Google Play Data Safety Draft Notes

Use these notes as an implementation-aligned draft, not as legal advice.

For core local-first v1 with ads disabled and ShivBot backend disabled:

- Data collected: none by core learning flow.
- Data shared: none by core learning flow.
- Data processed locally: learning progress and preferences stored on device.
- Account creation: not required.
- Data deletion: uninstalling the app removes local-only app data, subject to platform behavior.

If ShivBot backend is enabled:

- Disclose approximate chat prompt processing.
- Do not include child private information in prompts.
- Add backend retention/deletion details.
- Keep API keys out of Flutter.

If ads are enabled:

- Complete ad network disclosures.
- Confirm child-directed treatment.
- Confirm no ads during lessons, quizzes, games, ShivBot, profile, or trophies.

## Apple Privacy Nutrition Label Draft Notes

For core local-first v1 with ads disabled and ShivBot backend disabled:

- Data linked to user: none for core learning.
- Data used to track: none.
- Data not linked to user: none for core learning.
- Local-only progress and preferences should be described in privacy policy even if not transmitted.

If optional services are enabled, update labels before submission.

## Privacy Policy Requirements

Before public launch, publish a privacy policy URL that clearly states:

- Core learning works without child login.
- What is stored locally.
- What is not collected from children for core learning.
- Whether ShivBot is enabled and how prompts are processed.
- Whether ads are enabled and which ad network is used.
- How parents can contact support.
- How users can request help or deletion of backend data if any backend feature is enabled.

## Terms Requirements

Before public launch, publish terms that clearly state:

- AIWithShiv is educational.
- ShivBot may be wrong and is not for emergency, medical, legal, financial, or safety-critical advice.
- Parents/guardians should supervise young children.
- Children should not share private information.
- Rewards are motivational and have no cash value.

## Final Asset Checklist

- [ ] Capture Android screenshots from release build.
- [ ] Capture iPhone screenshots from release/TestFlight build.
- [ ] Confirm captions match actual screens.
- [ ] Produce feature graphic.
- [ ] Produce app preview video if needed.
- [ ] Publish privacy policy URL.
- [ ] Publish support contact.
- [ ] Confirm app title and subtitle.
- [ ] Complete Play Console Data safety.
- [ ] Complete App Store privacy labels.
