# Parent and Teacher Content

## Purpose

Plan parent/teacher support content that builds trust, explains learning value, and prepares the app for schools.

## Current Project Understanding

The core child app exists, but parent/teacher support is limited. Some parent and admin screens exist in the project tree, but current routing redirects parent/admin/login/signup paths to dashboard. Treat parent/teacher content as roadmap work, not current production flow.

## Parent Intro Screen Idea

Title: "What your child learns with Shiv"

Content:

- AI is explained through stories, games, and safe examples.
- No child login is required.
- Progress is stored locally on device.
- Shiv teaches privacy and fact-checking.
- Parents can guide discussion after each course.

## Teacher Guide

Teacher guide sections:

| Section | Content |
| --- | --- |
| Course objective | What students learn |
| Time required | 5-8 minutes per lesson |
| Classroom activity | Group discussion or sorting task |
| Vocabulary | AI, pattern, example, data, privacy |
| Assessment | Quiz and observation |
| Safety note | Private info and trusted adults |

## What Child Learns Per Course

| Course | Parent/teacher explanation |
| --- | --- |
| AI Masti Missions | Child learns what AI is, where it appears, how to ask questions, and how to stay safe |
| Pattern Playground | Child learns patterns, prediction, clues, and evidence-based thinking |
| Teach The Robot | Child learns that AI uses examples, categories, good data, and feedback |

## Safety Explanation

AIWithShiv teaches:

- Do not share passwords.
- Do not share phone number.
- Do not share address.
- Do not share school ID.
- Do not share private photos.
- Ask trusted adults.
- Check AI answers.

## Offline-First Privacy Explanation

Core learning works without child login. Learning content is bundled in the app. Progress is stored locally with SharedPreferences. The core learning flow does not need Firebase.

## School Licensing Future Plan

Future school version could include:

- Teacher PDF guide.
- Printable worksheets.
- Classroom certificates.
- School dashboard without child private data.
- Bulk license code.
- Offline classroom mode.

## Printable Certificate Ideas

- "AI Masti Hero"
- "Pattern Detective"
- "Robot Trainer"
- "AI Safety Hero"
- "Phase 1 AI Hero"

## What Already Exists

- Child learning flow.
- Local-first progress.
- Safety messages in profile and lessons.
- Achievement system.

## What Is Missing

- Parent onboarding content.
- Teacher guide PDFs.
- Printable certificates.
- Parent privacy explanation inside app.
- Course summary exports.

## Recommended Next Steps

1. Add parent/teacher copy to docs first.
2. Create a simple "For Parents" screen later.
3. Add course completion certificate later.

## Implementation Checklist

- [ ] Write parent intro copy.
- [ ] Write teacher one-page guide per course.
- [ ] Write privacy explanation in parent language.
- [ ] Create certificate templates.
- [ ] Decide whether parent content lives in app or store website.

## Acceptance Criteria

- Parent can understand safety without technical knowledge.
- Teacher can use one course in a classroom.
- School partner can see educational value.
- No child private data is required.

