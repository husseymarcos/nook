# Nook

Rails app for chatting with an AI assistant that recommends apps and tools. Users sign up, start conversations, and get answers powered by **Google Gemini**. They can also curate a personal **stack** of tools (up to a per-user limit) and optionally **upgrade** when they hit free-tier usage limits.

## The problem

People who need software—whether for work, side projects, or personal life—often hit the same friction:

- **Too many options, weak signal.** Search results and “top 10” lists are generic, SEO-heavy, or outdated, so it is hard to tell what actually fits *your* situation.
- **Context is missing.** A good recommendation depends on platform, budget, team size, and what you already rely on. Most articles do not know your stack or constraints.
- **Discovery is slow and scattered.** Digging through forums, videos, and comparison sites takes time, and you still have to synthesize an answer yourself.
- **Decisions do not stick in one place.** It is easy to forget what you chose or why, and to duplicate tools that overlap.

## Why Nook helps

Nook is built around a **conversation-first** flow and a **personal stack**, so recommendations stay tied to real needs instead of one-size-fits-all lists.

- **Clarifying questions before picks.** The assistant is prompted to ask a small number of follow-ups so suggestions match the problem, not just a keyword.
- **Recommendations aware of your stack.** Your saved tools are passed into the model so new suggestions can complement (or replace) what you already use.
- **Consistent, scannable answers.** Replies aim for a structured format—named tools, short descriptions, platform, and pricing—so you can compare options quickly.
- **One place for the thread and the stack.** Chats and the tools you care about live in the app; you are not juggling bookmarks and half-remembered advice.
- **Clear limits and an upgrade path.** Free usage is capped in a predictable way; paying removes that cap so the product can stay available sustainably.

## Stack

- **Ruby** 3.4.x (see `.ruby-version`)
- **Rails** 8.1 — Hotwire (Turbo, Stimulus), Importmap, Propshaft
- **SQLite** — primary DB under `storage/` (plus Solid Cache / Queue / Cable DBs in production)
- **Background jobs** — `GenerateAiResponseJob` calls Gemini; uses Solid Queue
- **Payments** — LemonSqueezy via [Pay](https://github.com/pay-rails/pay) gem for subscription upgrades

## Features

- Session-based authentication, password reset, and registration
- Conversations with streamed-style updates (Turbo) and AI replies from Gemini
- Rate limits for free accounts; premium users bypass limits
- Tool stack: add default or custom tools, remove entries, max stack size enforced in the domain model

## Setup

```sh
bundle install
bin/rails db:prepare
```

### Environment variables

| Variable | Purpose |
|----------|---------|
| `GEMINI_API_KEY` | Required for AI responses ([Google AI Studio](https://aistudio.google.com/apikey)) |
| `LEMONSQUEEZY_API_KEY` | LemonSqueezy API key ([Settings → API](https://app.lemonsqueezy.com/settings/api)) |
| `LEMONSQUEEZY_STORE_ID` | Your LemonSqueezy store ID |
| `MONTHLY_PRICE_ID` | LemonSqueezy Variant ID for monthly plan |
| `ANNUAL_PRICE_ID` | LemonSqueezy Variant ID for annual plan |

Configure the **secret key** via the `LEMONSQUEEZY_API_KEY` environment variable. The Pay initializer (`config/initializers/pay.rb`) enables the LemonSqueezy processor.

Copy or export values in development (e.g. `.env` with your preferred loader, or shell exports). Without `GEMINI_API_KEY`, AI generation will error or return a fallback message from `GeminiService`.

### Webhooks (production)

LemonSqueezy sends webhooks for subscription events. Configure your webhook endpoint in the LemonSqueezy dashboard:

- **URL**: `https://yourdomain.com/pay/webhooks/lemon_squeezy`
- **Events**: `subscription_created`, `subscription_updated`, `subscription_cancelled`, `subscription_payment_success`, `subscription_payment_failed`, `subscription_payment_recovered`, `order_created`

The Pay gem handles these automatically to keep subscription status in sync.

### Run the app

```sh
bin/rails server
```

For job processing locally, run Solid Queue (see Rails 8 / Solid Queue docs) if you need AI replies outside the default dev setup.

### Tests

```sh
bin/rails test
```

Uses WebMock and Mocha; Gemini is stubbed in tests where appropriate.

## Deployment

[Kamal](https://kamal-deploy.org/) is configured (`config/deploy.yml`, `Dockerfile`). Adjust servers, registry, and secrets for your environment before deploying.
