# Nook

## What This Is

Nook is an AI-powered chat assistant specialized in discovering apps and tools for any problem a user describes. Instead of searching app stores or watching YouTube reviews, users describe what they're trying to do and the assistant asks clarifying follow-ups before recommending the best solutions — with real knowledge of pricing, ratings, and alternatives. For anyone who's ever thought "there's probably no app for this" and been wrong.

## Core Value

When a user describes a problem, the assistant finds the right tool — faster and more accurately than any general-purpose LLM or app store search could.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- User can describe a problem in natural language and get app/tool recommendations
- Assistant asks follow-up questions to narrow down the problem before recommending
- Recommendations include app name, what it does, platform, pricing, and a link
- Assistant uses live search to supplement LLM knowledge for up-to-date results
- User can save recommended tools to a personal tool stack
- User can revisit past searches and see previously recommended tools
- Free tier with usage limits; paid tier for unlimited searches and features
- Web app — accessible immediately in browser, no install required

### Out of Scope

- Native mobile app (v1) — web-first to validate the concept before investing in native builds
- Building / rating submitted by users — too much moderation complexity for v1
- Social features (sharing stacks, following others) — secondary to core discovery value

## Context

- The insight: people routinely underestimate how many good apps exist for a given problem. A specialized assistant trained on this task outperforms both app store search and general LLMs because it asks the right questions and has deep app knowledge.
- Monetization: freemium model — free tier to drive adoption, paid tier for power users.
- Discovery UX must feel like talking to a knowledgeable consultant, not filling out a search form.
- Live search capability (Product Hunt, app stores, web) is important for surfacing newer tools the LLM may not know.

## Constraints

- **Tech Stack**: Web-first — no native mobile for v1
- **LLM**: Hybrid approach — LLM handles reasoning and follow-ups, live search fills recency gaps
- **Monetization**: Freemium from day one — free tier must feel genuinely useful, not crippled

## Key Decisions


| Decision                           | Rationale                                                                | Outcome   |
| ---------------------------------- | ------------------------------------------------------------------------ | --------- |
| Product name: Nook                 | —                                                                        | — Pending |
| Conversational before recommending | Consultant-style follow-ups surface the real problem, not the stated one | — Pending |
| Hybrid LLM + live search           | LLM alone misses new tools; live search alone lacks reasoning            | — Pending |
| Web-first                          | Fastest path to validation; broadest reach without app store approval    | — Pending |
| Freemium                           | Free tier drives organic growth; paid tier monetizes power users         | — Pending |


## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):

1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):

1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---

*Last updated: 2026-04-11 after moving to nook/PROJECT.md*