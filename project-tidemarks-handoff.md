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

## Claude Code Scaffold Brief

*This section is written directly for Claude Code. The following is an explicit instruction set for scaffolding the initial Godot 4 project.*

### Project Setup

Create a new Godot 4 project named `tidemarks`. Initialise a Git repository in the project root. Use the following folder structure:

```
tidemarks/
├── AGENTS.md              ← Claude Code instructions (this section, condensed)
├── GDD.md                 ← Full game design document (this file)
├── CHANGELOG.md           ← Empty, ready for entries
├── project.godot
├── scenes/
│   ├── ui/
│   │   ├── MainMenu.tscn
│   │   ├── PortMarket.tscn
│   │   ├── VoyageStatus.tscn
│   │   ├── UpgradeShop.tscn
│   │   └── Ledger.tscn
│   ├── world/
│   │   └── WorldMap.tscn
│   └── components/
│       ├── GoodRow.tscn       ← Reusable single good buy/sell row
│       └── EventPopup.tscn    ← Voyage event result display
├── scripts/
│   ├── core/
│   │   ├── GameState.gd       ← Singleton: gold, ship, upgrades, active voyage
│   │   ├── Economy.gd         ← Singleton: port prices, hourly tick, forecasts
│   │   ├── VoyageManager.gd   ← Singleton: departure time, ETA, event resolution
│   │   └── SaveLoad.gd        ← Singleton: persist and restore game state
│   ├── ui/
│   │   ├── PortMarket.gd
│   │   ├── VoyageStatus.gd
│   │   ├── UpgradeShop.gd
│   │   └── Ledger.gd
│   └── world/
│       └── WorldMap.gd
├── data/
│   ├── ports.json             ← Port definitions (name, specialty, position)
│   ├── goods.json             ← Good definitions (name, base price, home port)
│   └── events.json            ← Event definitions (type, weight, effect)
└── assets/
    ├── fonts/
    └── placeholder/           ← Geometric shape assets go here
```

### Core Singletons (Autoloads)

Register the following as Autoloads in project settings:
- `GameState` → `scripts/core/GameState.gd`
- `Economy` → `scripts/core/Economy.gd`
- `VoyageManager` → `scripts/core/VoyageManager.gd`
- `SaveLoad` → `scripts/core/SaveLoad.gd`

### First Task — Prove the Core Loop

Before any UI polish, the first milestone is a working end-to-end loop in placeholder form:

1. **Economy system** — 4 ports, 6 goods, prices that update on an hourly tick, next-hour forecast calculated and stored
2. **Port market UI** — player can view current and next-hour prices, select a good, choose a quantity within cargo limit, confirm purchase
3. **Voyage dispatch** — player selects destination, departure timestamp is saved, ETA calculated and stored
4. **Voyage resolution** — on app open, VoyageManager checks if ETA has passed, fires a weighted random event, delivers cargo to destination port
5. **Sell interface** — player can sell held cargo at current port prices, gold is updated
6. **Save/load** — all state persists across sessions (gold, cargo, active voyage, timestamps)

This loop — buy, dispatch, return, sell — must work completely before anything else is built.

### Data Format Reference

**ports.json**
```json
[
  { "id": "port_haven", "name": "Haven", "specialty": "grain", "position": { "x": 100, "y": 150 } },
  { "id": "port_ironhold", "name": "Ironhold", "specialty": "iron", "position": { "x": 400, "y": 100 } },
  { "id": "port_thalwick", "name": "Thalwick", "specialty": "fish", "position": { "x": 300, "y": 350 } },
  { "id": "port_silkport", "name": "Silkport", "specialty": "cloth", "position": { "x": 150, "y": 300 } }
]
```

**goods.json**
```json
[
  { "id": "grain", "name": "Grain", "home_port": "port_haven", "base_price": 10 },
  { "id": "iron", "name": "Iron", "home_port": "port_ironhold", "base_price": 25 },
  { "id": "fish", "name": "Fish", "home_port": "port_thalwick", "base_price": 8 },
  { "id": "cloth", "name": "Cloth", "home_port": "port_silkport", "base_price": 18 },
  { "id": "spice", "name": "Spice", "home_port": null, "base_price": 40 },
  { "id": "timber", "name": "Timber", "home_port": null, "base_price": 15 }
]
```

**events.json**
```json
[
  { "id": "uneventful", "weight": 60, "type": "neutral", "effect": null },
  { "id": "pirates", "weight": 10, "type": "negative", "effect": { "cargo_loss_percent": 25 } },
  { "id": "storm", "weight": 5, "type": "negative", "effect": { "gold_loss_flat": 15 } },
  { "id": "salvage", "weight": 10, "type": "positive", "effect": { "bonus_good": "random", "bonus_qty": 2 } },
  { "id": "friendly_merchant", "weight": 10, "type": "positive", "effect": { "discount_next_port_percent": 10 } },
  { "id": "fair_winds", "weight": 5, "type": "positive", "effect": { "travel_time_reduction_percent": 25 } }
]
```

### AGENTS.md Content (Condensed for Claude Code)

When writing AGENTS.md for this repo, include:
- Engine: Godot 4, GDScript only
- No physics systems — this is a UI/menu-driven game
- All game state lives in Singletons (Autoloads)
- Economy runs on real-world device clock — do not use in-game timers for price ticks
- Voyage travel is timestamp-based: store Unix departure time and ETA, resolve on app open
- Save format: JSON via Godot's FileAccess
- Do not add combat, stamina, or monetization mechanics under any circumstances
- Do not add more than 4 ports or 8 goods without explicit instruction
- Placeholder art only — simple ColorRect and Label nodes are acceptable for V1
- Always update CHANGELOG.md on meaningful changes

---

## Open Questions (To Resolve in V2 Planning)

- What is the meta win condition? (Wealth target, fleet size, retire as guild master?)
- Does the merchant's ledger surface price history, or only voyage results?
- What do port names and identities look like? (Naming convention, visual personality)
- How does the reputation system work mechanically?

---

*Project Tidemarks — handoff document v0.1*
*Prepared from design sessions between Daulton Jenkins and Claude, April 2026*
