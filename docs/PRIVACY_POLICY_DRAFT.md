# AIWithShiv Privacy Policy Draft

This is an implementation-aligned draft for the local-first v1 app. It must be reviewed by qualified legal counsel before release.

## Summary

AIWithShiv is designed for children aged 5-10 to learn basic AI concepts through comic lessons, quizzes, games, voice narration, and rewards.

Core learning does not require a child login. The app does not need a child's phone number, email, password, address, school ID, or private photo for core learning.

## Core Local Data

The core app stores learning progress and preferences locally on the device.

Local data may include:

- Completed lessons.
- Quiz progress.
- Game progress.
- XP, coins, streaks, level, and badges.
- Avatar, hero name, sound, language, accessibility, and shop preferences.

This local core learning data is not required to be sent to AIWithShiv servers for v1 core learning.

## Data Not Needed For Core Learning

AIWithShiv core learning does not require:

- Child email.
- Child phone number.
- Child password.
- Child address.
- School ID.
- Private photos.
- Social profile.

## Optional ShivBot

If ShivBot AI chat is enabled, child prompts may be sent to a protected backend so ShivBot can answer safely. The Flutter app must not contain direct AI API keys.

Children should not type private information into ShivBot. ShivBot is educational and can make mistakes.

Before enabling ShivBot in production, the production privacy policy must explain:

- What prompt data is sent.
- Whether prompts are stored.
- How long backend data is retained.
- How parents can request deletion of backend data if retained.

## Optional Ads

Ads are disabled by default unless explicitly enabled through app configuration.

If ads are enabled in production, the production privacy policy and store disclosures must identify the ad provider, child-directed treatment, data processing, and where ads appear. Ads must not appear during lessons, quizzes, games, ShivBot chat, profile, or trophies.

## Analytics And Crash Reporting

Analytics and crash reporting should remain optional and privacy-safe. If enabled later, update this policy and store disclosures before release.

## Children's Privacy

AIWithShiv is intended to be child-friendly and privacy-conscious. The v1 core learning flow avoids child accounts and unnecessary child personal data collection.

Parents or guardians should supervise young children's use of AI tools and remind children not to share private information.

## Data Sharing

AIWithShiv does not sell child data.

For the core local-first learning flow with ads disabled and ShivBot disabled, no core learning data is shared with external services.

If optional services are enabled, update this section with exact service providers and data practices.

## Deletion

For local-only core learning data, deleting/uninstalling the app removes local app data subject to Android/iOS platform behavior.

If optional backend services are enabled, provide a clear support process for backend data deletion requests.

## Contact

Add production support and privacy contact details before release.
