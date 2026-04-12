# Design System Strategy: The Curated Boutique

## 1. Overview & Creative North Star
The "Creative North Star" for this design system is **The Digital Curator**.

Traditional app discovery feels like a sterile warehouse; this system is designed to feel like a high-end boutique—intentional, human, and brimming with personality. We break the "template" look by favoring expressive editorial layouts over rigid grids. We utilize intentional asymmetry, where large-scale chunky serifs overlap soft, vibrant containers, creating a sense of tactile depth. This is not just a utility; it is a personalized discovery journey that prioritizes "joy of use" through high-character typography and an energetic, "pop-minimalist" aesthetic.
 
---

## 2. Colors & Surface Philosophy
Our palette balances a pristine `background` (#FFFFFF) with high-octane accents to create a "gallery" effect where the content is the art.

### The "No-Line" Rule
To maintain a premium, editorial feel, **standard 1px solid borders are strictly prohibited for sectioning.** Boundaries must be defined through background color shifts or subtle tonal transitions.
*   **Implementation:** Use `surface-container-low` to define a section’s footprint against the `background` (#FFFFFF). This creates a "soft pocket" for content without the visual clutter of lines.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers—like stacked sheets of fine paper.
*   **Level 0 (Base):** `surface` (#f6f6f6) or `background` (#FFFFFF).
*   **Level 1 (Section):** `surface-container-low` (#f0f1f1).
*   **Level 2 (Interaction):** `surface-container-lowest` (#ffffff) for cards sitting on a Level 1 section.
*   **Level 3 (Floating):** Semi-transparent `surface` with a 20px backdrop-blur to create "Glassmorphism" for navigation bars or floating action buttons.

### Signature Textures & Gradients
Flat colors are for utilities; gradients are for "soul."
*   **Hero CTAs:** Use a linear gradient from `primary` (#004be2) to `primary_container` (#809bff) at a 135-degree angle.
*   **The Glow:** Instead of grey shadows, use a 15% opacity `primary` glow for active states to make elements feel "electrified" rather than "heavy."

---

## 3. Typography: The Editorial Voice
Typography is our primary tool for breaking the corporate mold. We use a high-contrast pairing of a chunky serif and a friendly, rounded sans.

*   **The "Pop" Headline (Epilogue):** Used for `display` and `headline` scales. This should be set with tight letter-spacing (-0.02em) to emphasize its "chunky" character.
*   **The Utility Sans (Plus Jakarta Sans):** Used for `title`, `body`, and `label` scales. Its rounded terminals mirror our 24px+ corner radius, ensuring a cohesive visual language.

**Hierarchy Strategy:**
*   **Display-LG (3.5rem):** Reserved for high-impact editorial moments and AI-driven recommendations.
*   **Title-MD (1.125rem):** Our "Workhorse" for app titles and card headings.
*   **Label-SM (0.6875rem):** Used in all-caps with 0.05em letter spacing for "Boutique Tags" (e.g., "EDITOR'S CHOICE").

---

## 4. Elevation & Depth
We eschew traditional Material Design shadows in favor of **Tonal Layering**.

*   **The Layering Principle:** Place a `surface-container-lowest` card (Pure White) on a `surface-container` background. The subtle shift from #FFFFFF to #e7e8e8 creates a natural lift that feels organic.
*   **Ambient Shadows:** If an element must "float" (e.g., a Modal), use an ultra-diffused shadow: `box-shadow: 0 20px 40px rgba(0, 75, 226, 0.06);`. The shadow is tinted with the `primary` color to maintain vibrancy.
*   **The "Ghost Border" Fallback:** For accessibility on white-on-white elements, use the `outline-variant` at 15% opacity. It should be felt, not seen.
*   **Glassmorphism:** For top navigation, use a `surface` fill at 80% opacity with a `backdrop-filter: blur(12px)`. This allows the vibrant app icons and gradients to bleed through as the user scrolls.

---

## 5. Components

### Buttons
*   **Primary:** `primary` fill, `on-primary` text. Radius: `xl` (3rem). Height: 56px for high-impact discovery.
*   **Secondary:** `secondary_container` fill with `on-secondary_container` text. Use for "Wishlist" or "Share."
*   **States:** On hover, apply a `primary_dim` glow. On press, scale the button to 0.96.

### Cards & Discovery Modules
*   **Constraint:** **Strictly no dividers.**
*   **Layout:** Use `lg` (2rem) padding and `xl` (3rem) corner radius. Use a `surface-container-low` background for the card body.
*   **Imagery:** App icons should have a 20% `primary` glow behind them to make them "pop" off the card.

### Input Fields
*   **Style:** Pill-shaped (Radius: `full`).
*   **Background:** `surface-container-highest` with a `ghost border` on focus using the `primary` color.
*   **Typography:** Use `body-lg` for input text to maintain the "chunky" friendly vibe.

### Signature Component: The "App Spotlight" Chip
A large-scale chip (48px height) using `tertiary_container` with `on_tertiary_container` text. This is used for AI-generated categories like "Focus Mode" or "Creative Spark."
 
---

## 6. Do’s and Don’ts

### Do:
*   **Use Asymmetry:** Allow a headline to overlap the edge of a card or an illustration to "break the container."
*   **Embrace White Space:** Use the `xl` spacing scale between sections to let the "boutique" products breathe.
*   **Color-Code Tones:** Use `secondary` (pink) for social/creative apps and `tertiary` (green) for productivity/health apps.

### Don't:
*   **Don't use 1px black or grey borders.** It kills the "vibrant boutique" vibe.
*   **Don't use "Drop Shadows."** Only use ambient, tinted glows.
*   **Don't use standard sans-serifs for headlines.** The "chunky serif" is our signature; using a sans-serif for headlines makes the app feel "standard."
*   **Don't crowd the UI.** If you think it needs a divider, it actually needs more margin.