# Project Tidemarks
### Game Design Document, Roadmap & Claude Code Scaffold Brief
*Version 0.2 — Post-brainstorm revision, April 2026*

---

## Changelog (v0.1 → v0.2)

- **Removed** specialized port economies. No port has a fixed commodity specialty.
- **Added** dynamic floating prices with port tendencies and supply shocks.
- **Added** Port Dispatch Board feature (V2).
- **Added** Navy Contract as zero-gold safety net mechanic.
- **Revised** meta goal from implicit to explicit: open-ended incremental progression.
- **Revised** First Mate and multi-ship model: all ships are fully manual, no auto-dispatch.
- **Added** map-centric UI model with port-tap navigation and notification layer.
- **Revised** travel times: fixed per route per upgrade tier, absolute and shown at dispatch.
- **Expanded** upgrade tree from 3 tiers to a multi-rung ladder.
- **Added** skilled play definition: route chaining and mixed-cargo load planning.
- **Updated** goods.json to remove home_port field.
- **Updated** open questions to reflect resolved items and flag balance as next priority.

---

## What This Document Is

This is the single source of truth for Project Tidemarks. It contains the full game concept, all confirmed design decisions, the V1 scope definition, a phased roadmap, and explicit instructions for Claude Code to scaffold the initial project. When in doubt, refer here.

---

## Concept Summary

**Project Tidemarks** is a casual mobile-first single-player nautical trading game with asynchronous real-time mechanics. The player is a merchant sea captain reading live markets across four ports, buying goods, dispatching their ship, and returning later to sell at a profit. Over time they upgrade their ship, reduce travel times, improve margins, and eventually command a small fleet.

The game is designed around short, meaningful play sessions of **3–5 minutes**. Open the app, read the market, make purchasing decisions, dispatch your ship, close the app. The ship travels in real time. The player returns later to collect results and repeat. At fleet scale, sessions may naturally extend to 10–15 minutes as multiple ships require attention — this is intentional and earned, not forced.

**Progression model:** Open-ended incremental accumulation. There is no win condition, no prestige reset, no failure state. The motivation is the classic incremental loop — make numbers go up, unlock the next upgrade, run a more efficient operation. The game is designed to be enjoyed for days or weeks of casual play, not indefinitely. Attention falling off over time is acceptable and expected.

**Spiritual inspiration:** Tradewinds 2 (Raptisoft, ~2002) and Puzzle Pirates (Three Rings). No assets, code, or direct content from those games are used — only general merchant trading and navy contract mechanics serve as reference points.

**Closest modern comparators (for design research):**
- Everdale / Heyday — open-ended accumulation loop without a win state
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
6. **Numbers go up.** The upgrade ladder is the win condition. Every session should end with the player either closer to the next upgrade or already celebrating one.

---

## Confirmed Design Decisions

### Economy

- **4 ports** in V1, each positioned on a 2D map at fixed coordinates
- **No specialized port economies.** Any port can buy or sell any good at any price. There is no "timber port" or "spice port."
- **Port tendencies** exist as soft, emergent patterns — a port may statistically favour certain goods more often, but this is never guaranteed and never displayed explicitly. Experienced players discover tendencies through observation and the Merchant's Ledger.
- **Prices update hourly** in real time, tied to the device clock
- **Next hour's prices are always visible** to the player — this is the core strategic layer
- **Price fluctuations** use a bounded stochastic model (not fully random, not fully predictable). Prices move within defined min/max bands per good per port, with gradual drift and occasional supply shocks.
- **Supply shocks** are emergent price events — a port's price for a specific good spikes or crashes for a window of hours due to in-world reasons (storm hit a fleet, dock construction, trade surge). The forecast reflects the effect. Supply shocks give ports personality without requiring fixed identities.

### Port Dispatch Board *(V2)*

Each port has a Dispatch Board — a small notice surface showing occasional forward-looking demand signals. Examples:

- *"Ironhold is expanding its docks. Timber demand expected to rise over the next few hours."*
- *"A fishing fleet returned early to Thalwick. Fish prices likely to drop."*

These are signals, not guarantees. Skilled players route around them. Casual players can ignore them entirely. The board is the in-world explanation for why next-hour forecasts sometimes show unusual movement. It gives ports emergent personality without named characters or a story.

### Goods

- Small set of goods in V1: **6–8 types**
- Confirmed goods: Grain, Timber, Cloth, Spice, Iron, Fish
- No good has a fixed home port. All goods float freely across all ports.
- Price spreads between ports create the trading opportunity. Skilled play means finding the spread, not memorising a route.

### Voyage & Travel

- **Passive real-time travel timer** — travel times are fixed per route in V1 and scale with map distance. Short routes: ~10–15 minutes. Long routes: ~30–45 minutes.
- **Travel times are absolute.** Once a ship is dispatched, the timer shown at departure is a promise. Nothing alters an in-flight voyage — no weather variation, no random delay.
- Speed upgrades reduce the timer **at dispatch**, not mid-voyage. Upgrading sails means your *next* voyage quotes a shorter time.
- No active sailing minigame in V1 (planned for V2).
- Player selects destination and dispatches — ship travels without interaction required.
- Optional push notification when ship arrives at port.

### Skilled Play

The gap between a skilled and casual player is **route chaining and mixed-cargo planning**, not reaction speed or market memory. A skilled player:

- Loads mixed cargo targeting multiple ports in sequence, avoiding backtracking
- Buys a good at Port A destined for Port C even when their immediate destination is Port B — because Port C is nearby and the margin is worth it
- Plans two or three stops ahead using forecast data and travel times
- Knows when *not* to fill cargo — leaving room for an opportunity at the next port

This skill expression is natural, learnable, and never explicitly tutorialised. Players discover it through the Merchant's Ledger and pattern recognition.

### Random Voyage Events

Events fire once per voyage with weighted probability:

- ~60% — Uneventful crossing
- ~25% — Positive event (bonus goods, discount at destination, salvage find, friendly escort)
- ~15% — Negative event (pirate raid loses some cargo, storm causes small repair fee, spoiled cargo)

**Important:** Events resolve automatically. No time-sensitive prompts. Player sees the result when they open the app. No retroactive choices. This is intentional.

### Navy Contract (Zero-Gold Safety Net)

If the player reaches zero gold with no cargo and no goods in transit, they are offered the option to **sail with the navy**. This is a voluntary contract — the player works as a deckhand aboard a naval vessel (transporting supplies, manning the rigging — no combat, no fighting). Mechanics:

- The player's captain is unavailable for **20 minutes**
- No ships can be dispatched during this time
- On return, the player receives a modest flat gold payment — enough to purchase a small starting cargo and resume trading
- The payout is deliberately low compared to a normal voyage of equivalent time — this is a rescue mechanism, not a shortcut

The navy contract exists so no player ever feels permanently stuck. It is always available at zero gold. It is never the optimal play.

### Multi-Ship Management

Additional ships are unlocked through the upgrade ladder (see Upgrade Ladder below). All ships are **fully manual** — the player controls every dispatch and sell decision for every ship.

At fleet scale, the player manages multiple ships simultaneously using the **map-centric UI** (see UI Model below). Sessions naturally become longer as fleet size grows. This is intentional — it reflects progression, not scope creep.

### Map-Centric UI Model

The primary game interface is a **2D scrollable world map** showing all ports and all ships.

- Ships en route are shown mid-map with a visible countdown timer
- Ships docked at port are shown anchored at that port
- **Notification layer on the map:** ports show a status icon at a glance
  - ⚓ Anchor icon — one or more ships docked, awaiting action
  - 💰 Coin icon — cargo ready to sell
  - (No icon) — en route, nothing to do here yet

Tapping a port opens the **Port Window**, which shows:
- Current buy/sell prices for all goods
- Next hour's forecast prices
- List of all ships currently docked at this port

Tapping a docked ship opens the **Ship Cargo Window**, which shows:
- Current cargo manifest with +/− controls for buying/selling individual goods
- Option to dispatch to a selected destination (shows travel time at current upgrade tier)

This model scales cleanly from one ship to five without requiring a separate fleet management screen.

### Cargo & Progression — Upgrade Ladder

Progression is an open-ended ladder with no hard cap. Approximate tier structure:

| Tier | Upgrade | Effect |
|---|---|---|
| 1 | Larger Hull I | +4 cargo slots |
| 2 | Swifter Sails I | −10% travel time on all routes |
| 3 | Larger Hull II | +6 cargo slots |
| 4 | Haggling I | 5% better buy prices across all ports |
| 5 | Swifter Sails II | −10% travel time (cumulative −20%) |
| 6 | Home Port Charter | 10% discount at one chosen port, permanent and unchangeable |
| 7 | First Mate | Unlocks Ship 2 (fully manual) |
| 8 | Larger Hull III | +8 cargo slots |
| 9 | Haggling II | Additional 3% better buy prices |
| 10 | Swifter Sails III | −10% travel time (cumulative −30%) |
| 11 | Second Mate | Unlocks Ship 3 (fully manual) |
| ... | Additional ships, hull tiers, haggling tiers | Costs scale steeply |

Exact gold costs are TBD — balance pass is the next design priority after this document is finalised.

No combat system in V1. Combat is a future optional expansion — the core game must be satisfying without it.

### Merchant's Ledger (V1 Feature)

A simple in-game log showing past voyages: what was bought, where it was sold, profit/loss, and any events encountered. Turns accumulated experience into player-side advantage — skilled players use it to spot port tendencies and price patterns. Encourages return play and gives the player a sense of history.

---

## V1 Scope — "What Done Looks Like"

V1 is a complete, playable, self-contained game loop. Nothing more.

**V1 includes:**
- [ ] 4 ports on a 2D scrollable ocean map with variable distances between them
- [ ] 6–8 tradeable goods with dynamic floating prices (no port specialisation)
- [ ] Bounded stochastic price model with occasional supply shocks
- [ ] Hourly real-time price updates with next-hour forecast visible
- [ ] Map-centric UI with port notification layer (anchor, coin icons)
- [ ] Port Window: buy/sell market interface with current and forecast prices
- [ ] Ship Cargo Window: +/− cargo controls, dispatch interface showing fixed travel time
- [ ] Passive voyage timer (distance-based, fixed per route) with departure/arrival state
- [ ] Weighted random voyage events (resolve on return)
- [ ] Cargo capacity limit enforced at purchase
- [ ] Upgrade ladder (Tiers 1–6, pre-fleet) with correct cost scaling
- [ ] Navy Contract mechanic (available at zero gold)
- [ ] Merchant's Ledger (voyage history log)
- [ ] Basic save/load (persist voyage state, gold, upgrades across sessions)
- [ ] Flat geometric placeholder art — no polished assets required
- [ ] Android export functional (testable on device)

**V1 explicitly excludes:**
- Multi-ship fleet (First Mate and beyond — V2 target)
- Port Dispatch Board
- Active sailing minigame
- Combat system
- Story or named characters
- Cloud save
- Monetization of any kind
- Polished art or animation
- Sound/music (optional stretch goal only)
- More than 4 ports
- More than 8 goods

---

## Phased Roadmap

### V1 — Proof of Loop *(current target)*
Everything in the V1 scope above. Goal: a playable, self-contained game that proves the core economy loop is fun and the forecast mechanic creates meaningful decisions.

### V2 — Depth & Polish
- Fleet expansion: First Mate (Ship 2), Second Mate (Ship 3) — all manual
- Port Dispatch Board — forward-looking demand signals at each port
- Port identity pass — each port has a name, visual personality, specialty flavour text
- Active sailing minigame (optional speed boost, replaces passive wait if played)
- Expanded event library (10–15 distinct events with cargo-type weighting)
- Haggling system — minor price negotiation at market
- Reputation system — repeat visits to a port improve buy/sell rates over time
- Sound and ambient music layer
- Polished art pass (still 2D, but intentional visual style)

### V3 — Expansion
- 2 additional ports (6 total)
- Combat encounter system (opt-in, pirate boarding events with simple resolution)
- Fleet management beyond 3 ships
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
| Price model | Bounded stochastic with per-port per-good min/max bands | Predictable enough for forecasting, variable enough to avoid solved routes |

---

## Claude Code Scaffold Brief

*This section is written directly for Claude Code. The following is an explicit instruction set for scaffolding the initial Godot 4 project.*

### Project Setup

Create a new Godot 4 project named `tidemarks`. Initialise a Git repository in the project root. Use the following folder structure:

```
tidemarks/
├── AGENTS.md
├── GDD.md
├── CHANGELOG.md
├── project.godot
├── scenes/
│   ├── ui/
│   │   ├── MainMenu.tscn
│   │   ├── PortWindow.tscn
│   │   ├── ShipCargoWindow.tscn
│   │   ├── VoyageStatus.tscn
│   │   ├── UpgradeShop.tscn
│   │   ├── NavyContract.tscn
│   │   └── Ledger.tscn
│   ├── world/
│   │   └── WorldMap.tscn
│   └── components/
│       ├── GoodRow.tscn
│       ├── ShipMarker.tscn
│       ├── PortMarker.tscn
│       └── EventPopup.tscn
├── scripts/
│   ├── core/
│   │   ├── GameState.gd
│   │   ├── Economy.gd
│   │   ├── VoyageManager.gd
│   │   └── SaveLoad.gd
│   ├── ui/
│   │   ├── PortWindow.gd
│   │   ├── ShipCargoWindow.gd
│   │   ├── VoyageStatus.gd
│   │   ├── UpgradeShop.gd
│   │   ├── NavyContract.gd
│   │   └── Ledger.gd
│   └── world/
│       └── WorldMap.gd
├── data/
│   ├── ports.json
│   ├── goods.json
│   └── events.json
└── assets/
    ├── fonts/
    └── placeholder/
```

### Core Singletons (Autoloads)

Register the following as Autoloads in project settings:
- `GameState` → `scripts/core/GameState.gd`
- `Economy` → `scripts/core/Economy.gd`
- `VoyageManager` → `scripts/core/VoyageManager.gd`
- `SaveLoad` → `scripts/core/SaveLoad.gd`

### First Task — Prove the Core Loop

Before any UI polish, the first milestone is a working end-to-end loop in placeholder form:

1. **Economy system** — 4 ports, 6 goods, prices that update on an hourly tick with bounded stochastic movement, next-hour forecast calculated and stored
2. **World map UI** — scrollable 2D map with port markers, ship markers, and notification icons (anchor/coin) on ports that require attention
3. **Port window** — tapping a port shows current and forecast prices for all goods, plus a list of docked ships
4. **Ship cargo window** — tapping a docked ship shows its cargo with +/− buy/sell controls and a dispatch interface that displays the fixed travel time to each destination
5. **Voyage dispatch** — player selects destination, departure timestamp and fixed ETA are saved and displayed
6. **Voyage resolution** — on app open, VoyageManager checks all active voyages, resolves any that have passed ETA, fires weighted random events, delivers cargo
7. **Save/load** — all state persists across sessions (gold, cargo per ship, active voyages, timestamps, upgrade tier)

This loop — buy, dispatch, return, sell — must work completely before anything else is built.

### Data Format Reference

**ports.json**
```json
[
  { "id": "port_haven", "name": "Haven", "position": { "x": 100, "y": 150 } },
  { "id": "port_ironhold", "name": "Ironhold", "position": { "x": 400, "y": 100 } },
  { "id": "port_thalwick", "name": "Thalwick", "position": { "x": 300, "y": 350 } },
  { "id": "port_silkport", "name": "Silkport", "position": { "x": 150, "y": 300 } }
]
```

**goods.json**
```json
[
  { "id": "grain", "name": "Grain", "base_price": 10, "price_min": 6, "price_max": 18 },
  { "id": "iron", "name": "Iron", "base_price": 25, "price_min": 15, "price_max": 40 },
  { "id": "fish", "name": "Fish", "base_price": 8, "price_min": 4, "price_max": 14 },
  { "id": "cloth", "name": "Cloth", "base_price": 18, "price_min": 10, "price_max": 28 },
  { "id": "spice", "name": "Spice", "base_price": 40, "price_min": 25, "price_max": 65 },
  { "id": "timber", "name": "Timber", "base_price": 15, "price_min": 8, "price_max": 25 }
]
```

*Note: price_min/price_max define the bounded stochastic range. Exact per-port price seeding and drift algorithm TBD in balance pass.*

**events.json**
```json
[
  { "id": "uneventful", "weight": 60, "type": "neutral", "effect": null },
  { "id": "pirates", "weight": 10, "type": "negative", "effect": { "cargo_loss_percent": 25 } },
  { "id": "storm", "weight": 5, "type": "negative", "effect": { "gold_loss_flat": 15 } },
  { "id": "salvage", "weight": 10, "type": "positive", "effect": { "bonus_good": "random", "bonus_qty": 2 } },
  { "id": "friendly_merchant", "weight": 10, "type": "positive", "effect": { "discount_next_port_percent": 10 } },
  { "id": "fair_winds", "weight": 5, "type": "positive", "effect": { "travel_time_reduction_percent": 0 } }
]
```

*Note: fair_winds travel_time reduction is 0 in V1 because travel times are fixed and absolute. This event can be repurposed in V2 (e.g. bonus gold, morale effect). Placeholder weight kept to avoid restructuring the event table.*

### AGENTS.md Content (Condensed for Claude Code)

When writing AGENTS.md for this repo, include:
- Engine: Godot 4, GDScript only
- No physics systems — this is a UI/menu-driven game
- All game state lives in Singletons (Autoloads)
- Economy runs on real-world device clock — do not use in-game timers for price ticks
- Voyage travel is timestamp-based: store Unix departure time and fixed ETA, resolve on app open
- Travel times are fixed per route and must not be altered mid-voyage under any circumstances
- All ships are fully manual — no auto-dispatch logic
- Save format: JSON via Godot's FileAccess
- Do not add combat, stamina, or monetization mechanics under any circumstances
- Do not add port commodity specialisations — all goods float freely at all ports
- Do not add more than 4 ports or 8 goods without explicit instruction
- Placeholder art only — simple ColorRect and Label nodes are acceptable for V1
- Always update CHANGELOG.md on meaningful changes

---

## Open Questions (Balance Pass — Next Priority)

The following require concrete numbers before the economy system can be implemented. These are the focus of the next design session.

- **Starting gold** — How much does the player begin with? Enough to buy a meaningful first cargo without skipping the learning curve.
- **Starting cargo capacity** — How many slots? What does one slot represent (one unit of one good)?
- **Price spread** — What is the typical buy/sell spread between ports on the same good at the same hour? What is a "good" trade vs. a "bad" one in percentage terms?
- **Voyage profit target** — What should a skilled player earn per voyage at base stats? What does that look like at max upgrades?
- **Upgrade costs** — What is the gold cost of each upgrade tier, and how many voyages should it take to afford each one at typical earnings?
- **Navy contract payout** — How much gold does the navy contract pay? Should be enough to buy ~2–3 units of the cheapest good, no more.
- **Event gold values** — The storm costs 15 gold flat. Is that calibrated against starting gold and typical earnings? Probably not yet.
- **Supply shock parameters** — How much does a shock move the price, and for how many hours does it persist?
- **Port distance table** — Exact travel times in minutes for every port-to-port route in V1 (6 routes for 4 ports).

---

*Project Tidemarks — GDD v0.2*
*Revised from brainstorming session between Daulton Jenkins and Claude, April 2026*
