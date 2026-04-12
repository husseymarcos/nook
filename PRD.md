# Nook - PRD

## Overview

Nook is an AI-powered chat assistant that helps users discover apps and tools for their specific problems through natural conversation.

---

## Core User Flow

1. User describes a problem in natural language
2. LLM asks 1-3 clarifying follow-up questions
3. User answers follow-ups
4. LLM generates 3 app/tool recommendations as cards
5. User can save recommended tools to their personal stack

---

## Tech Stack

| Component | Choice |
|-----------|--------|
| Backend | Ruby on Rails 8 |
| Frontend | Hotwire (Turbo + Stimulus) |
| Database | SQLite |
| LLM | Gemini |
| Auth | Email + password (Rails 8 built-in) |
| Hosting | Fly.io |
| Payments | Stripe |
| Design System | [DESIGN.md](./DESIGN.md) - The Curated Boutique |

---

## Design System Reference

All UI implementations must follow [DESIGN.md](./DESIGN.md) — "The Curated Boutique" aesthetic:

- **No 1px borders** — use background color shifts (`surface-container-low`) for sectioning
- **Typography**: Chunky serif (Epilogue) for headlines + rounded sans (Plus Jakarta Sans) for body
- **Depth**: Tonal layering instead of drop shadows; use primary-tinted ambient glows
- **Cards**: Large radius (24px+), no dividers, vibrant app icon glows
- **Buttons**: Pill-shaped (3rem radius), 56px height, primary gradient on CTAs

---

## Database Schema

### Users
- id, email, encrypted_password, created_at, updated_at
- premium_until (datetime, null if free)
- searches_this_month (integer, counter)

### Conversations
- id, user_id, title, created_at, updated_at

### Messages
- id, conversation_id, role (user/assistant), content, created_at

### Tools (Default + User-Added)
- id, name, description, platform, category
- is_default (boolean, true for hardcoded tools)

### UserStacks
- id, user_id, tool_id, created_at

---

## Features

### MVP In Scope

#### 1. Authentication
- Email + password signup/login
- No anonymous usage

#### 2. Chat Interface
- GPT-style full-screen chat
- Mobile-first responsive design
- Dark mode toggle
- Linear conversation (no message editing)
- View past conversations list

#### 3. Recommendations
- LLM asks 1-3 follow-up questions max
- Generates exactly 3 recommendations
- Card grid display with:
  - App name
  - Description
  - Platform (iOS, Android, Web, Mac, Windows)
  - Pricing (Free, Freemium, Paid)
- No external links (MVP simplification)

#### 4. Stack Management
- Default list of 15 popular tools (hardcoded)
- User can add tools one-by-one from default list
- User can add custom tools (name only for MVP)
- Max 20 tools per stack
- Duplicates auto-merge
- Stack influences recommendations (e.g., "recommend tools with Notion integration")

#### 5. Freemium Model
- Free: 10 searches per calendar month
- Paid Monthly: $5/month unlimited searches
- Paid Annual: $48/year (20% discount, $4/month effective)
- Soft wall at limit ("Upgrade to continue")
- Stack access is free (not premium-gated)

#### 6. History
- All conversations saved
- Sidebar list of past conversations
- Click to view full conversation
- Rename conversation (click title to edit)
- Delete conversation (with confirmation)

### Out of Scope (MVP)

- Live web search (use LLM knowledge only)
- URL verification for recommendations
- External links in recommendations
- User ratings/reviews
- Social features
- Native mobile app
- Export conversation
- Search within history
- Free trial

---

## Default Tool List (Hardcoded)

1. Notion - Notes, docs, databases
2. Figma - Design, prototyping
3. Slack - Team communication
4. Linear - Project management
5. Cursor - AI code editor
6. Canva - Graphic design
7. Obsidian - Personal knowledge base
8. Todoist - Task management
9. Spotify - Music streaming
10. Discord - Community chat
11. Zoom - Video meetings
12. Gmail - Email
13. Google Calendar - Scheduling
14. Safari - Web browser
15. VS Code - Code editor

---

## UI/UX Specifications

Follow [DESIGN.md](./DESIGN.md) — "The Curated Boutique" design system.

### Chat Interface
- Clean, editorial layout (asymmetric, boutique feel — not generic GPT clone)
- User messages right-aligned, assistant left
- Typing indicator during LLM response
- "New conversation" button: pill-shaped, 56px height, primary gradient
- Background: `surface` (#f6f6f6) with tonal layering

### Recommendation Cards
- Grid: 1 column mobile, 3 columns desktop
- Card style: `surface-container-low` (#f0f1f1), radius `xl` (24px+), lg padding
- Contains: App name (Title-MD, Epilogue serif), Description, Platform badges, Pricing tag
- App icons: 20% `primary` glow behind to make them pop
- **No dividers** — use spacing and tonal shifts only
- "Add to Stack" button: secondary style (Secondary_container fill)

### Stack Page
- `surface-container-low` background for section definition
- List view with `surface-container-lowest` cards for each tool
- "Add Tool" button: opens modal with default list + custom input
- Remove tool: accessible via card action
- Progress indicator: Label-SM (all-caps, 0.05em spacing) — "14/20 TOOLS"

### Navigation
- Mobile: Bottom tab bar with glassmorphism (80% opacity + blur)
- Desktop: Sidebar (Level 3 floating) + main chat area
- Active states: 15% opacity `primary` glow (electrified, not heavy)

### Theme
- Dark mode available — toggle in settings
- System preference detection
- Colors shift to dark palette but keep tonal layering principle

---

## API Integration

### Gemini
- Model: gemini-1.5-flash (cost-effective)
- Temperature: 0.7
- Max tokens: 1024

#### System Prompt Template
```
You are Nook, an expert app/tool discovery assistant.

Your job:
1. Ask 1-3 clarifying questions to understand the user's exact needs
2. Recommend exactly 3 specific apps/tools that solve their problem
3. Consider their existing stack when making recommendations

User's current stack: {{stack_list}}

Rules:
- Be conversational and friendly
- Ask follow-ups before recommending
- Recommendations must include: name, description, platform, pricing
- If user has tools in their stack, mention how recommendations integrate or compare
- Don't ask more than 3 questions before recommending
```

---

## Rate Limiting Logic

```ruby
# Pseudocode
def can_search?(user)
  return true if user.premium?
  
  # Reset counter if new month
  if user.last_search_reset_at.month != Time.current.month
    user.update(searches_this_month: 0, last_search_reset_at: Time.current)
  end
  
  user.searches_this_month < 10
end
```

---

## Payment Flow

1. User hits 10 search limit
2. Show upgrade prompt with Stripe Checkout
3. Options: Monthly ($5/mo) or Annual ($48/year)
4. On success: set `premium_until` to 1 month or 1 year from now
5. Webhook handles renewals/cancellations

---

## Error Handling

| Scenario | Behavior |
|----------|----------|
| LLM API down | Show "Service temporarily unavailable. Please try again." |
| Rate limit hit | Show upgrade prompt, allow browsing history |
| Database error | Show generic error, log for debugging |

---

## Deployment

- Platform: Fly.io
- Ruby version: 3.3
- SQLite on persistent volume (data survives deploys)
- Deploy: `fly deploy`
- Note: Free tier allowance covers MVP traffic

---

## Success Metrics (MVP)

- 100+ signups in first month
- 50+ conversations created
- 25% of users add at least 5 tools to stack
- 5+ premium conversions

---

## Future Phases

### Post-MVP
- Live web search integration
- URL verification for recommendations
- Add links to recommendations
- User ratings for recommended tools
- Anonymous trial (5 searches without signup)
- Export stack to PDF/CSV
- Browser extension

### Later
- Native mobile apps
- Social features (share stack, follow users)
- AI-generated app comparisons
- Integration with app stores for deep links

---

## Legal/Compliance (MVP Minimum)

- Privacy policy page (basic)
- Terms of service page (basic)
- No cookie banner needed (no third-party tracking)
- No GDPR-specific features for MVP (target: US market initially)

---

*PRD Version 1.0 - April 11, 2026*
