# Project Tidemarks
### Game Design Document, Roadmap & Claude Code Scaffold Brief
*Version 0.1 — Initial handoff*

---

## What This Document Is

This is the single source of truth for Project Tidemarks. It contains the full game concept, all confirmed design decisions, the V1 scope definition, a phased roadmap, and explicit instructions for Claude Code to scaffold the initial project. When in doubt, refer here.

---

## Concept Summary

**Project Tidemarks** is a casual mobile-first single-player nautical trading game with asynchronous real-time mechanics. The player is a merchant sea captain buying goods cheaply at one port and selling them at a profit at another, managing limited cargo, upgrading their ship, and building wealth over time.

The game is designed around short, meaningful play sessions of **3–5 minutes**. Open the app, read the market, make purchasing decisions, dispatch your ship, close the app. The ship travels in real time. The player returns later to collect results and repeat.

**Spiritual inspiration:** Tradewinds 2 (Raptisoft, ~2002). No assets, code, or direct content from that game are used — only the general merchant trading loop serves as a reference point.

**Closest modern comparators (for design research):**
- Merchant (mobile RPG) — async dispatch loop done right
- Baltic Merchants — direct nautical trading on mobile
- Merchant of the Skies — cozy premium trading, PC/mobile

---

## Design Pillars

1. **No time pressure.** The player is never punished for not playing. Voyages resolve in real time; the player comes back when ready.
2. **Meaningful micro-decisions.** Every session asks the player to read a live economy and make tradeoffs under limited cargo. Simple to learn, rewarding to master.
3. **Forecast-led strategy.** The next hour's prices are always visible. The core skill is reading the market one step ahead. This is the game's primary differentiator.
4. **Passive depth, not active complexity.** No twitch mechanics in V1. Strategy lives in planning, not execution.
5. **Ethical pacing.** No stamina systems, no pay-to-skip timers, no extractive mechanics. Ever.

---

## Confirmed Design Decisions

### Economy
- **4 ports** in V1, each with a trade specialty producing one category of goods cheaply
- **Prices update hourly** in real time, tied to the device clock
- **Next hour's prices are always visible** to the player — this is the core strategic layer
- Price fluctuations use a bounded stochastic model (not fully random, not fully predictable)
- Each port has a distinct identity that influences what it buys and sells

### Goods
- Small set of goods in V1 (suggested: 6–8 types)
- Examples: Grain, Timber, Cloth, Spice, Iron, Fish
- Each good is cheap at its "home" port and valuable elsewhere

### Voyage & Travel
- **Passive real-time travel timer** — approximately 10–15 minutes per voyage in V1
- No active sailing minigame in V1 (planned for V2)
- Player selects destination and dispatches — ship travels without interaction required
- Optional push notification when ship arrives at port

### Random Voyage Events
Events fire once per voyage with weighted probability:
- ~60% — Uneventful crossing
- ~25% — Positive event (bonus goods, discount at destination, salvage find, friendly escort)
- ~15% — Negative event (pirate raid loses some cargo, storm causes small repair fee, spoiled cargo)

**Important:** Events resolve automatically. No time-sensitive prompts. Player sees the result when they open the app. No retroactive choices. This is intentional.

### Cargo & Progression
Core constraint: the player starts with limited cargo capacity and upgrades over time.

| Upgrade | Effect | Approx. Cost Tier |
|---|---|---|
| Larger Hull | Increases cargo capacity | Early |
| Faster Sails | Reduces travel time | Mid |
| First Mate | Unlocks a second auto-dispatching ship | Late |

No combat system in V1. Combat is a future optional expansion — the core game must be satisfying without it.

### Merchant's Ledger (V1 Feature)
A simple in-game log showing past voyages: what was bought, where it was sold, profit/loss, and any events encountered. Turns accumulated experience into player-side advantage. Encourages return play and gives the player a sense of history.

---

## V1 Scope — "What Done Looks Like"

V1 is a complete, playable, self-contained game loop. Nothing more.

**V1 includes:**
- [ ] 4 ports on a simple 2D ocean map
- [ ] 6–8 tradeable goods with port-specific pricing
- [ ] Hourly real-time price updates with next-hour forecast visible
- [ ] Buy/sell market interface at each port
- [ ] Passive voyage timer (10–15 min) with departure/arrival state
- [ ] Weighted random voyage events (resolve on return)
- [ ] Cargo capacity limit enforced at purchase
- [ ] 3-tier upgrade system (hull, sails, first mate)
- [ ] Merchant's ledger (voyage history log)
- [ ] Basic save/load (persist voyage state, gold, upgrades across sessions)
- [ ] Flat geometric placeholder art — no polished assets required
- [ ] Android export functional (testable on device)

**V1 explicitly excludes:**
- Active sailing minigame
- Combat system
- Story or named characters
- Cloud save
- Monetization of any kind
- Polished art or animation
- Sound/music (optional stretch goal only)
- More than 4 ports

---

## Phased Roadmap

### V1 — Proof of Loop *(current target)*
Everything in the V1 scope above. Goal: a playable, self-contained game that proves the core economy loop is fun.

### V2 — Depth & Polish
- Active sailing minigame (optional speed boost, replaces passive wait if played)
- Port identity pass — each port has a name, visual personality, specialty flavour text
- Expanded event library (10–15 distinct events with cargo-type weighting)
- Haggling system — minor price negotiation at market
- Reputation system — repeat visits to a port improve buy/sell rates over time
- Sound and ambient music layer
- Polished art pass (still 2D, but intentional visual style)

### V3 — Expansion
- 2 additional ports (6 total)
- Combat encounter system (opt-in, pirate boarding events with simple resolution)
- Fleet management — multiple ships with assigned auto-routes
- Seasonal economy shifts (prices follow longer multi-day cycles in addition to hourly)
- Cloud save / cross-device continuity

---

## Technical Decisions

| Decision | Choice | Reason |
|---|---|---|
| Engine | Godot 4 | Menu-driven UI, 2D map, mobile export, GDScript pairs well with agentic coding |
| Platform | Android (primary), Web/PWA (secondary) | Mobile-first session design |
| Architecture | Local-first | No mandatory backend; persist voyage timestamps and resolve on app open |
| Art style | Flat geometric placeholder → intentional 2D style (V2) | Keeps V1 scope tight |
| Save system | Godot built-in save/load with JSON | Simple, no external dependency |
| Time authority | Device clock in V1; optional trusted time check in V2 | Acceptable for hobby release |

---

## Open Questions (To Resolve in V2 Planning)

- What is the meta win condition? (Wealth target, fleet size, retire as guild master?)
- Does the merchant's ledger surface price history, or only voyage results?
- What do port names and identities look like? (Naming convention, visual personality)
- How does the reputation system work mechanically?

---

*Project Tidemarks — handoff document v0.1*
*Prepared from design sessions between Daulton Jenkins and Claude, April 2026*
