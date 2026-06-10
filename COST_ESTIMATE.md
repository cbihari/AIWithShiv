# Cost Estimate

All numbers are rough monthly ranges and should be recalculated after real usage data exists.

## Pilot

- Firebase Auth, Firestore, Storage, Functions: USD 0-75
- AI APIs: USD 50-500
- Email reports: USD 0-50
- Total: USD 50-625

## Production Launch

- Firebase: USD 200-1,500
- AI APIs: USD 500-5,000
- Monitoring, email, and content tools: USD 100-1,000
- Total: USD 800-7,500

## Cost Controls

- Cache common AI explanations.
- Use smaller models for simple age-adjusted answers.
- Enforce token and message limits per learner.
- Optimize media files before upload.
- Paginate Firestore reads.
- Store aggregate progress summaries for dashboards.
