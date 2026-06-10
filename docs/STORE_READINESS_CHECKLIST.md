# Store Readiness Checklist

## Google Play

- [ ] Generate Android native project and set package name.
- [ ] Configure app signing and release keystore.
- [ ] Complete Data Safety form.
- [ ] Complete target audience and content settings.
- [ ] If targeting children, comply with Families Policy.
- [ ] Provide privacy policy URL.
- [ ] Provide terms of service URL.
- [ ] Add in-app privacy and deletion links.
- [ ] Verify no non-compliant ads or SDKs for children.
- [ ] Add screenshots for phone and tablet.
- [ ] Add feature graphic, app icon, short description, full description.
- [ ] Set content rating questionnaire accurately.
- [ ] Test on physical Android devices and tablets.
- [ ] Verify Firebase App Check and production rules.

## Apple App Store

- [ ] Generate iOS native project and bundle ID.
- [ ] Configure signing, capabilities, Sign in with Apple, and push if needed.
- [ ] Decide whether to use Kids Category; if yes, comply with Kids Category rules.
- [ ] Provide privacy policy URL in App Store Connect and inside app.
- [ ] Complete App Privacy Details accurately.
- [ ] Add child data handling, consent, retention, and deletion disclosures.
- [ ] Add screenshots for required iPhone and iPad sizes.
- [ ] Ensure external links, purchases, admin areas, and web content are behind parental gates.
- [ ] Verify no prohibited third-party analytics/advertising for Kids Category.
- [ ] Test on physical iPhone and iPad.
- [ ] Provide review notes and demo credentials.

## Permissions

Current scaffold should avoid requesting camera, microphone, contacts, precise location, photo library, Bluetooth, or tracking permissions until a feature genuinely needs them. Add purpose strings only when the native feature is implemented.

## Metadata

- App name: AIWithShiv
- Category: Education; consider Kids Category only if all child privacy requirements are met.
- Age rating: likely 4+ or equivalent only after AI chat safety is independently validated.
- Required links: privacy policy, terms, support, data deletion.
