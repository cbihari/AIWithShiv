# AIWithShiv Production Readiness Audit

Audit date: 2026-06-09

## Release Recommendation

NOT READY

The scaffold is directionally sound but not ready for Google Play or Apple App Store release. It now has stronger auth, safety, rules, CI, and tests, but it still needs real native project generation, Firebase project configuration, legal/privacy artifacts, real content moderation, App Check rollout, store metadata, live device testing, and formal child privacy review.

## Scorecard

| Category | Score |
| --- | ---: |
| Overall Architecture | 72 |
| Security | 68 |
| Performance | 74 |
| UI/UX | 70 |
| Accessibility | 62 |
| Test Coverage | 45 |
| Firebase Readiness | 70 |
| Google Play Readiness | 48 |
| Apple App Store Readiness | 42 |
| Overall Production Readiness | 61 |

## Architecture Findings

| Issue | Severity | Recommendation |
| --- | --- | --- |
| MVVM is partial; only auth and AI chat now have view models. | High | Add view models for dashboard, lessons, quizzes, profile, parent, and admin flows. |
| Clean Architecture boundaries exist but models are shared mutable DTO-style classes without value equality. | Medium | Adopt `freezed`/`json_serializable` or hand-written equality for domain models. |
| Repository pattern exists for auth, lessons, admin, parent, AI chat. | Medium | Add repositories for quiz, achievements, profile, progress, rewards, and dashboard aggregation. |
| Navigation guard checks only `currentUser`, not claim refresh or role authorization. | High | Add async role provider, refresh ID token claims, and block `/admin` unless `admin == true`. |
| Firebase initialization runs unconditionally in `main`, making pure widget tests harder. | Medium | Split app bootstrap from app widget and inject Firebase-dependent services. |

## Code Quality Findings

| Issue | Severity | Recommendation |
| --- | --- | --- |
| Screens still contain static placeholder data. | High | Move screen state to Riverpod view models and repositories. |
| Loading/empty/error states are missing on most screens. | High | Add `AsyncValue.when` for dashboard, lessons, quiz, achievements, parent, admin. |
| `AppScaffold` always uses a `ListView`; simple screens may overbuild. | Low | Use `CustomScrollView` or accept as MVP; current overhead is small. |
| Unused dependencies: `freezed`, `json_serializable`, `build_runner`, `lottie`, `shared_preferences` are not yet used. | Low | Use them in upcoming implementation or remove before release. |
| No generated native Android/iOS folders yet. | Critical | Run `sudo xcodebuild -license`, then `./scripts/bootstrap_native.sh`. |

## Firebase Findings

| Area | Status | Severity | Fix |
| --- | --- | --- | --- |
| Email auth | Implemented repository + UI path | Medium | Add validation and real Firebase integration tests. |
| Google auth | Repository method added | High | Configure OAuth client IDs, SHA-1/SHA-256, URL schemes, and consent screen. |
| Apple auth | Repository method added | High | Configure Sign in with Apple capability and service ID. |
| Password reset | Repository + UI path added | Medium | Add user-friendly success copy and throttling UX. |
| Firestore rules | Improved default deny and schema checks | Medium | Add emulator rules tests. |
| Storage rules | Improved MIME/size checks | Medium | Add malware scanning/content moderation for admin uploads. |
| Cloud Functions | App Check and rate limit added | High | Store provider secrets in Secret Manager and add structured audit logs. |
| Analytics | Service exists | High | Instrument funnels in all screens and disable/minimize child analytics where required. |

## Security Report

Critical gaps remaining:

- No production Firebase configuration or App Check provider setup.
- No verified parental consent workflow.
- No privacy policy, terms, data deletion flow, or consent withdrawal UI in app.
- ShivBot safety is still local rule-based; production needs provider moderation, allowlisted educational tools, audit logs, escalation review, and child-specific policy tests.
- Admin screens are UI-only and need server-side role enforcement through custom claims and callable/admin-only APIs.

Patched:

- Auth UI no longer bypasses Firebase.
- Google, Apple, and password reset repository methods added.
- Firestore and Storage default-deny rules added.
- Cloud Function App Check enforcement and per-user rate limiting added.
- ShivBot prompt injection and unsafe response checks strengthened.

Security score: 68/100.

## Compliance Report

COPPA/GDPR-K/Google Play/Apple Kids readiness is not sufficient yet.

Required before release:

- Verifiable parental consent for children below applicable age thresholds.
- Clear privacy policy available in app and store metadata.
- Data deletion, access, correction, and consent withdrawal workflows.
- Data minimization for child profiles; avoid precise age/date of birth unless required.
- No third-party ads for children unless fully compliant with kids policies.
- Review whether Firebase Analytics is permissible for Apple Kids Category; if used, ensure no IDFA, no identifiable child data, and document practices.
- Parental gate for external links, purchases, admin areas, and settings.
- Child-safe AI content moderation and human review process.

Compliance score: 46/100.

## Performance Report

Expected startup:

- Cold start risk: Firebase initialization, analytics startup, and future remote config/content loads.
- Warm start risk: low for current scaffold.

Expected memory:

- Dashboard: low; static list.
- Lesson: low; text/icon only.
- Quiz: low; static buttons.
- AI Chat: low now, higher once streaming, history, and markdown/media are added.

Network:

- Firestore calls should use pagination, cache, and aggregate documents.
- AI calls must be proxied, rate limited, cached for common explanations, and capped by age group.
- Images need cached loading and size-aware uploads.

Battery:

- No background processes now.
- Keep analytics lightweight and avoid high-frequency events.

Performance score: 74/100.

## UI/UX/Accessibility Report

Scores:

- UI: 70/100
- UX: 68/100
- Accessibility: 62/100

Findings:

- Child-friendly colors and large buttons are present.
- Font scaling, contrast testing, screen reader labels, focus order, and reduced-motion support are incomplete.
- Most screens lack empty/loading/error states.
- Parent consent is not legally meaningful yet; it is a placeholder checkbox.
- Admin dashboard lacks forms and validation.
- Animations are not implemented despite being a requirement.

## Optimization Report

Immediate optimizations:

- Convert static screens to Riverpod `AsyncNotifier`/`StateNotifier` view models.
- Use cached Firestore streams only where live updates are truly needed.
- Add `const` widgets consistently after formatting.
- Add image caching and responsive image sizes.
- Add route-level analytics and funnel events.
- Add debouncing and cancellation for ShivBot prompts.

## Refactored Code Suggestions

Already patched:

- `AuthRepository` now includes Google, Apple, password reset.
- `AuthViewModel` and login/signup async UI paths added.
- `AiChatViewModel` and safer ShivBot UI path added.
- Firebase rules and Cloud Functions hardened.
- CI upgraded with format, coverage, Android, iOS, Functions build.

Next refactor:

- Add `DashboardViewModel`, `LessonViewModel`, `QuizViewModel`, `ParentDashboardViewModel`.
- Replace shared model parsing with generated immutable DTOs.
- Add route shell with bottom navigation for learner surfaces.
- Add a `UserRoleRepository` and admin route guard.
