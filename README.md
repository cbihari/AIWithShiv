# AIWithShiv

AIWithShiv is a cross-platform Flutter scaffold for teaching Artificial Intelligence, Machine Learning, Deep Learning, Robotics, Coding, and future technologies through story-based lessons, games, quizzes, rewards, and an AI buddy called ShivBot.

## Product Scope

Target learner groups:

- Tiny Explorers: 5-10 years
- Young Innovators: 10-15 years
- Future Builders: 15-20 years
- Adults: 20+ years

Core experiences:

- Splash, welcome, age selection, parent consent, login, signup
- Dashboard with daily lesson, XP, streak, continue learning, ShivBot, daily quiz, leaderboard, and badges
- Learning paths, lessons, quizzes, achievements, profile
- Parent dashboard with progress, reports, screen-time control, and weekly reports
- Admin dashboard for courses, lessons, quizzes, media, users, and analytics

## Architecture

The scaffold follows Clean Architecture with MVVM-friendly presentation boundaries:

```text
lib/
├── core/                 # routing, DI, errors, logging, network, theme
├── config/               # env and Firebase configuration
├── features/             # feature-first modules
│   ├── auth/
│   ├── onboarding/
│   ├── dashboard/
│   ├── lessons/
│   ├── quizzes/
│   ├── games/
│   ├── ai_chat/
│   ├── achievements/
│   ├── parents/
│   ├── admin/
│   └── profile/
├── shared/               # reusable models and widgets
└── main.dart
```

Patterns included:

- Riverpod dependency injection and state providers
- Go Router navigation
- Repository interfaces with Firebase-backed implementations
- API service layer using Dio
- Environment configuration through `--dart-define`
- App exception hierarchy and logger setup
- Material 3 theme with bright, child-friendly UI primitives
- Firebase Auth, Firestore, Storage, Analytics, and Functions placeholders

## AI Layer

ShivBot has a provider-neutral repository:

- `openai`: OpenAI chat/completions adapter placeholder
- `gemini`: Gemini generateContent adapter placeholder
- `bedrock`: Cloud Functions proxy adapter placeholder
- `local`: safe local fallback for future local LLM support

For production, do not call paid AI providers directly from the app with secret keys. Route requests through Cloud Functions, enforce Firebase Auth, add rate limits, log safety events, and keep provider keys in Secret Manager.

## Local Setup

Prerequisites:

- MacBook Air M4 or Apple Silicon Mac
- VS Code
- Flutter stable
- Xcode and Android Studio
- Firebase CLI
- Node.js 20+

One-time Mac setup:

```bash
sudo xcodebuild -license
flutter doctor
```

Create native platform folders after the Xcode license is accepted:

```bash
cd /Users/shivsharma/Personal/AI/AIWithShiv
chmod +x scripts/bootstrap_native.sh
./scripts/bootstrap_native.sh
```

Configure Firebase:

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=aiwithshiv-dev
firebase use aiwithshiv-dev
firebase emulators:start
```

Run the app:

```bash
flutter run --dart-define=APP_ENV=dev
```

Build Android:

```bash
chmod +x scripts/build_android.sh
APP_ENV=prod ./scripts/build_android.sh
```

Build iOS:

```bash
chmod +x scripts/build_ios.sh
APP_ENV=prod ./scripts/build_ios.sh
```

## Sample Data

Seed content lives in `assets/data/`:

- `courses.json`
- `lessons.json`
- `quizzes.json`
- `rewards.json`
- `achievements.json`

These can be imported into Firestore through a small admin script or Firebase console import flow.

## Firebase Collections

Suggested Firestore collections:

- `users`
- `courses`
- `lessons`
- `quizzes`
- `progress`
- `achievements`
- `rewards`
- `parentReports`
- `adminAuditLogs`

Security defaults:

- Learners can read course content after sign-in
- Users can read/update only their own profile
- Admin writes require a custom claim: `admin: true`
- Parent reports are scoped to the authenticated parent UID

## Development Roadmap

Foundation:

- Finalize Flutter native platform folders
- Connect real Firebase project for dev, staging, and prod
- Add auth flows with validation and error states
- Add Firestore seed importer
- Add analytics events for onboarding, lesson start, lesson complete, quiz complete, and ShivBot use
- Add accessibility QA for text scale, contrast, semantics, and screen readers

## MVP Roadmap

MVP goal: ship a safe, fun learning loop.

- Email/password auth and parent consent capture
- Age-aware onboarding
- Course list and lesson reader
- Quiz engine with XP and coins
- Dashboard with streaks and daily lesson
- ShivBot via Cloud Functions proxy with safety guardrails
- Parent progress dashboard
- Admin content creation forms
- Firebase Analytics dashboards
- Android internal testing and iOS TestFlight

## Phase 2 Roadmap

- Animated story lessons and interactive mini games
- Push notifications for streaks and daily rewards
- Weekly parent email reports
- Leaderboards by private classroom or family group
- Video uploads and transcoding workflow
- Teacher/admin roles
- Content moderation review queue
- Offline lesson cache
- Localization for Hindi and other Indian languages

## Phase 3 Roadmap

- Personalized learning paths using mastery data
- Robotics simulator activities
- Computer vision demos with camera permission controls
- Local LLM experimentation for offline learning
- Subscription plans and scholarships
- School dashboards and cohort analytics
- Advanced admin CMS with versioned curriculum
- COPPA/GDPR-K compliance review and privacy audit

## Estimated Firebase Cost

Early MVP with up to 1,000 monthly active learners:

- Firebase Auth: usually low or no cost for email/password at this scale
- Firestore: USD 0-25/month depending on reads and writes
- Storage: USD 0-10/month for small images and limited videos
- Cloud Functions: USD 0-20/month before heavy AI proxy traffic
- Analytics: no direct Firebase Analytics charge

Growth stage with 10,000-50,000 monthly active learners:

- Firestore: USD 50-500/month depending on feed design and caching
- Storage/CDN: USD 50-1,000/month, mostly driven by video
- Cloud Functions: USD 100-1,000/month depending on AI proxy calls and scheduled jobs
- Email provider: USD 20-300/month for parent reports

AI provider usage is usually the largest variable cost. Budget separately by messages per learner, model choice, token limits, and caching strategy.

## Estimated Monthly Infrastructure Cost

MVP pilot:

- Firebase: USD 0-75/month
- AI APIs: USD 50-500/month
- Email/reporting: USD 0-50/month
- Total: roughly USD 50-625/month

Production launch:

- Firebase: USD 200-1,500/month
- AI APIs: USD 500-5,000/month
- Monitoring, email, content tools: USD 100-1,000/month
- Total: roughly USD 800-7,500/month

Cost controls:

- Cache repeated ShivBot explanations
- Use smaller models for simple answers
- Add per-user daily token budgets
- Keep lesson media optimized
- Use Firestore pagination and aggregate documents
- Route videos through a CDN or dedicated video platform as usage grows

## Production Notes

- Replace placeholder Firebase options with `flutterfire configure`.
- Move AI keys to Cloud Functions secrets; never ship them in Flutter.
- Add App Check before public launch.
- Add crash reporting once native platform folders are generated.
- Run legal/privacy review for children’s data, parent consent, retention, and deletion workflows.
